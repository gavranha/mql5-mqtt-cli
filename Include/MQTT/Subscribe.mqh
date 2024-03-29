//+------------------------------------------------------------------+
//|                                                    Subscribe.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSubscribe : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;};
   uint              m_remlen;
   uint              m_remlen_bytes;
   uint              m_propslen;
   uint              m_propslen_bytes;
   void              AddRemainingLength(uchar &pkt[], uint idx = 1);
   void              AddPropertyLength(uchar &pkt[]);
protected:
   uchar             m_topic_filter[];

public:
                     CSubscribe();
                    ~CSubscribe();
   void              Build(uchar &pkt[]);
   void              SetSubscriptionIdentifier(uchar &dest_buf[]);
   void              SetUserProperty(const string key, const string val, uchar &dest_buf[]);
   void              SetTopicFilter(const string topic_filter, uchar subopts_flags = 0);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSubscribe::SetTopicFilter(const string topic_filter, uchar subopts_flags = 0)
  {
   uchar aux[];
   EncodeUTF8String(topic_filter, aux);
   ArrayResize(aux, StringLen(topic_filter) + 3);
   aux[aux.Size() - 1] = subopts_flags;
   ArrayCopy(m_topic_filter, aux);
   m_remlen += ArraySize(m_topic_filter);
  }
// TODO: it must allow for multiple User Properties
void CSubscribe::SetUserProperty(const string key, const string val, uchar &dest_buf[])
  {
   uint keylen = StringLen(key);
   uint vallen = StringLen(val);
//---
   ArrayResize(dest_buf, keylen + vallen + 5);
   dest_buf[0] = MQTT_PROP_IDENTIFIER_USER_PROPERTY;
//---
   uchar keyaux[];
   ArrayResize(keyaux, keylen + 2);
   EncodeUTF8String(key, keyaux);
//---
   uchar valaux[];
   ArrayResize(valaux, vallen + 2);
   EncodeUTF8String(val, valaux);
//---
   ArrayCopy(dest_buf, keyaux, 1);
   ArrayCopy(dest_buf, valaux, keylen + 3);
//ArrayCopy(m_connprops, m_userprop, m_connprops.Size());
//m_connprops_len += m_userprop.Size();
//m_remlen += m_userprop.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSubscribe::SetSubscriptionIdentifier(uchar &dest_buf[])
  {
   ArrayResize(dest_buf, 2); // TODO hardcoded! Size must account for varint bytes
   dest_buf[0] = MQTT_PROP_IDENTIFIER_SUBSCRIPTION_IDENTIFIER;
   uchar aux[];
   EncodeVariableByteInteger(1, aux); // TODO hardcoded! Change to (uint)__RANDOM__
   ArrayCopy(dest_buf, aux, 1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSubscribe::AddPropertyLength(uchar &pkt[])
  {
   uchar aux[];
   EncodeVariableByteInteger(m_propslen, aux);
   ArrayCopy(pkt, aux, m_remlen_bytes + 3);
   m_propslen_bytes = GetVarintBytes(m_propslen);
   m_remlen += m_propslen_bytes;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSubscribe::AddRemainingLength(uchar &pkt[], uint idx = 1)
  {
   uchar aux[];
   EncodeVariableByteInteger(m_remlen, aux);
   ArrayCopy(pkt, aux, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSubscribe::Build(uchar &pkt[])
  {
   m_remlen_bytes = GetVarintBytes(m_remlen);
   ArrayResize(pkt, 2 + m_remlen_bytes + m_remlen);
   pkt[0] = (SUBSCRIBE << 4) | 2;
   SetPacketIdentifier(pkt, m_remlen_bytes + 1);
   m_remlen += 2;
   AddPropertyLength(pkt);
   AddRemainingLength(pkt);
   ArrayCopy(pkt, m_topic_filter, 1 + m_remlen_bytes + 2 + m_propslen_bytes); // pkt type + remlen bytes + pkt ID + props bytes
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSubscribe::CSubscribe()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSubscribe::~CSubscribe()
  {
  }
//+------------------------------------------------------------------+
