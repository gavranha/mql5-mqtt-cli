//+------------------------------------------------------------------+
//|                                                  TestConnect.mq5 |
//|                                                         JS Lopes |
//|                                                     any@mail.net |
//+------------------------------------------------------------------+
#property copyright "JS Lopes"
#property link      "any@mail.net"
#property version   "1.00"

#include <MQTT\MQTT.mqh>
#include <MQTT\Util.mqh>

string broker_ip = "172.20.155.236";
int broker_port = 80;
//int socket;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int socket = SocketCreate();
   if(socket != INVALID_HANDLE)
     {
      if(SocketConnect(socket, broker_ip, broker_port, 1000))
        {
         Print("Connected ", broker_ip);
         //---
         uchar fixed_header[];
         uchar variable_header[];
         //---
         GenVariableHeader(CONNECT, variable_header, fixed_header);
         //--- ***** GENERATE VARIABLE HEADER ********
         if(SocketSend(socket, variable_header, ArraySize(variable_header)) < 0)
           {
            Print("Failed sending variable header ", GetLastError());
           }
           //Print("variable_header");
           //ArrayPrint(variable_header);
         // CONNACK – Acknowledge connection request
         char rsp[];
         uint len=SocketIsReadable(socket); 
  
         SocketRead(socket, rsp, 10, 1000); // Fixed header (2 bytes) and Variable header (2 bytes)
//         if(rsp[0] != B'00100000')  // MQTT Control Packet Type (Connect acknowledgment)
//           {
//            Print("Not Connect acknowledgment");
//            PrintFormat("Srv Resp Size   ==> %d", ArraySize(rsp));
//            PrintFormat("Srv Resp byte 0 ==> %d", rsp[0]);
//            PrintFormat("Srv Resp byte 1 ==> %d", rsp[1]);
//            PrintFormat("Srv Resp byte 2 ==> %d", rsp[2]);
//            PrintFormat("Srv Resp byte 3 ==> %d", rsp[3]);
//            string rspHex = ArrayToHex(rsp);
//            PrintFormat("Srv Resp toHex  ==> %s", rspHex);
            ArrayPrint(rsp);
//            //return false;
//       
//           }
           
         //  ArrayPrint(rsp);
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
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GenVariableHeader(uint pkt_type, uchar& fixed_header[], uchar& variable_header[])
  {
// Fixed Header
   ArrayFree(fixed_header);
   ArrayResize(fixed_header, 2);
//fixed_header[0] = uchar(pkt_type);
   fixed_header[0] = B'00010000';
// Protocol Name
   ArrayFree(variable_header);
   ArrayResize(variable_header, 20, 100);
   variable_header[0] = char(0); // Length MSB (0)
   variable_header[1] = char(4); // Length LSB (4)
   variable_header[2] = char(77); // M
   variable_header[3] = char(81); // Q
   variable_header[4] = char(84); // T
   variable_header[5] = char(84); // T
// Protocol Version
   variable_header[6] = char(5); // Level(5)
// Connect Flags 0010
   variable_header[7] = char(2); // [User Name Flag] [Password Flag] [Will Retain] [Will QoS] [Will QoS] [Will Flag] [Clean Session] [Reserved]
// Keep Alive
   variable_header[8] = char(2); // Keep Alive MSB 0010
   variable_header[9] = char(88); // Keep Alive LSB 0101 1000
// Client Identifier
   variable_header[10] = (char)StringLen("CliID") >> 8; // String length MSB
   variable_header[11] = (char)StringLen("CliID") % 256; // String length LSB
// CONNECT properties
   variable_header[12] = uchar(7); // properties length
   variable_header[13] = uchar(17); // Session Expire Interval Identifier
   variable_header[14] = uchar(0); // Session Expire Interval
   variable_header[15] = uchar(0);
   variable_header[16] = uchar(0);
   variable_header[17] = uchar(10);
   variable_header[18] = uchar(25); // Request Response Information
   variable_header[19] = uchar(1);
// copy client ID to buffer
   char bufferClientId[];
   StringToCharArray("CliID", bufferClientId, 0, StringLen("CliID")); // String
   ArrayCopy(variable_header, bufferClientId, ArraySize(variable_header));
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   //Print("variable_header bottom");
   //ArrayPrint(variable_header);
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   
// Remaining Length
   uint x;
   x = ArraySize(variable_header);
   do
     {
      uint encodedByte = x % 128;
      x = (uint)(x / 128);
      if(x > 0)
        {
         encodedByte = encodedByte | 128;
        }
      fixed_header[1] = uchar(encodedByte);
     }
   while(x > 0);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GenFixedHeader(uint pkt_type, uchar& buf[], uchar& head[])
  {
   ArrayFree(head);
   ArrayResize(head, 2);
//head[0] = uchar(pkt_type);
   head[0] = B'00010000';
// Remaining Length
   uint x;
   x = ArraySize(buf);
   do
     {
      uint encodedByte = x % 128;
      x = (uint)(x / 128);
      if(x > 0)
        {
         encodedByte = encodedByte | 128;
        }
      head[1] = uchar(encodedByte);
     }
   while(x > 0);
  }
//+------------------------------------------------------------------+
