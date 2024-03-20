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
void OnStart()
  {
// 10 16 00 04 4d 51 54 54 05 01 00 10 05 17 00 00 00 10
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
   pkt[10] = 0;
   pkt[11] = 10; // keep alive 60sec
   pkt[12] = 0; // prop len
   pkt[13] = 0;
   pkt[14] = 3; // client ID
   pkt[15] = 'M';
   pkt[16] = 'T';
   pkt[17] = '5';
   ArrayPrint(pkt);
   int skt = SocketCreate();
   if(Connect(skt, pkt))
     {
      Publish(skt);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Publish(int skt)
  {
   uchar pkt[];
   ArrayResize(pkt, 8);
   pkt[0] = 48;
   pkt[1] = 6;
   pkt[2] = 0; // topic name
   pkt[3] = 1;
   pkt[4] = 't';
   pkt[5] = 0; // props len
   pkt[6] = 'm'; // payload
   pkt[7] = '5';
   ArrayPrint(pkt);
//pkt[5] = 0; // if QoS > 0 ==> packet ID
//pkt[6] = 1;
//pkt[7] = 2;
   if(SocketSend(skt, pkt, ArraySize(pkt)) < 0)
     {
      Print("Failed sending publish ", GetLastError());
      return false;
     }
//---
   char rsp[];
   uint len = SocketIsReadable(skt);
   SocketRead(skt, rsp, 40, 1000);
   ArrayPrint(rsp);
   if(rsp[0] >> 4 != PUBACK)
     {
      Print("Not Publish acknowledgment");
      return false;
     }
   if(rsp[3] != MQTT_REASON_CODE_SUCCESS)  // Publish Return code (Publication accepted)
     {
      Print("Publication Refused");
      return false;
     }
   if(skt != INVALID_HANDLE)
     {
      SocketClose(skt);
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Connect(int skt, uchar & pkt[])
  {
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
   uint len = SocketIsReadable(skt);
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

//+------------------------------------------------------------------+
