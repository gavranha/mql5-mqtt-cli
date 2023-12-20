//+------------------------------------------------------------------+
//|                                                   PktPublish.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13388 **** |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"
//+------------------------------------------------------------------+
//|        PUBLISH VARIABLE HEADER                                   |
//+------------------------------------------------------------------+
/*
The Variable Header of the PUBLISH Packet contains the following fields in the order: Topic Name,
Packet Identifier, and Properties.
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
//| Class CPktPublish.                                               |
//| Purpose: Class of MQTT Publish Control Packets.                  |
//|          Implements IControlPacket                               |
//+------------------------------------------------------------------+
class CPktPublish : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
protected:
   void              InitConnectFlags() {ByteArray[9] = 0;}
   void              InitKeepAlive() {ByteArray[10] = 0; ByteArray[11] = 0;}
   void              InitPropertiesLength() {ByteArray[12] = 0;}
   uchar             m_connect_flags;

public:
                     CPktPublish();
                     CPktPublish(uchar &buf[]);
                    ~CPktPublish();
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
   uchar             ByteArray[];
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPktPublish::CPktPublish(uchar &buf[])
  {
   ArrayFree(ByteArray);
   ArrayResize(ByteArray, buf.Size() + 2, UCHAR_MAX);
   SetFixedHeader(CONNECT, buf, ByteArray);
   SetProtocolName(ByteArray);
   SetProtocolVersion(ByteArray);
   InitConnectFlags();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetClientIdentifier(string clientId)
  {
   SetClientIdentifierLength(clientId);
   StringToCharArray(clientId, ByteArray,
                     ByteArray.Size() - StringLen(clientId), StringLen(clientId));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetClientIdentifierLength(string clientId)
  {
   clientIdLen.msb = (char)StringLen(clientId) >> 8;
   clientIdLen.lsb = (char)(StringLen(clientId) % 256);
   ByteArray[12] = clientIdLen.msb;
   ByteArray[13] = clientIdLen.lsb;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetKeepAlive(ushort seconds) // MQTT max is 65,535 sec
  {
   keepAlive.msb = (uchar)(seconds >> 8) & 255;
   keepAlive.lsb = (uchar)seconds & 255;
   ByteArray[10] = keepAlive.msb;
   ByteArray[11] = keepAlive.lsb;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetPasswordFlag(const bool passwordFlag)
  {
   passwordFlag ? m_connect_flags |= PASSWORD_FLAG : m_connect_flags &= ~PASSWORD_FLAG;
   ArrayFill(ByteArray, ArraySize(ByteArray) - 1, 1, m_connect_flags);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetUserNameFlag(const bool userNameFlag)
  {
   userNameFlag ? m_connect_flags |= USER_NAME_FLAG : m_connect_flags &= (uchar) ~USER_NAME_FLAG;
   ArrayFill(ByteArray, ArraySize(ByteArray) - 1, 1, m_connect_flags);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetWillRetain(const bool willRetain)
  {
   willRetain ? m_connect_flags |= WILL_RETAIN : m_connect_flags &= ~WILL_RETAIN;
   ArrayFill(ByteArray, ArraySize(ByteArray) - 1, 1, m_connect_flags);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetWillQoS_2(const bool willQoS_2)
  {
   willQoS_2 ? m_connect_flags |= WILL_QOS_2 : m_connect_flags &= ~WILL_QOS_2;
   ArrayFill(ByteArray, ArraySize(ByteArray) - 1, 1, m_connect_flags);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetWillQoS_1(const bool willQoS_1)
  {
   willQoS_1 ? m_connect_flags |= WILL_QOS_1 : m_connect_flags &= ~WILL_QOS_1;
   ArrayFill(ByteArray, ArraySize(ByteArray) - 1, 1, m_connect_flags);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetWillFlag(const bool willFlag)
  {
   willFlag ? m_connect_flags |= WILL_FLAG : m_connect_flags &= ~WILL_FLAG;
   ArrayFill(ByteArray, ArraySize(ByteArray) - 1, 1, m_connect_flags);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetCleanStart(const bool cleanStart)
  {
   cleanStart ? m_connect_flags |= CLEAN_START : m_connect_flags &= ~CLEAN_START;
   ArrayFill(ByteArray, ArraySize(ByteArray) - 1, 1, m_connect_flags);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPktPublish::CPktPublish()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPktPublish::~CPktPublish()
  {
  }
//+------------------------------------------------------------------+
