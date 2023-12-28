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

public:
                     CPktPublish();
                     CPktPublish(uchar &buf[]);
                    ~CPktPublish();
   //--- methods for setting Publish flags/properties

   //--- member for getting the byte array
   uchar             ByteArray[];
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPktPublish::CPktPublish(uchar &buf[])
  {
   ArrayFree(ByteArray);
   ArrayResize(ByteArray, buf.Size(), 0);
   SetFixedHeader(PUBLISH, buf, ByteArray);
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
