//+------------------------------------------------------------------+
//|                                                      CPuback.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14391 **** |
//+------------------------------------------------------------------+
#include "MQTT.mqh"

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
//| Class CPuback.                                                   |
//| Purpose: Class of MQTT Puback Control Packets.                   |
//|          Implements IControlPacket                               |
//+------------------------------------------------------------------+
class CPuback : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
   uint              m_remlen;
   uint              m_remlen_bytes;
   uchar             m_reasoncode;
   uint              m_propslen;
   uint              m_propslen_bytes;
   uint              m_pktid;
protected:
   int               ReleasePktid(ushort pkt_id);
   void              HandlePublishError(uint reason_code);
   bool              IsPendingPkt(uint pkt_id);
   uint              GetPropsLenBytes(uint propslen);
public:

   //--- method for reading incoming packets
   int               Read(uchar &pkt[]);
   //--- method for building the final packet
   void              Build(uchar &pkt[]);
   //--- ctors
                     CPuback(void) {};
                    ~CPuback(void) {};
                     CPuback(uchar &inpkt[]);
   static bool       IsPuback(uchar &inpkt[]);
   ushort            ReadPacketIdentifier(uchar &pkt[], uint idx);
   uchar             ReadReasonCode(uchar &pkt[], uint idx);
   uint              ReadProperties(uchar &pkt[], uint props_len, uint idx);
   string            ReadReasonString(uchar &inpkt[], uint idx);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CPuback::ReadReasonString(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CPuback::IsPuback(uchar &inpkt[])
  {
   return inpkt[0] == (PUBACK << 4) ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CPuback::Read(uchar &pkt[])
  {
   m_remlen = DecodeVariableByteInteger(pkt, 1);
// validate Remaining Length
   if(m_remlen < 2 || m_remlen > VARINT_MAX_FOUR_BYTES)
     {
      printf("Invalid Remaining Length: %d", m_remlen);
      return -1;
     }
   m_remlen_bytes = GetVarintBytes(m_remlen);
// implicit Reason Code and no properties
   if(m_remlen == 2)
     {
      m_pktid = ReadPacketIdentifier(pkt, 2);
      if(IsPendingPkt(m_pktid))
        {
         return ReleasePktid((ushort)m_pktid);
        }
     }
// get the packet ID
   m_pktid = ReadPacketIdentifier(pkt, m_remlen_bytes + 1);
// get the Reason Code
   m_reasoncode = ReadReasonCode(pkt, m_remlen_bytes + 3);
// get the properties length
   m_propslen = ReadPropertyLength(pkt, m_remlen_bytes + 4);
// validate Property Length
   if(m_propslen > VARINT_MAX_FOUR_BYTES)
     {
      printf("Invalid Properties Length: %d", m_propslen);
      return -1;
     }
   m_propslen_bytes = GetPropsLenBytes(m_propslen);
// get the Properties start idx
   uint props_start = m_remlen_bytes + 2 + m_propslen_bytes + 1;
// we have a successful PUBLISH; release the packet ID
   if(m_reasoncode == MQTT_REASON_CODE_SUCCESS || m_reasoncode == MQTT_REASON_CODE_NO_MATCHING_SUBSCRIBERS)
     {
      if(IsPendingPkt(m_pktid))
        {
         ReleasePktid((ushort)m_pktid);
        }
     }
// PUBLISH was rejected; read props, handle the error and log it
   else
     {
      ReadProperties(pkt, m_propslen, props_start);
      HandlePublishError(m_reasoncode);
      return -1;
     }
// we have props; read them
   if(m_propslen > 0)
     {
      ReadProperties(pkt, m_propslen, props_start);
      return 0;
     }
   else
     {
      return 0;
     }
   return -1;
  }
//+------------------------------------------------------------------+
//|   validate Properties Length and get its size in bytes           |
//+------------------------------------------------------------------+
// TODO use MQTT GetVarintBytes(uint i) and check for propslen other way
uint CPuback::GetPropsLenBytes(uint propslen)
  {
   uint propslen_bytes = 0;
//
   if(m_propslen == 0 && m_propslen <= VARINT_MAX_ONE_BYTE)
     {propslen_bytes = 1;}
   if(m_propslen >= VARINT_MIN_TWO_BYTES && m_propslen <= VARINT_MAX_TWO_BYTES)
     {propslen_bytes = 2;}
   if(m_propslen >= VARINT_MIN_THREE_BYTES && m_propslen <= VARINT_MAX_THREE_BYTES)
     {propslen_bytes = 3;}
   if(m_propslen >= VARINT_MIN_FOUR_BYTES && m_propslen <= VARINT_MAX_FOUR_BYTES)
     {propslen_bytes = 4;}
   return propslen_bytes;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint CPuback::ReadProperties(uchar &pkt[], uint props_len, uint idx)
  {
   Print("Reading PUBACK properties");
   uint props_count = 0;
   for(uint bytes = 0; bytes < props_len; idx++)
     {
      switch(pkt[idx])
        {
         case MQTT_PROP_IDENTIFIER_REASON_STRING :
           {
            uint strlen = (pkt[idx + 1] * 256) + pkt[idx + 2];
            string reason_str = ReadUtf8String(pkt, idx + 3, strlen);
            Print(reason_str);
            props_count++;
            bytes += strlen + 3; // prop id(1 byte) + strlen MSB LSB (2)
            ArrayRemove(pkt, 0, bytes);
           }
         break;
         case MQTT_PROP_IDENTIFIER_USER_PROPERTY:
           {
            uint keylen = (pkt[idx + 1] * 256) + pkt[idx + 2];
            string key = ReadUtf8String(pkt, idx + 3, keylen);
            uint vallen = (pkt[idx + keylen + 2] * 256) + pkt[idx + keylen + 3];
            string val = ReadUtf8String(pkt, idx + keylen + 4, vallen);
            string userprop;
            StringConcatenate(userprop, key, val);
            Print(userprop);
            props_count++;
            bytes += keylen + vallen + 5; // prop id (1 byte) + key/val len MSB LSB (4)
            ArrayRemove(pkt, 0, bytes);
           }
         break;
         default:
            break;
        }
     }
   return props_count;
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
int CPuback::ReleasePktid(ushort pkt_id)
  {
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CPuback::ReadReasonCode(uchar &pkt[], uint idx)
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
ushort CPuback::ReadPacketIdentifier(uchar &pkt[], uint idx)
  {
   return (ushort)((pkt[idx] * 256) + pkt[idx + 1]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPuback::Build(uchar &pkt[])
  {
   ArrayResize(pkt, 1);
   pkt[0] = (uchar)PUBACK << 4;
  }
//+------------------------------------------------------------------+
CPuback::CPuback(uchar &inpkt[]) {};
//+------------------------------------------------------------------+
