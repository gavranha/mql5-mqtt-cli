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
   uint              m_remlen_in;
   uint              m_remlen_in_bytes;
   uchar             m_reason_code;
   uint              m_propslen_in;
   uint              m_pktID_in;
protected:
   ushort            GetPacketID(uint &pkt[], uint idx);
   int               ReleasePktID(uint pkt_id);
   void              HandlePublishError(uint reason_code);
   bool              IsPendingPkt(uint pkt_id);
   uchar             GetReasonCode(uint &pkt[], uint idx);
   void              ReadProperties(uint props_len, uint idx);
public:

   //--- method for reading incoming packets
   int               Read(uint &pkt[]);
   //--- method for building the final packet
   void              Build(uchar &pkt[]);
   //--- ctors
                     CPuback(void) {};
                    ~CPuback(void) {};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CPuback::Read(uint &pkt[])
  {
   m_remlen_in = DecodeVariableByteInteger(pkt, 1);
// validate Remaining Length
   if(m_remlen_in > 2 && m_remlen_in <= 127)
     {m_remlen_in_bytes = 1;}
   if(m_remlen_in >= 128 && m_remlen_in <= 16383)
     {m_remlen_in_bytes = 2;}
   if(m_remlen_in >= 16384 && m_remlen_in <= 2097151)
     {m_remlen_in_bytes = 3;}
   if(m_remlen_in >= 2097152 && m_remlen_in <= 268435455)
     {m_remlen_in_bytes = 4;}
   if(m_remlen_in < 2 || m_remlen_in > 268435455)
     {
      printf("Invalid Remaining Length: %d", m_remlen_in);
      return -1;
     }
// implicit Reason Code and no properties
   if(m_remlen_in == 2)
     {
      m_pktID_in = GetPacketID(pkt, 2);
      if(IsPendingPkt(m_pktID_in))
        {
         return ReleasePktID(m_pktID_in);
        }
     }
// get the packet ID
   m_pktID_in = GetPacketID(pkt, m_remlen_in_bytes + 1);
// get the Reason Code
   m_reason_code = GetReasonCode(pkt, m_remlen_in_bytes + 3);
   if(m_reason_code == 0x00 || m_reason_code == 0x10)
     {
      if(IsPendingPkt(m_pktID_in))
        {
         ReleasePktID(m_pktID_in);
        }
     }
   else
     {
      HandlePublishError(m_reason_code);
      return -1;
     }
// get the properties length
   m_propslen_in = DecodeVariableByteInteger(pkt, m_remlen_in_bytes + 4);
   if(m_propslen_in > 0)
     {
      ReadProperties(m_propslen_in, m_remlen_in_bytes + 5);
      return 0;
     }
   else
     {
      return 0;
     }
   return -1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPuback::ReadProperties(uint props_len, uint idx)// TODO move to MQTT.mqh
  {
   Print(__FUNCTION__);
   Print("Reading PUBACK properties");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPuback::HandlePublishError(uint reason_code)
  {
   Print(__FUNCTION__);
   Print("PUBACK error handling");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CPuback::ReleasePktID(uint pkt_id)
  {
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CPuback::GetReasonCode(uint &pkt[], uint idx)
  {
   return (uchar)pkt[idx];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CPuback::IsPendingPkt(uint pkt_id)
  {
   ushort pending_ids[];
   GetPendingPublishIDs(pending_ids);
   for(uint i = 0; i < pending_ids.Size(); i++)
     {
      if(pending_ids[i] == pkt_id)
        {
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ushort CPuback::GetPacketID(uint &pkt[], uint idx)
  {
   return (ushort)((pkt[idx] * 256) + pkt[idx + 1]);
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
