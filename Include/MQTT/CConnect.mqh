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
//---
struct MqttConnectProperties
  {
   uint              prop_len;
   uchar             session_expiry_interval_id;
   uint              session_expiry_interval;
   uchar             receive_maximum_id;
   ushort            receive_maximum;
   uchar             maximum_packet_size_id;
   ushort            maximum_packet_size;
   uchar             topic_alias_maximum_id;
   ushort            topic_alias_maximum;
   uchar             request_response_information_id;
   uchar             request_response_information;
   uchar             request_problem_information_id;
   uchar             request_problem_information;
   uchar             user_property_id;
   string            user_property_key;
   string            user_property_value;
   uchar             authentication_method_id;
   string            authentication_method;
   uchar             authentication_data_id;
  } connectProps;
//---
struct MqttConnectPayload
  {
   uchar             client_id_len;
   string            client_id;
   ushort            will_properties_len;
   uchar             will_delay_interval_id;
   uint              will_delay_interval;
   uchar             payload_format_indicator_id;
   uchar             payload_format_indicator;
   uchar             message_expiry_interval_id;
   uint              message_expiry_interval;
   uchar             content_type_id;
   string            content_type;
   uchar             response_topic_id; // for request/response
   string            response_topic;
   uchar             correlation_data_id; // for request/response
   ulong             correlation_data[]; // binary data
   uchar             user_property_id;
   string            user_property_key;
   string            user_property_value;
   uchar             will_topic_len;
   string            will_topic;
   uchar             will_payload_len;
   ulong             will_payload[]; // binary data
   uchar             user_name_len;
   string            user_name;
   uchar             password_len;
   ulong             password; // binary data
  } connectPayload;
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
   void              InitConnectFlags() {m_byte_array[9] = 0;}
   void              InitKeepAlive() {m_byte_array[10] = 0; m_byte_array[11] = 0;}
   void              InitPropertiesLength() {m_byte_array[12] = 0;}

   void              SetFixHeader(uint rem_length, uint &dest_buf[]);
   uint              m_fixed_header[];

public:
                     CConnect();
                     CConnect(uchar &buf[]);
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
   void              SetClientIdentifierLength(string clientId);
   void              SetClientIdentifier(string clientId);

   //--- member for getting the byte array
   uint              m_byte_array[];
   //--- method for building the final packet
   void              Build(uchar &result[]);
  };
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
CConnect::CConnect(uchar &buf[])
  {
   ArrayFree(m_byte_array);
   ArrayResize(m_byte_array, buf.Size() + 2, UCHAR_MAX);
   SetFixedHeader(CONNECT, buf, m_byte_array);
   SetProtocolName(m_byte_array);
   SetProtocolVersion(m_byte_array);
   InitConnectFlags();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetFixHeader(uint rem_length, uint &dest_buf[])
  {
// validate(rem_length);
   EncodeVariableByteInteger(rem_length, dest_buf);
   ArrayResize(m_fixed_header, dest_buf.Size() + 1);
   m_fixed_header[0] = CONNECT << 4;
   ArrayCopy(m_fixed_header, dest_buf, 1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetClientIdentifier(string clientId)
  {
   SetClientIdentifierLength(clientId);
   uchar tmp[];
   ArrayResize(tmp, StringLen(clientId));
   StringToCharArray(clientId, tmp,
                     m_byte_array.Size() - StringLen(clientId), StringLen(clientId));
   ArrayCopy(m_byte_array, tmp, m_byte_array.Size() - StringLen(clientId));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CConnect::SetClientIdentifierLength(string clientId)
  {
   clientIdLen.msb = (char)StringLen(clientId) >> 8;
   clientIdLen.lsb = (char)(StringLen(clientId) % 256);
   m_byte_array[12] = clientIdLen.msb;
   m_byte_array[13] = clientIdLen.lsb;
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
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CConnect::~CConnect()
  {
  }
//+------------------------------------------------------------------+
