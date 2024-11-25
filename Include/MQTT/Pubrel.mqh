//+------------------------------------------------------------------+
//|                                                       Pubrel.mqh |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPubrel : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
public:
                     CPubrel(uchar &inpkt[]);
                    ~CPubrel();
   static bool              IsPubrel(uchar &inpkt[]);
   uchar             ReadReasonCode(uchar &inpkt[], uint idx);
   string            ReadReasonString(uchar &inpkt[], uint idx);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CPubrel::ReadReasonString(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CPubrel::ReadReasonCode(uchar &inpkt[], uint idx)
  {
   return (uchar)inpkt[idx];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CPubrel::IsPubrel(uchar &inpkt[])
  {
   return inpkt[0] == (PUBREL << 4) ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPubrel::CPubrel(uchar &inpkt[])
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPubrel::~CPubrel()
  {
  }
//+------------------------------------------------------------------+
