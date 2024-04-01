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
//---
int skt;
//+------------------------------------------------------------------+
//| Service program start function                                   |
//+------------------------------------------------------------------+
int OnStart()
  {
   Print(__FILE__ + " : " + __FUNCTION__);
   Print("MQTT Subscribe Service started");
//---
   uchar conn_pkt[];
   CConnect *conn = new CConnect(host, port);
   conn.SetCleanStart(true);
   conn.SetKeepAlive(3600);
   conn.SetClientIdentifier("MT5_SUB");
   conn.Build(conn_pkt);
   ArrayPrint(conn_pkt);
//---
   uchar sub_pkt[];
   CSubscribe *sub = new CSubscribe();
   sub.SetTopicFilter("MyBITCOIN");
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
      Print("Failed sending subscribe ", GetLastError());
      SocketClose(skt);
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
     {
      Print("Subscribed");
     }
   if(rsp[5] > 2)  // Suback Reason Code (Granted QoS 2)
     {
      Print("Subscription Refused with error code %d ", rsp[4]);
      return false;
     }
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
            if((len = SocketRead(skt, inpkt, len, timeout)) > 0)
              {
               msg += CPublish().ReadMessage(inpkt);
               WriteToChart(msg);
               //---
               printf("published len %d", inpkt.Size());
               Print("=== inpkt ===");
               ArrayPrint(inpkt);
               printf("msg %s", msg);
              }
           }
        }
      while(SocketIsReadable(skt) && !IsStopped() && !_LastError);
     }
   if(_LastError)
     {
      Print("Error reading msg: %d", GetLastError());
     }
   SocketClose(skt);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SendConnect(const string h, const int p, uchar &pkt[])
  {
   skt = SocketCreate();
   if(skt != INVALID_HANDLE)
     {
      if(SocketConnect(skt, h, p, 1000))
        {
         Print("Socket Connected ", h);
        }
     }
   if(SocketSend(skt, pkt, ArraySize(pkt)) < 0)
     {
      Print("Failed sending connect ", GetLastError());
     }
//---
   char rsp[];
   SocketRead(skt, rsp, 4, 1000);
   if(rsp[0] >> 4 != CONNACK)
     {
      Print("Not Connect acknowledgment");
      return -1;
     }
   if(rsp[3] != MQTT_REASON_CODE_SUCCESS)  // Connect Return code (Connection accepted)
     {
      Print("Connection Refused");
      return -1;
     }
   ArrayPrint(rsp);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteToChart(string new_rates)
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
   if(CustomRatesUpdate("MyBITCOIN", rates) < 1)
     {
      Print("CustomRatesUpdate failed: ", _LastError);
     }
  }
//+------------------------------------------------------------------+
