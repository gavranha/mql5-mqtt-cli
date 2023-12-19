//+------------------------------------------------------------------+
//|                                        CControlPacketConnect.mqh |
//|                                                         JS Lopes |
//|                                                     any@mail.net |
//+------------------------------------------------------------------+
#include "MQTT.mqh"
#include "Defines.mqh"
#include "ControlPacket.mqh"
//+------------------------------------------------------------------+
//|        CONNECT VARIABLE HEADER                                                          |
//+------------------------------------------------------------------+
struct MqttConnectVarHeader
  {
   uint              proto_name;
   uchar             proto_vers;
   uchar             connect_flags;
   ushort            keep_alive;
   uchar             user_properties[];
  } connect_varhead;
//---
struct MqttProtocolName
  {
   uchar             len_msb;
   uchar             len_lsb;
   uchar             pn_byte3;
   uchar             pn_byte4;
   uchar             pn_byte5;
   uchar             pn_byte6;
   uchar             pn_level;
  };
//---
struct MqttKeepAlive
  {
   uchar             keep_alive_msb;
   uchar             keep_alive_lsb;
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
//| Class CControlPacket.                                            |
//| Purpose: Base class of MQTT Connect Control Packets.             |
//|          Derives from class CControlPacket                       |
//+------------------------------------------------------------------+
class CControlPacketConnect: public CControlPacket
  {
   CControlPacket    m_control_packet;
   uchar             m_remaining_length;
   uint              m_buf[];
   uchar             m_connect_flags;
public:

                     CControlPacketConnect(const ENUM_PKT_TYPE pkt_type, uint &buf[]);
                    ~CControlPacketConnect(void) {};
                     CControlPacketConnect():
                     m_control_packet(CONNECT, m_buf), CControlPacket(CONNECT, m_buf) {};
   void              SetCleanStart(const bool cleanStart);
   void              SetWillFlag(const bool willFlag);
   void              SetWillQoS(const bool willQoS);
   void              SetWillRetain(const bool willRetain);
   void              SetPasswordFlag(const bool passwordFlag);
   void              SetUserNameFlag(const bool userNameFlag);
   uchar             ByteArray[];
  };
//+------------------------------------------------------------------+
CControlPacketConnect::CControlPacketConnect(ENUM_PKT_TYPE pkt_type, uint &buf[])
  {
   MqttProtocolName protoName;
   protoName.len_msb = MQTT_PROTOCOL_NAME_LENGTH_MSB;
   protoName.len_lsb = MQTT_PROTOCOL_NAME_LENGTH_LSB;
   protoName.pn_byte3 = MQTT_PROTOCOL_NAME_BYTE_3;
   protoName.pn_byte4 = MQTT_PROTOCOL_NAME_BYTE_4;
   protoName.pn_byte5 = MQTT_PROTOCOL_NAME_BYTE_5;
   protoName.pn_byte6 = MQTT_PROTOCOL_NAME_BYTE_6;
   protoName.pn_level = MQTT_PROTOCOL_VERSION;
   ZeroMemory(ByteArray);
   m_remaining_length = EncodeVariableByteInteger(buf);
   ArrayResize(ByteArray,
               (sizeof(pkt_type) +
                sizeof(m_remaining_length) +
                sizeof(protoName) +
                sizeof(m_connect_flags)));
   ArrayFill(ByteArray, 0, 1, (uchar)pkt_type);
   ArrayFill(ByteArray, 1, 1, m_remaining_length);
   StructToCharArray(protoName, ByteArray, 2);
//ArrayFill(ByteArray, 9, 1, m_connect_flags);
  }
//+------------------------------------------------------------------+
void CControlPacketConnect::SetCleanStart(const bool cleanStart)
  {
   if(cleanStart)
     {
      m_connect_flags |= CLEAN_START;
     }
   else
     {
      m_connect_flags &= ~CLEAN_START;
     }
   cleanStart ? m_connect_flags |= CLEAN_START : m_connect_flags &= ~CLEAN_START;
   ArrayFill(ByteArray, 9, 1, m_connect_flags);
  }
//+------------------------------------------------------------------+
