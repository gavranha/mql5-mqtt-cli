//+------------------------------------------------------------------+
//|                                                      CPuback.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14391 **** |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"
#include "DB.mqh"

//+------------------------------------------------------------------+
//|         PUBACK VARIABLE HEADER                                   |
//+------------------------------------------------------------------+
/*
The Variable Header of the PUBACK Packet contains the following fields in the order: Packet Identifier
from the PUBLISH packet that is being acknowledged, PUBACK Reason Code, Property Length, and the
Properties.
*/
//+------------------------------------------------------------------+
//| Class CPuback.                                                  |
//| Purpose: Class of MQTT Puback Control Packets.                  |
//|          Implements IControlPacket                               |
//+------------------------------------------------------------------+
class CPuback : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
   ushort            GetPacketID(uchar &pkt[]);
public:
                     CPuback(void) {};
                    ~CPuback(void) {};
   bool              IsPendingPkt(uchar &pkt[]);
   uchar             GetReasonCode(uchar &pkt[]);
   uint              GetPropertyLength(uchar &pkt[]);
   //--- method for building the final packet
   void              Build(uchar &pkt[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint CPuback::GetPropertyLength(uchar &pkt[])
  {
   return pkt[3];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CPuback::GetReasonCode(uchar &pkt[])
  {
   return pkt[2];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPuback::IsPendingPkt(uchar &pkt[])
  {
   ushort pending_ids[];
   GetPendingPublishIDs(pending_ids);
   ushort packet_id = GetPacketID(pkt);
   for(uint i = 0; i < pending_ids.Size(); i++)
     {
      if(pending_ids[i] == packet_id)
        {
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ushort CPuback::GetPacketID(uchar &pkt[])
  {
   return (pkt[0] * 256) + pkt[1];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPuback::Build(uchar &pkt[])
  {
   ArrayResize(pkt, 2);
   pkt[0] = (uchar)PUBACK << 4;
  }
//+------------------------------------------------------------------+
