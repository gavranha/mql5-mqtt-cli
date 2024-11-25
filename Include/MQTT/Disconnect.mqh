//+------------------------------------------------------------------+
//|                                                   Disconnect.mqh |
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
   void              SetRemainingLength(uchar &pkt[], uint idx = 1);
   /*
   The Client or Server sending the DISCONNECT packet MUST use one of the DISCONNECT Reason
   Code values [MQTT-3.14.2-1]. The Reason Code and Property Length can be omitted if the Reason
   Code is 0x00 (Normal disconnecton) and there are no Properties. In this case the DISCONNECT has a
   Remaining Length of 0.
   */
   void              SetReasonCode(uchar &pkt[], uint idx = 2);
   uchar             ReadDisconnReasonCode(uchar &inpkt[]);
   void              SetSessionExpiryInterval(uint seconds, uchar &dest_buf[]);
   string              ReadServerReference(uchar &inpkt[], uint idx);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CDisconnect::ReadServerReference(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CDisconnect::SetSessionExpiryInterval(uint seconds, uchar &dest_buf[])
  {
   ArrayResize(dest_buf, 5);
   dest_buf[0] = MQTT_PROP_IDENTIFIER_SESSION_EXPIRY_INTERVAL;
   uchar aux[];
   EncodeFourByteInteger(seconds, aux);
   ArrayCopy(dest_buf, aux, 1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CDisconnect::ReadDisconnReasonCode(uchar &inpkt[])
  {
   return inpkt[2];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CDisconnect::SetReasonCode(uchar &pkt[], uint idx = 2)
  {
// TBD
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CDisconnect::SetRemainingLength(uchar &pkt[], uint idx = 1)
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
   ArrayResize(pkt, GetVarintBytes(m_remlen) + m_remlen + 1);
   pkt[0] = DISCONNECT << 4;
   SetRemainingLength(pkt);
//SetReasonCode(pkt);
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
   m_remlen = 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CDisconnect::~CDisconnect()
  {
  }
//+------------------------------------------------------------------+
