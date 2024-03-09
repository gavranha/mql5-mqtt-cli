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
struct MqttClientIdentifierLength
  {
   uchar             msb;
   uchar             lsb;
  } clientIdLen;
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
   uchar             m_connect_flags;
   uchar             m_clientId[];
   uint              m_propslen;
   uchar             m_session_exp_int[];
   uchar             m_receive_max[];
   uchar             m_max_pkt_size[];
   uchar             m_topic_alias_max[];
   uchar             m_req_resp_info[];
   uchar             m_req_probl_info[];
   uchar             m_user_prop[];
   uchar             m_auth_method[];
   uchar             m_auth_data[];
   void              GetClienIdLen(string clientId);

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
   void              SetRequestResponseInfo();
   void              SetRequestProblemInfo();
   void              SetUserProperty(const string key, const string val);
   void              SetAuthMethod(const string auth_method);
   void              SetAuthData(const string bindata);
   //--- methods for setting the Payloa
   void              SetClientIdentifier(string clientId);
   //--- method for building the final packet
   void              Build(uchar &result[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetAuthData(const string bindata)
  {
   ArrayResize(m_auth_data, StringLen(bindata) + 1);
   m_auth_data[0] = MQTT_PROP_IDENTIFIER_AUTHENTICATION_DATA;
   StringToCharArray(bindata, m_auth_data, 1, StringLen(bindata));
   m_propslen += m_auth_data.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetAuthMethod(const string auth_method)
  {
   ArrayResize(m_auth_method, StringLen(auth_method) + 3);
   m_auth_method[0] = MQTT_PROP_IDENTIFIER_AUTHENTICATION_METHOD;
   uchar aux[];
   ArrayResize(aux, StringLen(auth_method) + 2);
   EncodeUTF8String(auth_method, aux);
   ArrayCopy(m_auth_method, aux, 1);
   m_propslen += m_auth_method.Size();
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
   ArrayResize(m_user_prop, 5 + keylen + vallen);
   m_user_prop[0] = MQTT_PROP_IDENTIFIER_USER_PROPERTY;
//---
   uchar keyaux[];
   ArrayResize(keyaux, keylen + 2);
   EncodeUTF8String(key, keyaux);
//---
   uchar valaux[];
   ArrayResize(valaux, vallen + 2);
   EncodeUTF8String(val, valaux);
//---
   ArrayCopy(m_user_prop, keyaux, 1);
   ArrayCopy(m_user_prop, valaux, m_user_prop.Size() - 5);
   m_propslen += m_user_prop.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetRequestProblemInfo(void)
  {
   ArrayResize(m_req_probl_info, 2);
   m_req_probl_info[0] = MQTT_PROP_IDENTIFIER_REQUEST_PROBLEM_INFORMATION;
   m_req_probl_info[1] = 1;
   m_propslen += m_req_probl_info.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetRequestResponseInfo(void)
  {
   ArrayResize(m_req_resp_info, 2);
   m_req_resp_info[0] = MQTT_PROP_IDENTIFIER_REQUEST_RESPONSE_INFORMATION;
   m_req_resp_info[1] = 1;
   m_propslen += m_req_resp_info.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetTopicAliasMaximum(ushort topic_alias_max)
  {
   ArrayResize(m_topic_alias_max, 3);
   m_topic_alias_max[0] = MQTT_PROP_IDENTIFIER_TOPIC_ALIAS_MAXIMUM;
   uchar aux[2];
   EncodeTwoByteInteger(topic_alias_max, aux);
   ArrayCopy(m_topic_alias_max, aux, 1);
   m_propslen += m_topic_alias_max.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetMaximumPacketSize(uint max_pkt_s)
  {
   ArrayResize(m_max_pkt_size, 5);
   m_max_pkt_size[0] = MQTT_PROP_IDENTIFIER_MAXIMUM_PACKET_SIZE;
   uchar aux[4];
   EncodeFourByteInteger(max_pkt_s, aux);
   ArrayCopy(m_max_pkt_size, aux, 1);
   m_propslen += m_max_pkt_size.Size();
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
   m_propslen += m_receive_max.Size();
  }
//+------------------------------------------------------------------+
//|         Properties                                               |
//+------------------------------------------------------------------+
void CConnect::SetSessionExpiryInterval(uint seconds)
  {
   ArrayResize(m_session_exp_int, 5);
   m_session_exp_int[0] = MQTT_PROP_IDENTIFIER_SESSION_EXPIRY_INTERVAL;
   uchar aux[4];
   EncodeFourByteInteger(seconds, aux);
   ArrayCopy(m_session_exp_int, aux, 1);
   m_propslen += m_session_exp_int.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::Build(uchar &pkt[])
  {
   uchar fixhead[];
   uchar remlen[];
   EncodeVariableByteInteger(m_remlen, remlen);
   ArrayResize(fixhead, remlen.Size() + 1);
   fixhead[0] = CONNECT << 4;
   ArrayCopy(fixhead, remlen, 1);
//---
   uchar varhead[];
   ArrayResize(varhead, m_remlen, 1024);
   varhead[0] = MQTT_PROTOCOL_NAME_LENGTH_MSB;
   varhead[1] = MQTT_PROTOCOL_NAME_LENGTH_LSB;
   varhead[2] = MQTT_PROTOCOL_NAME_BYTE_3;
   varhead[3] = MQTT_PROTOCOL_NAME_BYTE_4;
   varhead[4] = MQTT_PROTOCOL_NAME_BYTE_5;
   varhead[5] = MQTT_PROTOCOL_NAME_BYTE_6;
   varhead[6] = MQTT_PROTOCOL_VERSION;
   varhead[7] = m_connect_flags;
   varhead[8] = keepAlive.msb;
   varhead[9] = keepAlive.lsb;
//---
   ArrayCopy(pkt, fixhead);
   ArrayCopy(pkt, varhead, pkt.Size());
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetClientIdentifier(string clientId)
  {
   GetClienIdLen(clientId);
   StringToCharArray(clientId, m_clientId, 0, StringLen(clientId));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::GetClienIdLen(string clientId)
  {
   clientIdLen.msb = (char)StringLen(clientId) >> 8;
   clientIdLen.lsb = (char)(StringLen(clientId) % 256);
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
   passwordFlag ? m_connect_flags |= PASSWORD_FLAG : m_connect_flags &= ~PASSWORD_FLAG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetUserNameFlag(const bool userNameFlag)
  {
   userNameFlag ? m_connect_flags |= USER_NAME_FLAG : m_connect_flags &= (uchar) ~USER_NAME_FLAG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillRetain(const bool willRetain)
  {
   willRetain ? m_connect_flags |= WILL_RETAIN : m_connect_flags &= ~WILL_RETAIN;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillQoS_2(const bool willQoS_2)
  {
   willQoS_2 ? m_connect_flags |= WILL_QOS_2 : m_connect_flags &= ~WILL_QOS_2;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillQoS_1(const bool willQoS_1)
  {
   willQoS_1 ? m_connect_flags |= WILL_QOS_1 : m_connect_flags &= ~WILL_QOS_1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetWillFlag(const bool willFlag)
  {
   willFlag ? m_connect_flags |= WILL_FLAG : m_connect_flags &= ~WILL_FLAG;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetCleanStart(const bool cleanStart)
  {
   cleanStart ? m_connect_flags |= CLEAN_START : m_connect_flags &= ~CLEAN_START;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CConnect::CConnect()
  {
   m_remlen = 10;
   m_propslen = 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CConnect::~CConnect()
  {
  }
//+------------------------------------------------------------------+
