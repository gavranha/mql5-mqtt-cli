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
   uchar             ByteArray[];
   //--- methods for setting Topic Name, Packet ID
   void              SetTopicName(const string topicName);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPktPublish::CPktPublish(uchar& payload[])
  {
   ArrayFree(ByteArray);
   ArrayResize(ByteArray, payload.Size() + 2, 0);
   ArrayCopy(m_buf, payload);
   SetFixedHeader(PUBLISH, payload, ByteArray, m_publish_flags);
  }
//+------------------------------------------------------------------+
//|            CPktPublish::CheckForWildcardChar                     |
//+------------------------------------------------------------------+
bool CPktPublish::HasWildcardChar(const string str)
  {
   if(StringFind(str, "#") > 0 || StringFind(str, "+") > 0)
     {
      printf("Wildcard char not allowed in Topic Names");
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|            CPktPublish::SetTopicName                             |
//+------------------------------------------------------------------+
void CPktPublish::SetTopicName(const string topicName)
  {
   if(HasWildcardChar(topicName) || StringLen(topicName) == 0)
     {
      ArrayFree(ByteArray);
      return;
     }
   ushort encodedString[];
   EncodeUTF8String(topicName, encodedString);
   ArrayCopy(ByteArray, encodedString, 2);
   ByteArray[1] = EncodeVariableByteInteger(encodedString);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetDup(const bool dup)
  {
   dup ? m_publish_flags |= DUP_FLAG : m_publish_flags &= ~DUP_FLAG;
   SetFixedHeader(PUBLISH, m_buf, ByteArray, m_publish_flags);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetQoS_2(const bool QoS_2)
  {
   QoS_2 ? m_publish_flags |= QoS_2_FLAG : m_publish_flags &= ~QoS_2_FLAG;
   SetFixedHeader(PUBLISH, m_buf, ByteArray, m_publish_flags);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetQoS_1(const bool QoS_1)
  {
   QoS_1 ? m_publish_flags |= QoS_1_FLAG : m_publish_flags &= ~QoS_1_FLAG;
   SetFixedHeader(PUBLISH, m_buf, ByteArray, m_publish_flags);
  }
//+------------------------------------------------------------------+
//|               CPktPublish::SetRetain                             |
//+------------------------------------------------------------------+
void CPktPublish::SetRetain(const bool retain)
  {
   retain ? m_publish_flags |= RETAIN_FLAG : m_publish_flags &= ~RETAIN_FLAG;
   SetFixedHeader(PUBLISH, m_buf, ByteArray, m_publish_flags);
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
