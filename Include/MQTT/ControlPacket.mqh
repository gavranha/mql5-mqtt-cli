//+------------------------------------------------------------------+
//|                                                ControlPacket.mqh |
//+------------------------------------------------------------------+
#include "MQTT.mqh"
//+------------------------------------------------------------------+
//| Class CControlPacket.                                            |
//| Purpose: Base class of MQTT Control Packets.                     |
//+------------------------------------------------------------------+
class CControlPacket
  {
   ENUM_PKT_TYPE     m_pkt_type;
public:
                     CControlPacket(void) {};
                    ~CControlPacket(void) {};
                     CControlPacket(const ENUM_PKT_TYPE pkt_type, uint &buf[]): m_pkt_type(pkt_type) {};
   uchar             EncodeVariableByteInteger(uint &buf[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CControlPacket::EncodeVariableByteInteger(uint &buf[])
  {
   uint x;
   x = ArraySize(buf);
   uint rem_len;
   do
     {
      rem_len = x % 128;
      x = (x / 128);
      if(x > 0)
        {
         rem_len = rem_len | 128;
        }
     }
   while(x > 0);
   return (uchar)rem_len;
  };

//+------------------------------------------------------------------+
