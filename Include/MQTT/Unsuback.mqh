//+------------------------------------------------------------------+
//|                                                     Unsuback.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CUnsuback : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}

public:
                     CUnsuback();
                    ~CUnsuback();
   static bool       IsUnsuback(uchar &inpkt[]);
   string            ReadReasonString(uchar &inpkt[], uint idx);
   void              ReadPayload(uchar &inpkt[], uchar &dest_buf[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUnsuback::ReadPayload(uchar &inpkt[], uchar &dest_buf[])
  {
   ArrayCopy(dest_buf, inpkt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CUnsuback::ReadReasonString(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CUnsuback::IsUnsuback(uchar &inpkt[])
  {
   return inpkt[0] == UNSUBACK << 4 ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CUnsuback::CUnsuback()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CUnsuback::~CUnsuback()
  {
  }
//+------------------------------------------------------------------+
