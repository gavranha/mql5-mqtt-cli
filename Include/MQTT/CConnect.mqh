//+------------------------------------------------------------------+
//|                                                   PktConnect.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13388 **** |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"
//+------------------------------------------------------------------+
//|        CONNECT VARIABLE HEADER                                   |
//+------------------------------------------------------------------+
/*
The Variable Header for the CONNECT Packet contains the following fields in this order:
Protocol Name,Protocol Level, Connect Flags, Keep Alive, and Properties.
*/
//---
struct MqttKeepAlive
  {
   uchar             msb;
   uchar             lsb;
  } keepAlive;

//+------------------------------------------------------------------+
//| Class CConnect.                                               |
//| Purpose: Class of MQTT Connect Control Packets.                  |
//|          Implements IControlPacket                               |
//+------------------------------------------------------------------+
class CConnect : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
   uint              m_remlen;

protected:
   uchar             m_connflags;
   uchar             m_clientid[];
   uchar             m_connprops[];
   uint              m_connprops_len;
   uchar             m_sessionexp_int[];
   uchar             m_receive_max[];
   uchar             m_maxpkt_size[];
   uchar             m_topicalias_max[];
   uchar             m_req_respinfo[];
   uchar             m_req_problinfo[];
   uchar             m_userprop[];
   uchar             m_authmethod[];
   uchar             m_authdata[];
   uchar             m_will_delayint[];
   uchar             m_willprops[];
   uint              m_willprops_len;
   uchar             m_will_payloadformat[];
   uchar             m_will_msgexpint[];
   uchar             m_will_contenttype[];
   uchar             m_will_resptopic[];
   uchar             m_will_corrdata[];
   uchar             m_will_userprop[];
   uchar             m_will_topic[];
   uchar             m_will_payload[];
   uchar             m_payload[];
   uint              m_payload_len;
   uchar             m_user_name[];
   uchar             m_password[];
