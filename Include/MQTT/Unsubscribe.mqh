//+------------------------------------------------------------------+
//|                                                  Unsubscribe.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"
#include "MQTT.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CUnsubscribe : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
   uint              m_remlen;
   uint              m_remlen_bytes;
   uint              m_propslen;

public:
                     CUnsubscribe();
                    ~CUnsubscribe();
   void              Build(uchar &pkt[]);
   void              AddRemainingLength(uchar &pkt[], uint idx = 1);
   void              AddPropertyLength(uchar &pkt[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUnsubscribe::AddPropertyLength(uchar &pkt[])
  {
   uchar aux[] = {};
   EncodeVariableByteInteger(m_propslen, aux);
   ArrayCopy(pkt, aux, m_remlen_bytes + 3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUnsubscribe::AddRemainingLength(uchar &pkt[], uint idx = 1)
  {
   uchar aux[] = {};
   EncodeVariableByteInteger(m_remlen, aux);
   ArrayCopy(pkt, aux, idx, 0, aux.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUnsubscribe::Build(uchar &pkt[])
  {
   ArrayResize(pkt, GetVarintBytes(m_remlen) + m_remlen);
   pkt[0] = (UNSUBSCRIBE << 4) | 2;
   AddRemainingLength(pkt);
   SetPacketIdentifier(pkt, m_remlen_bytes + 1);
   AddPropertyLength(pkt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CUnsubscribe::CUnsubscribe()
  {
   m_remlen = 4;
   m_remlen_bytes = GetVarintBytes(m_remlen);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CUnsubscribe::~CUnsubscribe()
  {
  }
//+------------------------------------------------------------------+
