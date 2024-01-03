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
   uchar             m_publish_flags;
   uchar             m_buf[];
public:
                     CPktPublish();
                     CPktPublish(uchar& payload[]);
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

  };
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
      ArrayFree(m_byte_array);
      return;
     }
   ushort encoded_string[];
   EncodeUTF8String(topic_name, encoded_string);
   ArrayCopy(m_byte_array, encoded_string, 2);
// TODO: this function must be the last to be called
// when the packet is already built so we have the
// remaining length
   m_byte_array[1] = EncodeVariableByteInteger(encoded_string);
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
