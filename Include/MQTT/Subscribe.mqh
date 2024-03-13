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
   void              AddRemainingLength(uchar &pkt[], uint idx = 1);
   void              AddPropertyLength(uchar &pkt[]);
public:
                     CSubscribe();
                    ~CSubscribe();
   void              Build(uchar &pkt[]);
   void              SetSubscriptionIdentifier(uchar &dest_buf[]);
   void              SetUserProperty(const string key, const string val, uchar &dest_buf[]);
   void              SetTopicFilter(const string topic_filter, uchar &dest_buf[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSubscribe::SetTopicFilter(const string topic_filter, uchar &dest_buf[])
  {
   EncodeUTF8String(topic_filter, dest_buf);
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
   uchar aux[] = {};
   EncodeVariableByteInteger(m_propslen, aux);
   ArrayCopy(pkt, aux, m_remlen_bytes + 3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSubscribe::AddRemainingLength(uchar &pkt[], uint idx = 1)
  {
   uchar aux[] = {};
   EncodeVariableByteInteger(m_remlen, aux);
   ArrayCopy(pkt, aux, idx, 0, aux.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSubscribe::Build(uchar &pkt[])
  {
   ArrayResize(pkt, GetVarintBytes(m_remlen) + m_remlen);
   pkt[0] = (SUBSCRIBE << 4) | 2;
   AddRemainingLength(pkt);
   SetPacketIdentifier(pkt, m_remlen_bytes + 1);
   AddPropertyLength(pkt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSubscribe::CSubscribe()
  {
   m_remlen = 4;
   m_remlen_bytes = GetVarintBytes(m_remlen);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSubscribe::~CSubscribe()
  {
  }
//+------------------------------------------------------------------+
