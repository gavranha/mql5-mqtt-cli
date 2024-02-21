//+------------------------------------------------------------------+
//|                                                      CPuback.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13998 **** |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CPuback : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
public:
                     CPuback(void) {};
                    ~CPuback(void) {};
   //--- method for building the final packet
   void              Build(uchar &pkt[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CPuback::Build(uchar &pkt[])
  {
   ArrayResize(pkt, 2);
// pkt type with publish flags
   pkt[0] = (uchar)PUBACK << 4;
  }
//+------------------------------------------------------------------+
