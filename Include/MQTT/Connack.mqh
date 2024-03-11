//+------------------------------------------------------------------+
//|                                                       Conack.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"
class CConnack : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
public:
                     CConnack(uchar &inpkt[]);
                    ~CConnack();
   bool              IsConnack(uchar &ininpkt[]);
   bool              IsSessionPresent(uchar &inpkt[]);
   uchar             ReadReasonCode(uchar &inpkt[]);
   uint              ReadPropertyLength(uchar &inpkt[]);
   string            ReadReasonString(uchar &inpkt[], uint idx, uint count);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CConnack::ReadReasonString(uchar &inpkt[], uint idx, uint count)
  {
   string reasonstr = ReadUtf8String(inpkt, idx, count);
   return reasonstr;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint CConnack::ReadPropertyLength(uchar &inpkt[])
  {
   uint propslen = DecodeVariableByteInteger(inpkt, 4);
   return propslen;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CConnack::ReadReasonCode(uchar &inpkt[])
  {
   return inpkt[3];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CConnack::IsSessionPresent(uchar &inpkt[])
  {
   return inpkt[2] == 1 ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CConnack::IsConnack(uchar &inpkt[])
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
CConnack::CConnack(uchar &inpkt[])
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CConnack::~CConnack()
  {
  }
//+------------------------------------------------------------------+
