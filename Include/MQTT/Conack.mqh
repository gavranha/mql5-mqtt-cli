//+------------------------------------------------------------------+
//|                                                       Conack.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"
class CConack : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
public:
                     CConack(uchar &inpkt[]);
                    ~CConack();
   bool              IsConnack(uchar &ininpkt[]);
   bool              IsSessionPresent(uchar &inpkt[]);
   uchar             ReadReasonCode(uchar &inpkt[]);
   uint              ReadPropertyLength(uchar &inpkt[]);
   string            ReadReasonString(uchar &inpkt[], uint idx, uint count);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CConack::ReadReasonString(uchar &inpkt[], uint idx, uint count)
  {
   string reasonstr = ReadUtf8String(inpkt, idx, count);
   return reasonstr;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint CConack::ReadPropertyLength(uchar &inpkt[])
  {
   uint propslen = DecodeVariableByteInteger(inpkt, 4);
   return propslen;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CConack::ReadReasonCode(uchar &inpkt[])
  {
   return inpkt[3];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CConack::IsSessionPresent(uchar &inpkt[])
  {
   return inpkt[2] == 1 ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CConack::IsConnack(uchar &inpkt[])
  {
   if(inpkt[0] == (CONNACK << 4))
     {
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CConack::CConack(uchar &inpkt[])
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CConack::~CConack()
  {
  }
//+------------------------------------------------------------------+
