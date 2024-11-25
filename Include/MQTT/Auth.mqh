//+------------------------------------------------------------------+
//|                                                         Auth.mqh |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"
#include "MQTT.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CAuth : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
   uint              m_remlen;
   uint              m_remlen_bytes;
   uint              m_propslen;

public:
                     CAuth();
                    ~CAuth();
   static bool       IsAuth(uchar &inpkt[]);
   void              Build(uchar &pkt[]);
   void              AddRemainingLength(uchar &pkt[], uint idx = 1);
   void              AddPropertyLength(uchar &pkt[]);
   void              SetAuthMethod(const string auth_method, uchar &dest_buf[]);
   void              SetAuthData(const string auth_data, uchar &dest_buf[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAuth::SetAuthData(const string bindata, uchar &dest_buf[])
  {
   ArrayResize(dest_buf, StringLen(bindata) + 1);
   dest_buf[0] = MQTT_PROP_IDENTIFIER_AUTHENTICATION_DATA;
   StringToCharArray(bindata, dest_buf, 1, StringLen(bindata));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAuth::SetAuthMethod(const string auth_method, uchar &dest_buf[])
  {
   ArrayResize(dest_buf, StringLen(auth_method) + 3);
   dest_buf[0] = MQTT_PROP_IDENTIFIER_AUTHENTICATION_METHOD;
   uchar aux[];
   EncodeUTF8String(auth_method, aux);
   ArrayCopy(dest_buf,aux,1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAuth::AddPropertyLength(uchar &pkt[])
  {
   uchar aux[] = {};
   EncodeVariableByteInteger(m_propslen, aux);
   ArrayCopy(pkt, aux, m_remlen_bytes + 3);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAuth::AddRemainingLength(uchar &pkt[], uint idx = 1)
  {
   uchar aux[] = {};
   EncodeVariableByteInteger(m_remlen, aux);
   ArrayCopy(pkt, aux, idx, 0, aux.Size());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CAuth::Build(uchar &pkt[])
  {
   ArrayResize(pkt, GetVarintBytes(m_remlen) + m_remlen + 1);
   pkt[0] = AUTH << 4;
   AddRemainingLength(pkt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static bool CAuth::IsAuth(uchar &inpkt[])
  {
   return inpkt[0] == AUTH << 4 ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |

//+------------------------------------------------------------------+
CAuth::CAuth()
  {
   m_remlen = 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAuth::~CAuth()
  {
  }
//+------------------------------------------------------------------+
