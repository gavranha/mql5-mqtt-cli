//+------------------------------------------------------------------+
//|                                                  TestConnect.mq5 |
//+------------------------------------------------------------------+

#include <MQTT\MQTT.mqh>
#include <MQTT\Connect.mqh>
#include "..\MQTT\Tests\TestUtil.mqh"


string broker_host = "172.20.106.92";
int broker_port = 80;
//int socket;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   int socket = SocketCreate();
//---
   if(socket != INVALID_HANDLE)
     {
      if(SocketConnect(socket, broker_host, broker_port, 1000))
        {
         Print("Connected ", broker_host);
         //---
         uchar pkt[] = {10, 0x0c, 00, 04, 0x4d, 51, 54, 54, 04, 02, 00, 0x3c, 00, 00};
         //CConnect *conn = new CConnect();
         //conn.SetCleanStart(true);// {16, 8, 0, 4, 'M', 'Q', 'T', 'T', 4, 2};
         //conn.SetKeepAlive(10);
         //conn.SetClientIdentifier("MQL5");// {16, 16, 0, 4, 'M', 'Q', 'T', 'T', 5, 2, 0, 10, 0, 4, 'M', 'Q', 'L', '5'};
         //conn.Build(pkt);
         //delete(conn);
         uchar fixhead[];
         ArrayResize(fixhead, 2);
         ArrayCopy(fixhead, pkt, 0, 0, 2);
         ArrayPrint(fixhead);
         uchar varhead[];
         ArrayResize(varhead, 12);
         ArrayCopy(varhead, pkt, 0, 2, 12);
         ArrayPrint(varhead);
         //---
         //if(SocketSend(socket, fixhead, ArraySize(fixhead)) < 0)
         //  {
         //   Print("Failed sending fixhead ", GetLastError());
         //  }
         //if(SocketSend(socket, varhead, ArraySize(varhead)) < 0)
         //  {
         //   Print("Failed sending varhead ", GetLastError());
         //  }
         if(SocketSend(socket, pkt, ArraySize(pkt)) < 0)
           {
            Print("Failed sending pkt ", GetLastError());
           }
         //---
         char rsp[];
         uint len = SocketIsReadable(socket);
         SocketRead(socket, rsp, 10, 1000);
         if(rsp[0] != CONNACK)
           {
            ArrayPrint(fixhead);
            Print("Not Connect acknowledgment");
           }
         if(rsp[3] != MQTT_REASON_CODE_SUCCESS)  // Connect Return code (Connection accepted)
           {
            ArrayPrint(varhead);
            Print("Connection Refused");
           }
        }
      else
        {
         if(socket != INVALID_HANDLE)
           {
            SocketClose(socket);
           }
        }
     }
  }
//+------------------------------------------------------------------+
