//+------------------------------------------------------------------+
//|                                                      Publish.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14391 **** |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"
//+------------------------------------------------------------------+
//|        PUBLISH VARIABLE HEADER                                   |
//+------------------------------------------------------------------+
/*
The Variable Header of the PUBLISH Packet contains the following fields in the order: Topic Name,
Packet Identifier, and Properties.
*/
//+------------------------------------------------------------------+
//| Class CPublish.                                                  |
//| Purpose: Class of MQTT Publish Control Packets.                  |
//|          Implements IControlPacket                               |
//+------------------------------------------------------------------+
class CPublish : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
   bool              HasWildcardChar(const string str);
protected:
   uchar             m_pubflags;
   uint              m_remlen;
   uchar             m_topname[];
   uchar             m_props[];
   uint              m_payload[];
public:
                     CPublish();
                    ~CPublish();
   //--- methods for setting Publish flags
   void              SetRetain(const bool retain);
   void              SetQoS_1(const bool QoS_1);
   void              SetQoS_2(const bool QoS_2);
   void              SetDup(const bool dup);
   //--- method for setting Topic Name
   void              SetTopicName(const string topic_name);
   //--- methods for setting Properties
   void              SetPayloadFormatIndicator(PAYLOAD_FORMAT_INDICATOR format);
   void              SetMessageExpiryInterval(uint msg_expiry_interval);
   void              SetTopicAlias(ushort topic_alias);
   void              SetResponseTopic(const string response_topic);
   void              SetCorrelationData(uchar &binary_data[]);
   void              SetUserProperty(const string key, const string val);
   void              SetSubscriptionIdentifier(uint subscript_id);
   void              SetContentType(const string content_type);
   //--- method for setting the payload
   void              SetPayload(const string payload);
   //--- method for building the final packet
   void              Build(uchar &result[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetPayload(const string payload)
  {
   uchar aux[];
   EncodeUTF8String(payload, aux);
   ArrayCopy(m_payload, aux, m_props.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetContentType(const string content_type)
  {
   uchar aux[1];
   aux[0] = MQTT_PROP_IDENTIFIER_CONTENT_TYPE;
   ArrayCopy(m_props, aux, m_props.Size());
   uchar buf[];
   EncodeUTF8String(content_type, buf);
   ArrayCopy(m_props, buf, m_props.Size());
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetSubscriptionIdentifier(uint subscript_id)
  {
   if(subscript_id < 1 || subscript_id > 0xfffffff)
     {
      printf("Error: " + __FUNCTION__ +  "Subscription Identifier must be between 1 and 268,435,455");
      return;
     }
   uchar aux[1];
   aux[0] = MQTT_PROP_IDENTIFIER_SUBSCRIPTION_IDENTIFIER;
   ArrayCopy(m_props, aux, m_props.Size());
   uchar buf[];
   EncodeVariableByteInteger(subscript_id, buf);
   ArrayCopy(m_props, buf, m_props.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetUserProperty(const string key, const string val)
  {
   uchar aux[1];
   aux[0] = MQTT_PROP_IDENTIFIER_USER_PROPERTY;
   ArrayCopy(m_props, aux, m_props.Size());
   uchar key_buf[];
   EncodeUTF8String(key, key_buf);
   ArrayCopy(m_props, key_buf, m_props.Size());
   uchar val_buf[];
   EncodeUTF8String(val, val_buf);
   ArrayCopy(m_props, val_buf, m_props.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetCorrelationData(uchar &binary_data[])
  {
   uchar aux[1];
   aux[0] = MQTT_PROP_IDENTIFIER_CORRELATION_DATA;
   ArrayCopy(m_props, aux, m_props.Size());
   ArrayCopy(m_props, binary_data, m_props.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetResponseTopic(const string response_topic)
  {
   uchar aux[1];
   aux[0] = MQTT_PROP_IDENTIFIER_RESPONSE_TOPIC;
   ArrayCopy(m_props, aux, m_props.Size());
   uchar buf[];
   EncodeUTF8String(response_topic, buf);
   ArrayCopy(m_props, buf, m_props.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetTopicAlias(ushort topic_alias)
  {
   uchar aux[2];
   aux[0] = MQTT_PROP_IDENTIFIER_TOPIC_ALIAS;
   ArrayCopy(m_props, aux, m_props.Size(), 0, 1);
   EncodeTwoByteInteger(topic_alias, aux);
   ArrayCopy(m_props, aux, m_props.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetMessageExpiryInterval(uint msg_expiry_interval)
  {
   uchar aux[4];
   aux[0] = MQTT_PROP_IDENTIFIER_MESSAGE_EXPIRY_INTERVAL;
   ArrayCopy(m_props, aux, m_props.Size(), 0, 1);
   EncodeFourByteInteger(msg_expiry_interval, aux);
   ArrayCopy(m_props, aux, m_props.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetPayloadFormatIndicator(PAYLOAD_FORMAT_INDICATOR format)
  {
   uchar aux[2];
   aux[0] = MQTT_PROP_IDENTIFIER_PAYLOAD_FORMAT_INDICATOR;
   aux[1] = (uchar)format;
   ArrayCopy(m_props, aux, ArraySize(m_props));
  }
//+------------------------------------------------------------------+
//|               CPublish::SetTopicName                             |
//+------------------------------------------------------------------+
void CPublish::SetTopicName(const string topic_name)
  {
   if(HasWildcardChar(topic_name) || StringLen(topic_name) == 0)
     {
      ArrayFree(m_topname);
      return;
     }
   EncodeUTF8String(topic_name, m_topname);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::Build(uchar &pkt[]) // TODO break down this function
  {
   if(m_topname.Size() == 0)
     {
      printf("Error: " + __FUNCTION__ + " topic name is mandatory");
      return;
     }
   ArrayResize(pkt, 2);
// pkt type with publish flags
   pkt[0] = (uchar)PUBLISH << 4;
   pkt[0] |= m_pubflags;
// topic name
   ArrayCopy(pkt, m_topname, pkt.Size());
// QoS > 0 require packet ID
   if((m_pubflags & 0x06) != 0)
     {
      SetPacketID(pkt, pkt.Size());
     }
// properties length
   uchar buf[];
   EncodeVariableByteInteger(m_props.Size(), buf);
   ArrayCopy(pkt, buf, pkt.Size());
// properties
   ArrayCopy(pkt, m_props, pkt.Size());
// payload
   ArrayCopy(pkt, m_payload, pkt.Size());
// remaining length
   m_remlen += pkt.Size() - 2;
   uchar aux[];
   EncodeVariableByteInteger(m_remlen, aux);
   ArrayCopy(pkt, aux, 1);
  }
//+------------------------------------------------------------------+
//|               CPublish::HasWildcardChar                          |
//+------------------------------------------------------------------+
bool CPublish::HasWildcardChar(const string str)
  {
   if(StringFind(str, "#") > -1 || StringFind(str, "+") > -1)
     {
      printf("Wildcard char not allowed in Topic Names");
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetDup(const bool dup)
  {
   dup ? m_pubflags |= DUP_FLAG : m_pubflags &= ~DUP_FLAG;
  }
//+------------------------------------------------------------------+
//|            CPublish::SetQoS_2                                 |
//+------------------------------------------------------------------+
void CPublish::SetQoS_2(const bool QoS_2)
  {
   QoS_2 ? m_pubflags |= QoS_2_FLAG : m_pubflags &= ~QoS_2_FLAG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPublish::SetQoS_1(const bool QoS_1)
  {
   QoS_1 ? m_pubflags |= QoS_1_FLAG : m_pubflags &= ~QoS_1_FLAG;
  }
//+------------------------------------------------------------------+
//|                  CPublish::SetRetain                             |
//+------------------------------------------------------------------+
void CPublish::SetRetain(const bool retain)
  {
   retain ? m_pubflags |= RETAIN_FLAG : m_pubflags &= ~RETAIN_FLAG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPublish::CPublish()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPublish::~CPublish()
  {
  }
//+------------------------------------------------------------------+
