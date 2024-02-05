//+------------------------------------------------------------------+
//|                                                   PktPublish.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13998 **** |
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
//| Class CPktPublish.                                               |
//| Purpose: Class of MQTT Publish Control Packets.                  |
//|          Implements IControlPacket                               |
//+------------------------------------------------------------------+
class CPktPublish : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
   bool              HasWildcardChar(const string str);
protected:
   uchar             m_buf[];
   uint              m_fix_header[];
   uchar             m_publish_flags;
   uint              m_remaining_length;
   ushort            m_topic_name[];
   ushort            m_packet_id;
   uint              m_props[];
   uint              m_var_header[];
   uint              m_payload[];
   uchar             m_tmp_properties_buf[];
   void              SetFixHeader(ENUM_PKT_TYPE, uint rem_length, uchar pub_flags = 0);

public:
                     CPktPublish();
                     CPktPublish(uchar& payload[]);
                     CPktPublish(uint& payload[]);
                    ~CPktPublish();
   //--- methods for setting Publish flags
   void              SetRetain(const bool retain);
   void              SetQoS_1(const bool QoS_1);
   void              SetQoS_2(const bool QoS_2);
   void              SetDup(const bool dup);

   //--- member for getting the byte array
   uint              m_byte_array[];
   //--- methods for setting Topic Name and Properties
   void              SetTopicName(const string topic_name);
   void              SetPropMsgExpiryInterval(uint msg_expiry_interval);
   //--- method for building the final packet
   void              Build(uint &result[]);

  };
//+------------------------------------------------------------------+
//|                SetPropMsgExpiryInterval                          |
//+------------------------------------------------------------------+
void CPktPublish::SetPropMsgExpiryInterval(uint msg_expiry_interval)
  {
   ArrayResize(m_tmp_properties_buf, 5);
   m_tmp_properties_buf[0] = MQTT_PROPERTY_MESSAGE_EXPIRY_INTERVAL;
   uchar value[4];
   value[0] = (uchar)msg_expiry_interval >> 24;
   value[1] = (uchar)msg_expiry_interval >> 16;
   value[2] = (uchar)msg_expiry_interval >> 8;
   value[3] = (uchar)msg_expiry_interval;
   ArrayCopy(m_tmp_properties_buf, value, 1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetFixHeader(ENUM_PKT_TYPE pkt_type, uint rem_length, uchar pub_flags = 0)
  {
   m_fix_header[0] = (uchar)pkt_type << 4;
   m_fix_header[0] |= m_publish_flags;
   uint aux[];
   EncodeVariableByteInteger(rem_length, aux);
   ArrayCopy(m_fix_header, aux, 1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::Build(uint &dest[])
  {
   ArrayResize(dest, 10);
//ArrayCopy(dest, m_var_header, 2);
//ArrayCopy(dest, m_payload, dest.Size() + 1);
   SetFixHeader(PUBLISH, m_remaining_length, m_publish_flags);
   ArrayCopy(dest, m_fix_header);
   ArrayResize(m_var_header, (m_topic_name.Size() + 2 + m_props.Size()));
   SetPacketID(m_var_header, m_topic_name.Size() + 1);
   ArrayCopy(dest, m_var_header, dest.Size() + 1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPktPublish::CPktPublish(uint &payload[])
  {
   ArrayFree(m_fix_header);
   ArrayFree(m_var_header);
   ArrayFree(m_payload);
   ArrayResize(m_fix_header, payload.Size() + 2, 4);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPktPublish::CPktPublish(uchar& payload[])
  {
   ArrayFree(m_byte_array);
   ArrayResize(m_byte_array, payload.Size() + 2, 0);
   ArrayCopy(m_buf, payload);
   SetFixedHeader(PUBLISH, payload, m_byte_array, m_publish_flags);
  }
//+------------------------------------------------------------------+
//|            CPktPublish::HasWildcardChar                          |
//+------------------------------------------------------------------+
bool CPktPublish::HasWildcardChar(const string str)
  {
   if(StringFind(str, "#") > -1 || StringFind(str, "+") > -1)
     {
      printf("Wildcard char not allowed in Topic Names");
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|            CPktPublish::SetTopicName                             |
//+------------------------------------------------------------------+
void CPktPublish::SetTopicName(const string topic_name)
  {
   if(HasWildcardChar(topic_name) || StringLen(topic_name) == 0)
     {
      ArrayFree(m_topic_name);
      return;
     }
   EncodeUTF8String(topic_name, m_topic_name);
   m_remaining_length += m_topic_name.Size();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetDup(const bool dup)
  {
   dup ? m_publish_flags |= DUP_FLAG : m_publish_flags &= ~DUP_FLAG;
   SetFixedHeader(PUBLISH, m_buf, m_byte_array, m_publish_flags);
  }
//+------------------------------------------------------------------+
//|            CPktPublish::SetQoS_2                                 |
//+------------------------------------------------------------------+
void CPktPublish::SetQoS_2(const bool QoS_2)
  {
   QoS_2 ? m_publish_flags |= QoS_2_FLAG : m_publish_flags &= ~QoS_2_FLAG;
   SetFixedHeader(PUBLISH, m_buf, m_byte_array, m_publish_flags);
   SetPacketID(m_byte_array, m_byte_array.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetQoS_1(const bool QoS_1)
  {
   QoS_1 ? m_publish_flags |= QoS_1_FLAG : m_publish_flags &= ~QoS_1_FLAG;
   SetFixedHeader(PUBLISH, m_buf, m_byte_array, m_publish_flags);
   SetPacketID(m_byte_array, m_byte_array.Size());
  }
//+------------------------------------------------------------------+
//|               CPktPublish::SetRetain                             |
//+------------------------------------------------------------------+
void CPktPublish::SetRetain(const bool retain)
  {
   retain ? m_publish_flags |= RETAIN_FLAG : m_publish_flags &= ~RETAIN_FLAG;
   SetFixedHeader(PUBLISH, m_buf, m_byte_array, m_publish_flags);
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