public:
                     CConnect();
                    ~CConnect();
   //--- methods for setting Connect Flags
   void              SetCleanStart(const bool cleanStart);
   void              SetWillFlag(const bool willFlag);
   void              SetWillQoS_1(const bool willQoS_1);
   void              SetWillQoS_2(const bool willQoS_2);
   void              SetWillRetain(const bool willRetain);
   void              SetPasswordFlag(const bool passwordFlag);
   void              SetUserNameFlag(const bool userNameFlag);
   void              SetKeepAlive(ushort seconds);
   //--- methods for setting Properties
   void              SetSessionExpiryInterval(uint seconds);
   void              SetReceiveMaximum(ushort receive_max);
   void              SetMaximumPacketSize(uint max_pkt_size);
   void              SetTopicAliasMaximum(ushort topic_alias_max);
   void              SetRequestResponseInfo(ushort val);
   void              SetRequestProblemInfo(uchar val);
   void              SetUserProperty(const string key, const string val);
   void              SetAuthMethod(const string auth_method);
   void              SetAuthData(const string bindata);
   //--- methods for setting the Will Properties
   void              SetWillDelayInterval(uint seconds);
   void              SetWillPayloadFormatIndicator(uchar val);
   void              SetWillMessageExpiryInterval(uint seconds);
   void              SetWillContentType(const string content_type);
   void              SetWillResponseTopic(const string resp_topic);
   void              SetWillCorrelationData(const string corr_data);
   void              SetWillUserProperty(const string key, const string val);
   //--- methods for setting the Payload
   void              SetClientIdentifier(const string clientId);
   void              SetWillTopic(const string will_topic);
   void              SetWillPayload(const string will_payload);
   void              SetUserName(const string username);
   void              SetPassword(const string password);
   //--- method for building the final packet
   void              Build(uchar &result[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetPassword(const string password)
  {
   ArrayResize(m_password, StringLen(password));
   StringToCharArray(password, m_password, 0, StringLen(password));
   ArrayCopy(m_payload, m_password, m_payload.Size());
   m_remlen += m_password.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetUserName(const string username)
  {
   ArrayResize(m_user_name, StringLen(username) + 2);
   EncodeUTF8String(username, m_user_name);
   ArrayCopy(m_payload,m_user_name,m_payload.Size());
   m_remlen += m_user_name.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillPayload(const string will_payload)
  {
   ArrayResize(m_will_payload, StringLen(will_payload));
   StringToCharArray(will_payload, m_will_payload, 0, StringLen(will_payload));
   ArrayCopy(m_payload, m_will_payload,m_payload.Size());
   m_remlen += m_will_payload.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillTopic(const string will_topic)
  {
   ArrayResize(m_will_topic, StringLen(will_topic) + 2);
   EncodeUTF8String(will_topic, m_will_topic);
   ArrayCopy(m_payload,m_will_topic,m_payload.Size());
   m_remlen += m_will_topic.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillUserProperty(const string key, const string val)
  {
// TODO: it must allow for multiple User Properties
   uint keylen = StringLen(key);
   uint vallen = StringLen(val);
//---
   ArrayResize(m_will_userprop, 5 + keylen + vallen);
   m_will_userprop[0] = MQTT_PROP_IDENTIFIER_USER_PROPERTY;
//---
   uchar keyaux[];
   ArrayResize(keyaux, keylen + 2);
   EncodeUTF8String(key, keyaux);
//---
   uchar valaux[];
   ArrayResize(valaux, vallen + 2);
   EncodeUTF8String(val, valaux);
//---
   ArrayCopy(m_will_userprop, keyaux, 1);
   ArrayCopy(m_will_userprop, valaux, m_will_userprop.Size() - 5);
   ArrayCopy(m_willprops, m_will_userprop, m_willprops.Size());
   m_willprops_len += m_will_userprop.Size();
   m_remlen += m_will_userprop.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillCorrelationData(const string corr_data)
  {
   ArrayResize(m_will_corrdata, StringLen(corr_data) + 1);
   m_will_corrdata[0] = MQTT_PROP_IDENTIFIER_CORRELATION_DATA;
   StringToCharArray(corr_data, m_will_corrdata, 1, StringLen(corr_data));
   ArrayCopy(m_willprops, m_will_corrdata, m_willprops.Size());
   m_willprops_len += m_will_corrdata.Size();
   m_remlen += m_will_corrdata.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillResponseTopic(const string resp_topic)
  {
   ArrayResize(m_will_resptopic, StringLen(resp_topic) + 3);
   m_will_resptopic[0] = MQTT_PROP_IDENTIFIER_RESPONSE_TOPIC;
   uchar aux[];
   ArrayResize(aux, StringLen(resp_topic) + 2);
   EncodeUTF8String(resp_topic, aux);
   ArrayCopy(m_will_resptopic, aux, 1);
   ArrayCopy(m_willprops, m_will_resptopic, m_willprops.Size());
   m_willprops_len += m_will_resptopic.Size();
   m_remlen += m_will_resptopic.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillContentType(const string content_type)
  {
   ArrayResize(m_will_contenttype, StringLen(content_type) + 3);
   m_will_contenttype[0] = MQTT_PROP_IDENTIFIER_CONTENT_TYPE;
   uchar aux[];
   ArrayResize(aux, StringLen(content_type) + 2);
   EncodeUTF8String(content_type, aux);
   ArrayCopy(m_will_contenttype, aux, 1);
   ArrayCopy(m_willprops, m_will_contenttype, m_willprops.Size());
   m_willprops_len += m_will_contenttype.Size();
   m_remlen += m_will_contenttype.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillMessageExpiryInterval(uint seconds)
  {
   ArrayResize(m_will_msgexpint, 5);
   m_will_msgexpint[0] = MQTT_PROP_IDENTIFIER_MESSAGE_EXPIRY_INTERVAL;
   uchar aux[4];
   EncodeFourByteInteger(seconds, aux);
   ArrayCopy(m_will_msgexpint, aux, 1);
   ArrayCopy(m_willprops, m_will_msgexpint, m_willprops.Size());
   m_willprops_len += m_will_msgexpint.Size();
   m_remlen += m_will_msgexpint.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillPayloadFormatIndicator(uchar val)
  {
   ArrayResize(m_will_payloadformat, 2);
   m_will_payloadformat[0] = MQTT_PROP_IDENTIFIER_PAYLOAD_FORMAT_INDICATOR;
   m_will_payloadformat[1] = val;
   ArrayCopy(m_willprops, m_will_payloadformat, m_willprops.Size());
   m_willprops_len += m_will_payloadformat.Size();
   m_remlen += m_will_payloadformat.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillDelayInterval(uint seconds)
  {
   ArrayResize(m_will_delayint, 5);
   m_will_delayint[0] = MQTT_PROP_IDENTIFIER_WILL_DELAY_INTERVAL;
   uchar aux[4];
   EncodeFourByteInteger(seconds, aux);
   ArrayCopy(m_will_delayint, aux, 1);
   ArrayCopy(m_willprops, m_will_delayint, m_willprops.Size());
   m_willprops_len += m_will_delayint.Size();
   m_remlen += m_will_delayint.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetAuthData(const string bindata)
  {
   ArrayResize(m_authdata, StringLen(bindata) + 1);
   m_authdata[0] = MQTT_PROP_IDENTIFIER_AUTHENTICATION_DATA;
   StringToCharArray(bindata, m_authdata, 1, StringLen(bindata));
   ArrayCopy(m_connprops, m_authdata, m_connprops.Size());
   m_connprops_len += m_authdata.Size();
   m_remlen += m_authdata.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetAuthMethod(const string auth_method)
  {
   ArrayResize(m_authmethod, StringLen(auth_method) + 3);
   m_authmethod[0] = MQTT_PROP_IDENTIFIER_AUTHENTICATION_METHOD;
   uchar aux[];
   ArrayResize(aux, StringLen(auth_method) + 2);
   EncodeUTF8String(auth_method, aux);
   ArrayCopy(m_authmethod, aux, 1);
   ArrayCopy(m_connprops, m_authmethod, m_connprops.Size());
   m_connprops_len += m_authmethod.Size();
   m_remlen += m_authmethod.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// TODO: it must allow for multiple User Properties
void CConnect::SetUserProperty(const string key, const string val)
  {
   uint keylen = StringLen(key);
   uint vallen = StringLen(val);
//---
   ArrayResize(m_userprop, 5 + keylen + vallen);
   m_userprop[0] = MQTT_PROP_IDENTIFIER_USER_PROPERTY;
//---
   uchar keyaux[];
   ArrayResize(keyaux, keylen + 2);
   EncodeUTF8String(key, keyaux);
//---
   uchar valaux[];
   ArrayResize(valaux, vallen + 2);
   EncodeUTF8String(val, valaux);
//---
   ArrayCopy(m_userprop, keyaux, 1);
   ArrayCopy(m_userprop, valaux, m_userprop.Size() - 5);
   ArrayCopy(m_connprops, m_userprop, m_connprops.Size());
   m_connprops_len += m_userprop.Size();
   m_remlen += m_userprop.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetRequestProblemInfo(uchar val)
  {
   ArrayResize(m_req_problinfo, 2);
   m_req_problinfo[0] = MQTT_PROP_IDENTIFIER_REQUEST_PROBLEM_INFORMATION;
   m_req_problinfo[1] = (uchar)val;
   ArrayCopy(m_connprops, m_req_problinfo, m_connprops.Size());
   m_connprops_len += m_req_problinfo.Size();
   m_remlen += m_req_problinfo.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetRequestResponseInfo(ushort val)
  {
   ArrayResize(m_req_respinfo, 2);
   m_req_respinfo[0] = MQTT_PROP_IDENTIFIER_REQUEST_RESPONSE_INFORMATION;
   m_req_respinfo[1] = (uchar)val;
   ArrayCopy(m_connprops, m_req_respinfo, m_connprops.Size());
   m_connprops_len += m_req_respinfo.Size();
   m_remlen += m_req_respinfo.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetTopicAliasMaximum(ushort topic_alias_max)
  {
   ArrayResize(m_topicalias_max, 3);
   m_topicalias_max[0] = MQTT_PROP_IDENTIFIER_TOPIC_ALIAS_MAXIMUM;
   uchar aux[2];
   EncodeTwoByteInteger(topic_alias_max, aux);
   ArrayCopy(m_topicalias_max, aux, 1);
   ArrayCopy(m_connprops, m_topicalias_max, m_connprops.Size());
   m_connprops_len += m_topicalias_max.Size();
   m_remlen += m_topicalias_max.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetMaximumPacketSize(uint max_pkt_s)
  {
   ArrayResize(m_maxpkt_size, 5);
   m_maxpkt_size[0] = MQTT_PROP_IDENTIFIER_MAXIMUM_PACKET_SIZE;
   uchar aux[4];
   EncodeFourByteInteger(max_pkt_s, aux);
   ArrayCopy(m_maxpkt_size, aux, 1);
   ArrayCopy(m_connprops, m_maxpkt_size, m_connprops.Size());
   m_connprops_len += m_maxpkt_size.Size();
   m_remlen += m_maxpkt_size.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetReceiveMaximum(ushort receive_max)
  {
   ArrayResize(m_receive_max, 3);
   m_receive_max[0] = MQTT_PROP_IDENTIFIER_RECEIVE_MAXIMUM;
   uchar aux[2];
   EncodeTwoByteInteger(receive_max, aux);
   ArrayCopy(m_receive_max, aux, 1);
   ArrayCopy(m_connprops, m_receive_max, m_connprops.Size());
   m_connprops_len += m_receive_max.Size();
   m_remlen += m_receive_max.Size();
  }
//+------------------------------------------------------------------+
//|         Properties                                               |
//+------------------------------------------------------------------+
void CConnect::SetSessionExpiryInterval(uint seconds)
  {
   ArrayResize(m_sessionexp_int, 5);
   m_sessionexp_int[0] = MQTT_PROP_IDENTIFIER_SESSION_EXPIRY_INTERVAL;
   uchar aux[4];
   EncodeFourByteInteger(seconds, aux);
   ArrayCopy(m_sessionexp_int, aux, 1);
   ArrayCopy(m_connprops, m_sessionexp_int, m_connprops.Size());
   m_connprops_len += m_sessionexp_int.Size();
   m_remlen += m_sessionexp_int.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetClientIdentifier(const string clientId)
  {
   ArrayResize(m_clientid, StringLen(clientId) + 2);
   EncodeUTF8String(clientId, m_clientid);
   //m_payload_len += m_clientid.Size();
   m_remlen += m_clientid.Size();
   uchar a = 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::Build(uchar & pkt[])
  {
   uchar fixhead[];
   uchar varint_remlen[];
   EncodeVariableByteInteger(m_remlen, varint_remlen);
   ArrayResize(fixhead, varint_remlen.Size() + 1);
   fixhead[0] = CONNECT << 4;
   ArrayCopy(fixhead, varint_remlen, 1);
//---
   uchar varhead[];
   ArrayResize(varhead, 10, 1024);
   varhead[0] = MQTT_PROTOCOL_NAME_LENGTH_MSB;
   varhead[1] = MQTT_PROTOCOL_NAME_LENGTH_LSB;
   varhead[2] = MQTT_PROTOCOL_NAME_BYTE_3;
   varhead[3] = MQTT_PROTOCOL_NAME_BYTE_4;
   varhead[4] = MQTT_PROTOCOL_NAME_BYTE_5;
   varhead[5] = MQTT_PROTOCOL_NAME_BYTE_6;
   varhead[6] = MQTT_PROTOCOL_VERSION;
   varhead[7] = m_connflags;
   varhead[8] = keepAlive.msb;
   varhead[9] = keepAlive.lsb;
//--- Fixed Header
   ArrayCopy(pkt, fixhead);
//--- Variable Header
   ArrayCopy(pkt, varhead, pkt.Size());
////--- Connect Properties
//   uchar varint_connprops_len[];
//   EncodeVariableByteInteger(m_connprops_len, varint_connprops_len);
//   ArrayCopy(pkt, varint_connprops_len, pkt.Size());
//   ArrayCopy(pkt, m_connprops, pkt.Size());
//--- Payload - Client Identifier
   ArrayCopy(pkt, m_clientid, pkt.Size());
////--- Payload - Will Properties
//   uchar varint_willprops_len[];
//   EncodeVariableByteInteger(m_willprops_len, varint_willprops_len);
//   ArrayCopy(pkt, varint_willprops_len, pkt.Size());
//   ArrayCopy(pkt, m_willprops, pkt.Size());
////--- Payload - Will Topic
//   ArrayCopy(pkt, m_will_topic, pkt.Size());
////--- Payload - Will Payload
//   ArrayCopy(pkt, m_will_payload, pkt.Size());
////--- Payload - Username
//   ArrayCopy(pkt, m_user_name, pkt.Size());
////--- Payload - Password
//   ArrayCopy(pkt, m_password, pkt.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetKeepAlive(ushort seconds) // MQTT max is 65,535 sec
  {
   keepAlive.msb = (uchar)(seconds >> 8) & 255;
   keepAlive.lsb = (uchar)seconds & 255;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetPasswordFlag(const bool passwordFlag)
  {
   passwordFlag ? m_connflags |= PASSWORD_FLAG : m_connflags &= ~PASSWORD_FLAG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetUserNameFlag(const bool userNameFlag)
  {
   userNameFlag ? m_connflags |= USER_NAME_FLAG : m_connflags &= (uchar) ~USER_NAME_FLAG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillRetain(const bool willRetain)
  {
   willRetain ? m_connflags |= WILL_RETAIN : m_connflags &= ~WILL_RETAIN;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillQoS_2(const bool willQoS_2)
  {
   willQoS_2 ? m_connflags |= WILL_QOS_2 : m_connflags &= ~WILL_QOS_2;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillQoS_1(const bool willQoS_1)
  {
   willQoS_1 ? m_connflags |= WILL_QOS_1 : m_connflags &= ~WILL_QOS_1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillFlag(const bool willFlag)
  {
   willFlag ? m_connflags |= WILL_FLAG : m_connflags &= ~WILL_FLAG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetCleanStart(const bool cleanStart)
  {
   cleanStart ? m_connflags |= CLEAN_START : m_connflags &= ~CLEAN_START;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CConnect::CConnect()
  {
   m_remlen = 10;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CConnect::~CConnect()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
