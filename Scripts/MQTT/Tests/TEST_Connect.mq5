//+------------------------------------------------------------------+
//|                                             TEST_CPktConnect.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13388 **** |
//+------------------------------------------------------------------+
#include <MQTT\Connect.mqh>
#include "TestUtil.mqh"

//+------------------------------------------------------------------+
//|           Tests for CConnect class                            |
//+------------------------------------------------------------------+
void OnStart()
  {
// test protected methods or public methods that set protected fields
   CProtMeths *t = new CProtMeths();
Print(t.TEST_SetCleanStart());
Print(t.TEST_SetWillFlag());
Print(t.TEST_SetWillQoS_1());
Print(t.TEST_SetWillQoS_2());
Print(t.TEST_SetWillRetain());
Print(t.TEST_SetPasswordFlag());
Print(t.TEST_SetUserNameFlag());
Print(t.TEST_SetKeepAlive());
Print(t.TEST_SetKeepAlive_ZERO());
Print(t.TEST_Prop_SetSessionExpiryInterval());
Print(t.TEST_Prop_SetReceiveMaximum());
Print(t.TEST_Prop_SetMaximumPacketSize());
Print(t.TEST_Prop_SetTopicAliasMaximum());
Print(t.TEST_Prop_SetRequestResponseInfo_YES());
Print(t.TEST_Prop_SetRequestResponseInfo_NO());
Print(t.TEST_Prop_SetRequestProblemInfo_YES());
Print(t.TEST_Prop_SetRequestProblemInfo_NO());
Print(t.TEST_Prop_SetUserProperty());
Print(t.TEST_Prop_SetAuthMethod());
Print(t.TEST_Prop_SetAuthData());
Print(t.TEST_PropertyLength_OneProp());
Print(t.TEST_PropertyLength_TwoProps());
Print(t.TEST_PropertyLength_ThreeProps());
Print(t.TEST_WillPropertyLength_OneProp());
Print(t.TEST_WillPropertyLength_TwoProps());
Print(t.TEST_WillPropertyLength_ThreeProps());
Print(t.TEST_Payload_SetClientIdentifier());
Print(t.TEST_WillProps_SetWillDelayInterval());
Print(t.TEST_Payload_SetWillPayloadFormatIndicator_UTF8());
Print(t.TEST_Payload_SetWillPayloadFormatIndicator_RawBytes());
Print(t.TEST_Payload_SetWillMessageExpiryInterval());
Print(t.TEST_Payload_SetWillContentType());
Print(t.TEST_Payload_SetWillResponseTopic());
Print(t.TEST_Payload_SetWillCorrelationData());
Print(t.TEST_Payload_SetWillUserProperty());
Print(t.TEST_Payload_SetWillTopic());
Print(t.TEST_Payload_SetWillPayload());
Print(t.TEST_Payload_SetUserName());
Print(t.TEST_Payload_SetPassword());
   delete(t);
//---
// test public methods
//Print(TEST_Build_NoProps_NoPayload());
//Print(TEST_Build_NoProps_NoPayload_OneProp());
   //Print(TEST_Build_MosquittoRef());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Build_MosquittoRef()
  {
   uchar expected[] = {10, 0x0c, 00, 04, 0x4d, 51, 54, 54, 04, 02, 00, 0x3c, 00, 00};
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Build_NoProps_NoPayload_OneProp()
  {
   Print( __FUNCTION__);
   uchar expected[] = {};
//--- fixhead
   uchar fixhead[] = {16, '?'};
   ArrayCopy(expected, fixhead);
//--- varhead
   uchar varhead[] = {0, 4, 'M', 'Q', 'T', 'T', 5, '?', '?', '?'};
   uchar cleanstart[] = {2};
   ArrayCopy(varhead, cleanstart, 7);
   uchar keepalive[] = {0, 10};
   ArrayCopy(varhead, keepalive, 8);
   ArrayCopy(expected, varhead, expected.Size());
//--- properties
   uchar propslen[] = {5}; // test param
   ArrayCopy(expected, propslen, expected.Size());
//---
   uchar props[] = {};
   uchar sessionexpiry[] = {17, 0, 0, 0, 10};
   ArrayCopy(props, sessionexpiry, 0);
   ArrayCopy(expected, props, expected.Size());
//--- remaining length
   uchar remlen = (uchar)(expected.Size() - 2);
   ArrayFill(expected, 1, 1, remlen);
//--- {16, 16, 0, 4, M, Q, T, T, 5, 2, 0, 10, 5, 17, 0, 0, 0, 10};
//--- ArrayPrint(expected);
   uchar result[];
   CConnect *cut = new CConnect();
   cut.SetCleanStart(true);
   cut.SetKeepAlive(10);
   cut.SetSessionExpiryInterval(10);
   cut.Build(result);
//---
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Build_NoProps_NoPayload()
  {
   Print( __FUNCTION__);
   uchar expected[] = {16, 16, 0, 4, 'M', 'Q', 'T', 'T', 5, 2, 0, 10, 0, 4, 'M', 'Q', 'L', '5'};
   uchar result[];
   CConnect *cut = new CConnect();
   cut.SetCleanStart(true);
   cut.SetKeepAlive(10);
   cut.SetClientIdentifier("MQL5");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CProtMeths: public CConnect
  {
public:
                     CProtMeths() {};
                    ~CProtMeths() {};
   bool              TEST_SetCleanStart();
   bool              TEST_SetWillFlag();
   bool              TEST_SetWillQoS_1();
   bool              TEST_SetWillQoS_2();
   bool              TEST_SetWillRetain();
   bool              TEST_SetPasswordFlag();
   bool              TEST_SetUserNameFlag();
   bool              TEST_SetKeepAlive();
   bool              TEST_SetClientIdentifier();
   bool              TEST_SetKeepAlive_ZERO();
   bool              TEST_Prop_SetSessionExpiryInterval();
   bool              TEST_Prop_SetReceiveMaximum();
   bool              TEST_Prop_SetMaximumPacketSize();
   bool              TEST_Prop_SetTopicAliasMaximum();
   bool              TEST_Prop_SetRequestResponseInfo_YES();
   bool              TEST_Prop_SetRequestResponseInfo_NO();
   bool              TEST_Prop_SetRequestProblemInfo_YES();
   bool              TEST_Prop_SetRequestProblemInfo_NO();
   bool              TEST_Prop_SetUserProperty();
   bool              TEST_Prop_SetAuthMethod();
   bool              TEST_Prop_SetAuthData();
   bool              TEST_WillPropertyLength_OneProp();
   bool              TEST_WillPropertyLength_TwoProps();
   bool              TEST_WillPropertyLength_ThreeProps();
   bool              TEST_PropertyLength_OneProp();
   bool              TEST_PropertyLength_TwoProps();
   bool              TEST_PropertyLength_ThreeProps();
   bool              TEST_Payload_SetClientIdentifier();
   bool              TEST_WillProps_SetWillDelayInterval();
   bool              TEST_Payload_SetWillPayloadFormatIndicator_UTF8();
   bool              TEST_Payload_SetWillPayloadFormatIndicator_RawBytes();
   bool              TEST_Payload_SetWillMessageExpiryInterval();
   bool              TEST_Payload_SetWillContentType();
   bool              TEST_Payload_SetWillResponseTopic();
   bool              TEST_Payload_SetWillCorrelationData();
   bool              TEST_Payload_SetWillUserProperty();
   bool              TEST_Payload_SetWillTopic();
   bool              TEST_Payload_SetWillPayload();
   bool              TEST_Payload_SetUserName();
   bool              TEST_Payload_SetPassword();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetPassword(void)
  {
   Print( __FUNCTION__);
   uchar expected[] = {'p', 'a', 's', 's', 'w', 'o', 'r', 'd'};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetPassword("password");
   ArrayCopy(result, this.m_password);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetUserName()
  {
   Print( __FUNCTION__);
   uchar expected[] = {0, 8, 'u', 's', 'e', 'r', 'n', 'a', 'm', 'e'};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetUserName("username");
   ArrayCopy(result, this.m_user_name);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetWillPayload(void)
  {
   Print( __FUNCTION__);
   uchar expected[] = {'w', 'i', 'l', 'l', 'p', 'a', 'y', 'l', 'o', 'a', 'd'};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetWillPayload("willpayload");
   ArrayCopy(result, this.m_will_payload);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetWillTopic(void)
  {
   Print( __FUNCTION__);
   uchar expected[] = {0, 9, 'w', 'i', 'l', 'l', 't', 'o', 'p', 'i', 'c'};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetWillTopic("willtopic");
   ArrayCopy(result, this.m_will_topic);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetWillUserProperty()
  {
   Print( __FUNCTION__);
   uchar expected[] = {38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetWillUserProperty("key:", "val");
   ArrayCopy(result, this.m_will_userprop);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetWillCorrelationData()
  {
   Print( __FUNCTION__);
   uchar expected[] = {9, 'c', 'o', 'r', 'r', 'd', 'a', 't', 'a'};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetWillCorrelationData("corrdata");
   ArrayCopy(result, this.m_will_corrdata);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetWillResponseTopic()
  {
   Print( __FUNCTION__);
   uchar expected[] = {8, 0, 9, 'r', 'e', 's', 'p', 't', 'o', 'p', 'i', 'c'};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetWillResponseTopic("resptopic");
   ArrayCopy(result, this.m_will_resptopic);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetWillContentType(void)
  {
   Print( __FUNCTION__);
   uchar expected[] = {3, 0, 8, 'c', 'o', 'n', 't', 't', 'y', 'p', 'e'};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetWillContentType("conttype");
   ArrayCopy(result, this.m_will_contenttype);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetWillMessageExpiryInterval(void)
  {
   Print( __FUNCTION__);
   uchar expected[] = {2, 0, 0, 0, 10};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetWillMessageExpiryInterval(10);
   ArrayCopy(result, this.m_will_msgexpint);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetWillPayloadFormatIndicator_RawBytes()
  {
   Print( __FUNCTION__);
   uchar expected[] = {1, 0};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetWillPayloadFormatIndicator(0);
   ArrayCopy(result, this.m_will_payloadformat);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetWillPayloadFormatIndicator_UTF8()
  {
   Print( __FUNCTION__);
   uchar expected[] = {1, 1};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetWillPayloadFormatIndicator(1);
   ArrayCopy(result, this.m_will_payloadformat);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_WillProps_SetWillDelayInterval()
  {
   Print( __FUNCTION__);
   uchar expected[] = {24, 0, 0, 0, 10};
   uchar result[];
   CConnect *cut = new CConnect();
   this.SetWillDelayInterval(10);
   ArrayCopy(result, this.m_will_delayint);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Payload_SetClientIdentifier()
  {
   Print( __FUNCTION__);
   uchar expected[] = {0, 8, 'c', 'l', 'i', 'e', 'n', 't', 'i', 'd'};
   CConnect *cut = new CConnect();
   uchar result[];
   this.SetClientIdentifier("clientid");
   ArrayCopy(result, this.m_clientid);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_WillPropertyLength_ThreeProps()
  {
   Print( __FUNCTION__);
   this.m_willprops_len = 0;
   uint expected = 12;
   CConnect *cut = new CConnect();
   this.SetWillDelayInterval(10);
   this.SetWillPayloadFormatIndicator(1);
   this.SetWillMessageExpiryInterval(10);
   uint result = this.m_willprops_len;
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_WillPropertyLength_TwoProps()
  {
   Print( __FUNCTION__);
   this.m_willprops_len = 0;
   uint expected = 7;
   CConnect *cut = new CConnect();
   this.SetWillDelayInterval(10);
   this.SetWillPayloadFormatIndicator(1);
   uint result = this.m_willprops_len;
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_WillPropertyLength_OneProp()
  {
   Print( __FUNCTION__);
   this.m_willprops_len = 0;
   uint expected = 5;
   CConnect *cut = new CConnect();
   this.SetWillDelayInterval(10);
   uint result = this.m_willprops_len;
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_PropertyLength_ThreeProps()
  {
   Print( __FUNCTION__);
   this.m_connprops_len = 0;
   uint expected = 33;
   CConnect *cut = new CConnect();
   this.SetUserProperty("key:", "val"); // {38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'};
   this.SetAuthMethod("authmethod"); // {21, 0, 10, 'a', 'u', 't', 'h', 'm', 'e', 't', 'h', 'o', 'd'};
   this.SetAuthData("bindata"); // {22, 'b', 'i', 'n', 'd', 'a', 't', 'a'};
   uint result = this.m_connprops_len;
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_PropertyLength_TwoProps()
  {
   Print( __FUNCTION__);
   this.m_connprops_len = 0;
   uint expected = 21;
   CConnect *cut = new CConnect();
   this.SetAuthMethod("authmethod");// {21, 0, 10, 'a', 'u', 't', 'h', 'm', 'e', 't', 'h', 'o', 'd'};
   this.SetAuthData("bindata");// {22, 'b', 'i', 'n', 'd', 'a', 't', 'a'};
   uint result = this.m_connprops_len;
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_PropertyLength_OneProp()
  {
   Print( __FUNCTION__);
   this.m_connprops_len = 0;
   uint expected = 8;
   CConnect *cut = new CConnect();
   this.SetAuthData("bindata");// {22, 'b', 'i', 'n', 'd', 'a', 't', 'a'};
   uint result = this.m_connprops_len;
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetAuthData()
  {
   Print( __FUNCTION__);
   uchar expected[] = {22, 'b', 'i', 'n', 'd', 'a', 't', 'a'};
   CConnect *cut = new CConnect();
   this.SetAuthData("bindata");
   uchar result[];
   ArrayCopy(result, this.m_authdata);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetAuthMethod()
  {
   Print( __FUNCTION__);
   uchar expected[] = {21, 0, 10, 'a', 'u', 't', 'h', 'm', 'e', 't', 'h', 'o', 'd'};
   CConnect *cut = new CConnect();
   this.SetAuthMethod("authmethod");
   uchar result[];
   ArrayCopy(result, this.m_authmethod);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetUserProperty()
  {
   Print( __FUNCTION__);
   uchar expected[] = {38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'};
   CConnect *cut = new CConnect();
   this.SetUserProperty("key:", "val");
   uchar result[];
   ArrayCopy(result, this.m_userprop);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetRequestProblemInfo_NO()
  {
   Print( __FUNCTION__);
   uchar expected[] = {23, 0};
   CConnect *cut = new CConnect();
   this.SetRequestProblemInfo(0);
   uchar result[];
   ArrayCopy(result, this.m_req_problinfo);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetRequestProblemInfo_YES()
  {
   Print( __FUNCTION__);
   uchar expected[] = {23, 1};
   CConnect *cut = new CConnect();
   this.SetRequestProblemInfo(1);
   uchar result[];
   ArrayCopy(result, this.m_req_problinfo);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetRequestResponseInfo_NO()
  {
   Print( __FUNCTION__);
   uchar expected[] = {25, 0};
   CConnect *cut = new CConnect();
   this.SetRequestResponseInfo(0);
   uchar result[];
   ArrayCopy(result, this.m_req_respinfo);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetRequestResponseInfo_YES()
  {
   Print( __FUNCTION__);
   uchar expected[] = {25, 1};
   CConnect *cut = new CConnect();
   this.SetRequestResponseInfo(1);
   uchar result[];
   ArrayCopy(result, this.m_req_respinfo);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetTopicAliasMaximum()
  {
   Print( __FUNCTION__);
   uchar expected[] = {34, 0, 10};
   CConnect *cut = new CConnect();
   this.SetTopicAliasMaximum(10);
   uchar result[];
   ArrayCopy(result, this.m_topicalias_max);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetMaximumPacketSize()
  {
   Print( __FUNCTION__);
   uchar expected[] = {39, 0, 0, 4, 0};
   CConnect *cut = new CConnect();
   this.SetMaximumPacketSize(1024);
   uchar result[];
   ArrayCopy(result, this.m_maxpkt_size);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetReceiveMaximum()
  {
   Print( __FUNCTION__);
   uchar expected[] = {33, 0, 10};
   CConnect *cut = new CConnect();
   this.SetReceiveMaximum(10);
   uchar result[];
   ArrayCopy(result, this.m_receive_max);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_Prop_SetSessionExpiryInterval()
  {
   Print( __FUNCTION__);
   uchar expected[] = {17, 0, 0, 0, 10};
   CConnect *cut = new CConnect();
   this.SetSessionExpiryInterval(10);
   uchar result[];
   ArrayCopy(result, this.m_sessionexp_int);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_SetKeepAlive_ZERO()
  {
   Print( __FUNCTION__);
   uchar expected[] = {0, 0};
   CConnect *cut = new CConnect();
   this.SetKeepAlive(0);
   uchar result[2];
   result[0] = keepAlive.msb;
   result[1] = keepAlive.lsb;
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_SetKeepAlive()
  {
   Print( __FUNCTION__);
   uchar expected[] = {0, 10};
   CConnect *cut = new CConnect();
   this.SetKeepAlive(10);
   uchar result[2];
   result[0] = keepAlive.msb;
   result[1] = keepAlive.lsb;
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_SetUserNameFlag()
  {
   Print( __FUNCTION__);
   uchar expected = {B'10000000'};
   CConnect *cut = new CConnect();
   this.SetUserNameFlag(true);
   delete cut;
   bool isTrue = this.m_connflags == expected;
   ZeroMemory(this.m_connflags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_SetPasswordFlag()
  {
   Print( __FUNCTION__);
   uchar expected = {B'01000000'};
   CConnect *cut = new CConnect();
   this.SetPasswordFlag(true);
   delete cut;
   bool isTrue = this.m_connflags == expected;
   ZeroMemory(this.m_connflags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_SetWillRetain()
  {
   Print( __FUNCTION__);
   uchar expected = {B'00100000'};
   CConnect *cut = new CConnect();
   this.SetWillRetain(true);
   delete cut;
   bool isTrue = this.m_connflags == expected;
   ZeroMemory(this.m_connflags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_SetWillQoS_2()
  {
   Print( __FUNCTION__);
   uchar expected = {B'00010000'};
   CConnect *cut = new CConnect();
   this.SetWillQoS_2(true);
   delete cut;
   bool isTrue = this.m_connflags == expected;
   ZeroMemory(this.m_connflags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_SetWillQoS_1()
  {
   Print( __FUNCTION__);
   uchar expected = {B'00001000'};
   CConnect *cut = new CConnect();
   this.SetWillQoS_1(true);
   delete cut;
   bool isTrue = this.m_connflags == expected;
   ZeroMemory(this.m_connflags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_SetWillFlag()
  {
   Print( __FUNCTION__);
   uchar expected = {B'00000100'};
   CConnect *cut = new CConnect();
   this.SetWillFlag(true);
   delete cut;
   bool isTrue = this.m_connflags == expected;
   ZeroMemory(this.m_connflags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMeths::TEST_SetCleanStart()
  {
   Print( __FUNCTION__);
   uchar expected = {B'00000010'};
   CConnect *cut = new CConnect();
   this.SetCleanStart(true);
   delete cut;
   bool isTrue = this.m_connflags == expected;
   ZeroMemory(this.m_connflags);
   return isTrue;
  }
//+------------------------------------------------------------------+
