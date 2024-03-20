//+------------------------------------------------------------------+
//|                                                      connect.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <MQTT\MQTT.mqh>

string broker_host = "172.20.106.92";
int broker_port = 80;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int OnStart()
  {
   uchar pkt[];
   ArrayResize(pkt, 18);
   pkt[0] = 16;
   pkt[1] = 16;
   pkt[2] = 0;
   pkt[3] = 4;
   pkt[4]  = 'M';
   pkt[5] = 'Q';
   pkt[6] = 'T';
   pkt[7] = 'T';
   pkt[8] = 5; // MQTT 5.0
   pkt[9] = 2; // clean start
   pkt[10] = 28;
   pkt[11] = 2; // keep alive 7200sec
   pkt[12] = 0; // prop len
   pkt[13] = 0;
   pkt[14] = 3; // client ID
   pkt[15] = 'M';
   pkt[16] = 'T';
   pkt[17] = '5';
   ArrayPrint(pkt);
   int skt = SocketCreate();
   if(!Connect(skt, pkt))
     {
      return -1;
     }
   if(!Subscribe(skt))
     {
      return -1;
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Subscribe(int skt)
  {
   Print(__FUNCTION__);
   uchar pkt[];
   ArrayResize(pkt, 9);
   pkt[0] = 0x82; // (130)
   pkt[1] = 7;
   pkt[2] = 0; // packet ID
   pkt[3] = 1;
   pkt[4] = 0; // props len
   pkt[5] = 0; // first topic name
   pkt[6] = 1;
   pkt[7] = 't';
   pkt[8] = 0; // subscription options (max QoS 2)
   ArrayPrint(pkt);
//---
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
         uchar received_publish_pkt[];
         string msg = "";
         uint to_read = SocketIsReadable(skt);
         if(to_read)
           {
            int published_len;
            published_len = SocketRead(skt, received_publish_pkt, to_read, timeout);
            printf("published len %d", published_len);
            string tmp = CharArrayToString(received_publish_pkt);
            StringAdd(msg, tmp);
            Print("=== rcv pkt ===");
            ArrayPrint(received_publish_pkt);
            if(StringLen(msg) > 0)
              {
               printf("msg %s", msg);
              }
           }
        }
      while(SocketIsReadable(skt));
     }
   SocketClose(skt);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Connect(int skt, uchar & pkt[])
  {
   Print(__FUNCTION__);
   if(skt != INVALID_HANDLE)
     {
      if(SocketConnect(skt, broker_host, broker_port, 1000))
        {
         Print("Connected ", broker_host);
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
      return false;
     }
   if(rsp[3] != MQTT_REASON_CODE_SUCCESS)  // Connect Return code (Connection accepted)
     {
      Print("Connection Refused");
      return false;
     }
   ArrayPrint(rsp);
   return true;
  }
//+------------------------------------------------------------------+
