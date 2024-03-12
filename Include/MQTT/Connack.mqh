//+------------------------------------------------------------------+
//|                                                      Connack.mqh |
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
   string            ReadReasonString(uchar &inpkt[], uint idx);
   uint              ReadSessionExpiryInterval(uchar &inpkt[], uint idx);
   ushort            ReadReceiveMaximum(uchar &inpkt[], uint idx);
   uchar             ReadMaximumQoS(uchar &inpkt[], uint idx);
   uchar             ReadRetainAvailable(uchar &inpkt[], uint idx);
   uint              ReadMaximumPacketSize(uchar &inpkt[], uint idx);
   string            ReadAssignedClientIdentifier(uchar &inpkt[], uint idx);
   ushort            ReadTopicAliasMaximum(uchar &inpkt[], uint idx);
   uchar             ReadWildcardSubscriptionAvailable(uchar &inpkt[], uint idx);
   uchar             ReadSubscriptionIdentifierAvailable(uchar &inpkt[], uint idx);
   uchar             ReadSharedSubscriptionAvailable(uchar &inpkt[], uint idx);
   ushort            ReadServerKeepAlive(uchar &inpkt[], uint idx);
   string            ReadResponseInformation(uchar &inpkt[], uint idx);
   string            ReadServerReference(uchar &inpkt[], uint idx);
   string            ReadAuthenticationMethod(uchar &inpkt[], uint idx);
   string            ReadAuthenticationData(uchar &inpkt[], uint idx);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CConnack::ReadAuthenticationData(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CConnack::ReadAuthenticationMethod(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CConnack::ReadServerReference(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CConnack::ReadResponseInformation(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ushort CConnack::ReadServerKeepAlive(uchar &inpkt[], uint idx)
  {
   uchar aux[];
   ArrayCopy(aux, inpkt, 0, idx);
   return DecodeTwoByteInt(aux);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CConnack::ReadSharedSubscriptionAvailable(uchar &inpkt[], uint idx)
  {
   return inpkt[idx];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CConnack::ReadSubscriptionIdentifierAvailable(uchar &inpkt[], uint idx)
  {
   return inpkt[idx];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CConnack::ReadWildcardSubscriptionAvailable(uchar &inpkt[], uint idx)
  {
   return inpkt[idx];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ushort CConnack::ReadTopicAliasMaximum(uchar &inpkt[], uint idx)
  {
   uchar aux[];
   ArrayCopy(aux, inpkt, 0, idx, 2);
   return DecodeTwoByteInt(aux);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CConnack::ReadAssignedClientIdentifier(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint CConnack::ReadMaximumPacketSize(uchar &inpkt[], uint idx)
  {
   uchar aux[];
   ArrayCopy(aux, inpkt, 0, idx, 4);
   uint max_pkt_s = DecodeFourByteInt(aux);
   return max_pkt_s;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CConnack::ReadRetainAvailable(uchar &inpkt[], uint idx)
  {
   return inpkt[idx];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CConnack::ReadMaximumQoS(uchar &inpkt[], uint idx)
  {
   return inpkt[idx];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ushort CConnack::ReadReceiveMaximum(uchar &inpkt[], uint idx)
  {
   uchar aux[];
   ArrayCopy(aux, inpkt, 0, idx, 2);
   ushort recv_max = DecodeTwoByteInt(aux);
   return recv_max;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint CConnack::ReadSessionExpiryInterval(uchar &inpkt[], uint idx)
  {
   uchar aux[];
   ArrayCopy(aux, inpkt, 0, idx, 4);
   uint session_expiry_int = DecodeFourByteInt(aux);
   return session_expiry_int;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CConnack::ReadReasonString(uchar &inpkt[], uint idx)
  {
   return ReadUtf8String(inpkt, idx);
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
    return inpkt[0] == (CONNACK << 4) ? true : false;
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
