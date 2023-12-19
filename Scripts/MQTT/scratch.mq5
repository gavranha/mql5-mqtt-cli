//+------------------------------------------------------------------+
//|                                                      scratch.mq5 |
//+------------------------------------------------------------------+
#include <MQTT\CPktConnect.mqh>


string broker_ip = "172.20.155.236";
int broker_port = 80;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   string const clientId = "MQL5";
   uchar arr[21];
   CPktConnect *cp = new CPktConnect(arr);
   cp.SetCleanStart(true);
   cp.SetKeepAlive(10);
   ArrayPrint(cp.ByteArray);
//fix header
   uchar fixheader[];
   ArrayCopy(fixheader, cp.ByteArray, 0, 0, 2);
   Print("fixheader");
   ArrayPrint(fixheader);
// var header
   uchar varheader[];
   ArrayCopy(varheader, cp.ByteArray, 0, 2, 10); //copy only the remanining length
   Print("varheader_1");
   ArrayPrint(varheader);
   // properties
   uchar props[3];
   props[0] = 2;//len
   props[1] = 23;//prop id
   props[2] = 1;//prop value
   ArrayCopy(varheader,props,ArraySize(varheader));
      Print("props");
   ArrayPrint(props);
   Print("varheader_2");
   ArrayPrint(varheader);
// client ID
   uchar aux[6];
   aux[0] = (uchar)StringLen(clientId) >> 8; // MSB
   aux[1] = (uchar)StringLen(clientId) % 256; // LSB
   aux[2] = 'M';
   aux[3] = 'Q';
   aux[4] = 'L';
   aux[5] = '5';
   ArrayCopy(varheader, aux, ArraySize(varheader));
   Print("aux");
   ArrayPrint(aux);
   Print("varheader_3");
   ArrayPrint(varheader);
// socket
   int socket = SocketCreate();
   if(socket != INVALID_HANDLE)
     {
      if(SocketConnect(socket, broker_ip, broker_port, 1000))
        {
         Print("Connected ", broker_ip);
         if(SocketSend(socket, fixheader, ArraySize(fixheader)) < 0)
           {
            Print("Failed sending variable header ", GetLastError());
           }
         if(SocketSend(socket, varheader, ArraySize(varheader)) < 0)
           {
            Print("Failed sending variable header ", GetLastError());
           }
         // CONNACK – Acknowledge connection request
         char rsp[];
         int len = SocketIsReadable(socket);
         //uint len = 10;
         do
           {
            SocketRead(socket, rsp, len, 1000);
           }
         while(len != -1);
         //SocketRead(socket, rsp, len, 1000); // Fixed header (2 bytes) and Variable header (2 bytes)
         //if(len > 0)
         //  {
         //if(rsp[0] != B'00100000')  // MQTT Control Packet Type (Connect acknowledgment)
         //  {
         //   Print("Not Connect acknowledgment");
         //   PrintFormat("Srv Resp Size   ==> %d", ArraySize(rsp));
         //   PrintFormat("Srv Resp byte 0 ==> %d", rsp[0]);
         //   PrintFormat("Srv Resp byte 1 ==> %d", rsp[1]);
         //   PrintFormat("Srv Resp byte 2 ==> %d", rsp[2]);
         //   PrintFormat("Srv Resp byte 3 ==> %d", rsp[3]);
         //   ArrayPrint(rsp);
         //   //return false;
         //}
         //}
         Print("rsp");
         ArrayPrint(rsp);
         SocketClose(socket);
         //}
         //if(rsp[3] != char(0))  // Connect Return code (Connection accepted)
         //  {
         //   Print("Connection Refused");
         //return false;
         //}
        }
      //else
      //  {
      //   if(socket != INVALID_HANDLE)
      //     {
      //      SocketClose(socket);
      //     }
      //  }
     }
//return 0;
   delete cp;
  }


//+------------------------------------------------------------------+
