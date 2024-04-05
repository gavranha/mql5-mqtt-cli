//+------------------------------------------------------------------+
//|                                                       Pubcomp.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14677 **** |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPubcomp : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
public:
                     CPubcomp(uchar &inpkt[]);
                    ~CPubcomp();
   static bool       IsPubcomp(uchar &inpkt[]);
   uchar             ReadReasonCode(uchar &inpkt[], uint idx);
   string            ReadReasonString(uchar &inpkt[], uint idx);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CPubcomp::ReadReasonString(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CPubcomp::ReadReasonCode(uchar &inpkt[], uint idx)
  {
   return (uchar)inpkt[idx];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CPubcomp::IsPubcomp(uchar &inpkt[])
  {
   return inpkt[0] == (PUBCOMP << 4) ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPubcomp::CPubcomp(uchar &inpkt[])
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPubcomp::~CPubcomp()
  {
  }
//+------------------------------------------------------------------+
