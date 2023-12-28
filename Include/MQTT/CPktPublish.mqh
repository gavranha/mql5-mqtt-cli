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
protected:
   void              InitFixedHeader() {ByteArray[0] = PUBLISH << 4;}
   uchar             m_publish_flags;
public:
                     CPktPublish();
                     CPktPublish(uchar &buf[]);
                    ~CPktPublish();
   //--- methods for setting Publish flags
   void              SetRetain(const bool retain);
   void              SetQoS_1(const bool QoS_1);
   void              SetQoS_2(const bool QoS_2);
   void              SetDup(const bool dup);

   //--- member for getting the byte array
   uchar             ByteArray[];
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPktPublish::CPktPublish(uchar &buf[])
  {
   ArrayFree(ByteArray);
   ArrayResize(ByteArray, buf.Size() + 2, 0);
   InitFixedHeader();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetDup(const bool dup)
  {
   dup ? m_publish_flags |= DUP_FLAG : m_publish_flags &= ~DUP_FLAG;
   ByteArray[0] |= m_publish_flags;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetQoS_2(const bool QoS_2)
  {
   QoS_2 ? m_publish_flags |= QoS_2_FLAG : m_publish_flags &= ~QoS_2_FLAG;
   ByteArray[0] |= m_publish_flags;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetQoS_1(const bool QoS_1)
  {
   QoS_1 ? m_publish_flags |= QoS_1_FLAG : m_publish_flags &= ~QoS_1_FLAG;
   ByteArray[0] |= m_publish_flags;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPktPublish::SetRetain(const bool retain)
  {
   retain ? m_publish_flags |= RETAIN_FLAG : m_publish_flags &= ~RETAIN_FLAG;
   ByteArray[0] |= m_publish_flags;
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
