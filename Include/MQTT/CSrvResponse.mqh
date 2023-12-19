//+------------------------------------------------------------------+
//|                                                 CSrvResponse.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13651 **** |
//+------------------------------------------------------------------+
#include "IControlPacket.mqh"
#include "SrvProfile.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSrvResponse : public IControlPacket
  {
private:
   bool              IsControlPacket() {return true;}
protected:
   uchar             GetConnectReasonCode(uchar &resp_buf[]);
   bool              HasProperties(uchar &resp_buf[]);
   uchar             GetPropertyIdentifier(uchar &resp_buf[]);
   uchar             ReadOneByteProperty(uchar &resp_buf[]);
   void              ReadTwoByteProperty(uchar &resp_buf[], uchar &dest_buf[]);
   void              ReadFourByteProperty(uchar &resp_buf[], uchar &dest_buf[]);
   void              ReadVariableByteProperty(uint &resp_buf[], uint &dest_buf[], uint start_idx);
public:
                     CSrvResponse();
                     CSrvResponse(uchar &resp_buf[]);
                    ~CSrvResponse();
   ENUM_PKT_TYPE     GetPktType(uchar &resp_buf[]); // TODO move to protected
   bool              IsDUP(uchar &resp_buf[]);
   ENUM_QOS_LEVEL    GetQoSLevel(uchar &resp_buf[]);
   bool              IsRETAIN(uchar &resp_buf[]);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSrvResponse::ReadVariableByteProperty(uint &resp_buf[], uint &dest_buf[], uint start_idx)
  {
   uint value = DecodeVariableByteInteger(resp_buf, start_idx);
   ArrayResize(dest_buf,value,7);
   ArrayFill(dest_buf, 0, 1, value);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSrvResponse::ReadFourByteProperty(uchar &resp_buf[], uchar &dest_buf[])
  {
   ArrayCopy(dest_buf, resp_buf, 0, 6, 4);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSrvResponse::ReadTwoByteProperty(uchar &resp_buf[], uchar &dest_buf[])
  {
   ArrayCopy(dest_buf, resp_buf, 0, 6, 2);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CSrvResponse::ReadOneByteProperty(uchar &resp_buf[])
  {
   return resp_buf[6];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CSrvResponse::GetPropertyIdentifier(uchar &resp_buf[])
  {
   return resp_buf[5];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSrvResponse::HasProperties(uchar &resp_buf[])
  {
   return resp_buf[4] != 0 ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uchar CSrvResponse::GetConnectReasonCode(uchar &resp_buf[])
  {
   return GetPktType(resp_buf) != CONNACK ? WRONG_VALUE : resp_buf[3];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSrvResponse::IsRETAIN(uchar &resp_buf[])
  {
   return ((resp_buf[0] & 8) == 8);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_QOS_LEVEL CSrvResponse::GetQoSLevel(uchar &resp_buf[])
  {
// the order matters here
   if((resp_buf[0] & 6) == 6)
     {
      return EXACTLY_ONCE;
     }
   if((resp_buf[0] & 2) == 2)
     {
      return AT_LEAST_ONCE;
     }
   return AT_MOST_ONCE;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSrvResponse::IsDUP(uchar &resp_buf[])
  {
   return (resp_buf[0] & 8) > 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_PKT_TYPE CSrvResponse::GetPktType(uchar &resp_buf[])
  {
   return (ENUM_PKT_TYPE)(resp_buf[0] >> 4);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSrvResponse::CSrvResponse(uchar &resp_buf[])
  {
   if(GetPktType(resp_buf) == CONNACK
      && GetConnectReasonCode(resp_buf)
      == (MQTT_REASON_CODE_QOS_NOT_SUPPORTED || MQTT_REASON_CODE_RETAIN_NOT_SUPPORTED))
     {
      CSrvProfile *serverProfile = new CSrvProfile();
      serverProfile.Update("000.000.00.00", resp_buf);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSrvResponse::CSrvResponse()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSrvResponse::~CSrvResponse()
  {
  }
//+------------------------------------------------------------------+
