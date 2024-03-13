//+------------------------------------------------------------------+
//|                                                   Disconnect.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"
#include "MQTT.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CDisconnect : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
   uint              m_remlen;
public:
                     CDisconnect();
                    ~CDisconnect();
   static bool       IsDisconnect(uchar &inpkt[]);
   void              Build(uchar &pkt[]);
   void              AddRemainingLength(uchar &pkt[], uint idx = 1);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CDisconnect::AddRemainingLength(uchar &pkt[], uint idx = 1)
  {
   uchar aux[] = {};
   EncodeVariableByteInteger(m_remlen, aux);
   ArrayCopy(pkt, aux, idx, 0, aux.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CDisconnect::Build(uchar &pkt[])
  {
   ArrayResize(pkt, GetVarintBytes(m_remlen) + m_remlen);
   pkt[0] = (SUBSCRIBE << 4) | 2;
   AddRemainingLength(pkt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CDisconnect::IsDisconnect(uchar &inpkt[])
  {
   return inpkt[0] == (DISCONNECT << 4) ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDisconnect::CDisconnect()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDisconnect::~CDisconnect()
  {
  }
//+------------------------------------------------------------------+
