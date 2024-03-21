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
   pkt[10] = 0;
   pkt[11] = 10; // keep alive 60sec
   pkt[12] = 0; // prop len
   pkt[13] = 0;
   pkt[14] = 3; // client ID
   pkt[15] = 'P';
   pkt[16] = 'U';
   pkt[17] = 'B';
   ArrayPrint(pkt);
   int skt = SocketCreate();
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
      return -1;
     }
   if(rsp[3] != MQTT_REASON_CODE_SUCCESS)  // Connect Return code (Connection accepted)
     {
      Print("Connection Refused");
      return -1;
     }
   ArrayPrint(rsp);
//=========================== PUBLISH
   if(!Publish(skt))
     {
      return -1;
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Publish(int skt)
  {
   Print(__FUNCTION__);
   uchar pkt[];
   ArrayResize(pkt, 8);
   pkt[0] = 48;
   pkt[1] = 6;
   pkt[2] = 0; // topic name
   pkt[3] = 1;
   pkt[4] = 't';
   pkt[5] = 0; // props len
   pkt[6] = 'H'; // payload
   pkt[7] = 'i';
   ArrayPrint(pkt);
//pkt[5] = 0; // if QoS > 0 ==> packet ID
//pkt[6] = 1;
//pkt[7] = 2;
   if(skt == INVALID_HANDLE)
     {
      Print("Socket is INVALID on " + __FUNCTION__);
     }
   if(!SocketIsConnected(skt))
     {
      Print("Socket is NOT connected on " + __FUNCTION__);
     }
   if(!SocketIsWritable(skt))
     {
      Print("Error on " + __FUNCTION__ + ": Socket not writable");
      SocketClose(skt);
      return false;
     }
   if(SocketSend(skt, pkt, ArraySize(pkt)) < 0)
     {
      Print("Failed sending publish ", GetLastError());
      SocketClose(skt);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
