//+------------------------------------------------------------------+
//|                                             mqtt_sub_service.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <MQTT\MQTT.mqh>
#include <MQTT\Connect.mqh>
#include <MQTT\Subscribe.mqh>
#include <MQTT\Publish.mqh>

#property service

//--- input parameters
input string   host = "172.20.106.92";
input int      port = 80;
//--- global vars
int skt;
CConnect *conn;
CSubscribe *sub;
//+------------------------------------------------------------------+
//| Service program start function                                   |
//+------------------------------------------------------------------+
int OnStart()
  {
   Print(__FILE__ + " : " + __FUNCTION__);
   Print("MQTT Subscribe Service started");
//---
   uchar conn_pkt[];
   conn = new CConnect(host, port);
   conn.SetCleanStart(true);
   conn.SetKeepAlive(3600);
   conn.SetClientIdentifier("MT5_SUB");
   conn.Build(conn_pkt);
   ArrayPrint(conn_pkt);
//---
   uchar sub_pkt[];
   sub = new CSubscribe();
   sub.SetTopicFilter("MySPX500");
   sub.Build(sub_pkt);
   ArrayPrint(sub_pkt);
//---
   if(SendConnect(host, port, conn_pkt) == 0)
     {
      Print("Client connected ", host);
     }
   if(!SendSubscribe(sub_pkt))
     {
      return -1;
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SendSubscribe(uchar &pkt[])
  {
   if(SocketSend(skt, pkt, ArraySize(pkt)) < 0)
     {
      Print("Failed sending SUBSCRIBE ", GetLastError());
      CleanUp();
      return false;
     }
//---
   char rsp[];
   uint timeout = 5000;
   do
     {
      uint len = SocketIsReadable(skt);
      if(len)
        {
         int rsp_len;
         rsp_len = SocketRead(skt, rsp, len, timeout);
         printf("response len %d", rsp_len);
        }
     }
   while(SocketIsReadable(skt));
//---
   ArrayPrint(rsp);
   if(((rsp[0] >> 4) & SUBACK) != SUBACK)
     {
      Print("Not Subscribe acknowledgment");
     }
   else
      Print("Subscribed");
   if(rsp[5] > 2)  // Suback Reason Code (Granted QoS 2)
     {
      Print("Subscription Refused with error code %d ", rsp[4]);
      CleanUp();
      return false;
     }
//---
   for(;;)
     {
      do
        {
         ResetLastError();
         uchar inpkt[];
         string msg = "";
         int len;
         if(!(len = (int)SocketIsReadable(skt)))
           {
            Sleep(1000);
           }
         else
           {
            // printf("len: %d", len);
            // TODO
            // len > 0 should be enough. This is a workaround
            // for a curious behavior where sometimes len is 1
            // even when the inpkt array is full of data.
            // We MUST check it.
            if((len = SocketRead(skt, inpkt, len, timeout)) > 1)
              {
               ArrayPrint(inpkt);
               msg += CPublish().ReadMessageRawBytes(inpkt);
               printf("New quote arrived for MySPX500: %s", msg);
               UpdateRates(msg);
              }
           }
        }
      while(SocketIsReadable(skt) && !IsStopped() && !_LastError);
     }
//---
   if(_LastError)
     {
      Print("Error reading msg: %d", GetLastError());
     }
   CleanUp();
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SendConnect(const string h, const int p, uchar &pkt[])
  {
   skt = SocketCreate();
   if(skt != INVALID_HANDLE && SocketConnect(skt, h, p, 1000))
     {
      Print("Socket Connected ", h);
     }
   if(!SocketSend(skt, pkt, ArraySize(pkt)) > 0)
     {
      Print("Failed sending CONNECT ", GetLastError());
      CleanUp();
     }
//---
   char rsp[];
   SocketRead(skt, rsp, 4, 1000);
   if(rsp[0] >> 4 != CONNACK)
     {
      Print("Not Connect acknowledgment");
      CleanUp();
      return -1;
     }
   if(rsp[3] != MQTT_REASON_CODE_SUCCESS)  // Connect Return code (Connection accepted)
     {
      Print("Connection Refused");
      CleanUp();
      return -1;
     }
   ArrayPrint(rsp);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateRates(string new_rates)
  {
   string new_rates_arr[];
   StringSplit(new_rates, 45, new_rates_arr);
   MqlRates rates[1];
   rates[0].time = StringToTime(new_rates_arr[0]);
   rates[0].open = StringToDouble(new_rates_arr[1]);
   rates[0].high = StringToDouble(new_rates_arr[2]);
   rates[0].low = StringToDouble(new_rates_arr[3]);
   rates[0].close = StringToDouble(new_rates_arr[4]);
   rates[0].tick_volume = StringToInteger(new_rates_arr[5]);
   rates[0].spread = 0;
   rates[0].real_volume = StringToInteger(new_rates_arr[6]);
   if(CustomRatesUpdate("MySPX500", rates) < 1)
     {
      Print("CustomRatesUpdate failed: ", _LastError);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CleanUp()
  {
   delete sub;
   delete conn;
   SocketClose(skt);
  }
//+------------------------------------------------------------------+
