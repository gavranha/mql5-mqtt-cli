//+------------------------------------------------------------------+
//|                                             TEST_CPktConnect.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13388 **** |
//+------------------------------------------------------------------+
#include <MQTT\CConnect.mqh>
#include "TestUtil.mqh"

//+------------------------------------------------------------------+
//|           Tests for CConnect class                            |
//+------------------------------------------------------------------+
void OnStart()
  {
// test protected methods or public methods that set protected fields
   TestProtMethods *t = new TestProtMethods();
   Print(t.TEST_SetCleanStart());
   Print(t.TEST_SetWillFlag());
   Print(t.TEST_SetWillQoS_1());
   Print(t.TEST_SetWillQoS_2());
   Print(t.TEST_SetWillRetain());
   Print(t.TEST_SetPasswordFlag());
   Print(t.TEST_SetUserNameFlag());
   Print(t.TEST_SetKeepAlive());
   Print(t.TEST_GetClienIdLen());
   Print(t.TEST_SetClientIdentifier());
   Print(t.TEST_SetKeepAlive_ZERO());
   Print(t.TEST_Prop_SetSessionExpiryInterval());
   Print(t.TEST_Prop_SetReceiveMaximum());
   Print(t.TEST_Prop_SetMaximumPacketSize());
   Print(t.TEST_Prop_SetTopicAliasMaximum());
   Print(t.TEST_Prop_SetRequestResponseInfo());
   Print(t.TEST_Prop_SetRequestProblemInfo());
   Print(t.TEST_Prop_SetUserProperty());
   Print(t.TEST_Prop_SetAuthMethod());
   Print(t.TEST_Prop_SetAuthData());
   Print(t.TEST_PropertiesLength_OneProp());
   Print(t.TEST_PropertiesLength_TwoProps());
   Print(t.TEST_PropertiesLength_ThreeProps());
   delete(t);
//---
// test public methods
   Print(TEST_Build_CleanStart_KeepAlive10());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Build_CleanStart_KeepAlive10()
  {
   Print(__FUNCTION__);
   uchar expected[] = {16, 10, 0, 4, 'M', 'Q', 'T', 'T', 5, 2, 0, 10};
   uchar result[];
   CConnect *cut = new CConnect();
   cut.SetCleanStart(true);
   cut.SetKeepAlive(10);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TestProtMethods: public CConnect
  {
public:
                     TestProtMethods() {};
                    ~TestProtMethods() {};
   bool              TEST_SetCleanStart();
   bool              TEST_SetWillFlag();
   bool              TEST_SetWillQoS_1();
   bool              TEST_SetWillQoS_2();
   bool              TEST_SetWillRetain();
   bool              TEST_SetPasswordFlag();
   bool              TEST_SetUserNameFlag();
   bool              TEST_SetKeepAlive();
   bool              TEST_GetClienIdLen();
   bool              TEST_SetClientIdentifier();
   bool              TEST_SetKeepAlive_ZERO();
   bool              TEST_Prop_SetSessionExpiryInterval();
   bool              TEST_Prop_SetReceiveMaximum();
   bool              TEST_Prop_SetMaximumPacketSize();
   bool              TEST_Prop_SetTopicAliasMaximum();
   bool              TEST_Prop_SetRequestResponseInfo();
   bool              TEST_Prop_SetRequestProblemInfo();
   bool              TEST_Prop_SetUserProperty();
   bool              TEST_Prop_SetAuthMethod();
   bool              TEST_Prop_SetAuthData();
   bool              TEST_PropertiesLength_OneProp();
   bool              TEST_PropertiesLength_TwoProps();
   bool              TEST_PropertiesLength_ThreeProps();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_PropertiesLength_ThreeProps()
  {
   Print(__FUNCTION__);
   this.m_propslen = 0;
   uint expected = 33;
   CConnect *cut = new CConnect();
   this.SetUserProperty("key:", "val"); // {38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'};
   this.SetAuthMethod("authmethod"); // {21, 0, 10, 'a', 'u', 't', 'h', 'm', 'e', 't', 'h', 'o', 'd'};
   this.SetAuthData("bindata"); // {22, 'b', 'i', 'n', 'd', 'a', 't', 'a'};
   uint result = this.m_propslen;
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_PropertiesLength_TwoProps()
  {
   Print(__FUNCTION__);
   this.m_propslen = 0;
   uint expected = 21;
   CConnect *cut = new CConnect();
   this.SetAuthMethod("authmethod");// {21, 0, 10, 'a', 'u', 't', 'h', 'm', 'e', 't', 'h', 'o', 'd'};
   this.SetAuthData("bindata");// {22, 'b', 'i', 'n', 'd', 'a', 't', 'a'};
   uint result = this.m_propslen;
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_PropertiesLength_OneProp()
  {
   Print(__FUNCTION__);
   this.m_propslen = 0;
   uint expected = 8;
   CConnect *cut = new CConnect();
   this.SetAuthData("bindata");// {22, 'b', 'i', 'n', 'd', 'a', 't', 'a'};
   uint result = this.m_propslen;
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_Prop_SetAuthData()
  {
   Print(__FUNCTION__);
   uchar expected[] = {22, 'b', 'i', 'n', 'd', 'a', 't', 'a'};
   CConnect *cut = new CConnect();
   this.SetAuthData("bindata");
   uchar result[];
   ArrayCopy(result, this.m_auth_data);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_Prop_SetAuthMethod()
  {
   Print(__FUNCTION__);
   uchar expected[] = {21, 0, 10, 'a', 'u', 't', 'h', 'm', 'e', 't', 'h', 'o', 'd'};
   CConnect *cut = new CConnect();
   this.SetAuthMethod("authmethod");
   uchar result[];
   ArrayCopy(result, this.m_auth_method);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_Prop_SetUserProperty()
  {
   Print(__FUNCTION__);
   uchar expected[] = {38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'};
   CConnect *cut = new CConnect();
   this.SetUserProperty("key:", "val");
   uchar result[];
   ArrayCopy(result, this.m_user_prop);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_Prop_SetRequestProblemInfo()
  {
   Print(__FUNCTION__);
   uchar expected[] = {23, 1};
   CConnect *cut = new CConnect();
   this.SetRequestProblemInfo();
   uchar result[];
   ArrayCopy(result, this.m_req_probl_info);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_Prop_SetRequestResponseInfo()
  {
   Print(__FUNCTION__);
   uchar expected[] = {25, 1};
   CConnect *cut = new CConnect();
   this.SetRequestResponseInfo();
   uchar result[];
   ArrayCopy(result, this.m_req_resp_info);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_Prop_SetTopicAliasMaximum()
  {
   Print(__FUNCTION__);
   uchar expected[] = {34, 0, 10};
   CConnect *cut = new CConnect();
   this.SetTopicAliasMaximum(10);
   uchar result[];
   ArrayCopy(result, this.m_topic_alias_max);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_Prop_SetMaximumPacketSize()
  {
   Print(__FUNCTION__);
   uchar expected[] = {39, 0, 0, 4, 0};
   CConnect *cut = new CConnect();
   this.SetMaximumPacketSize(1024);
   uchar result[];
   ArrayCopy(result, this.m_max_pkt_size);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_Prop_SetReceiveMaximum()
  {
   Print(__FUNCTION__);
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
bool TestProtMethods::TEST_Prop_SetSessionExpiryInterval()
  {
   Print(__FUNCTION__);
   uchar expected[] = {17, 0, 0, 0, 10};
   CConnect *cut = new CConnect();
   this.SetSessionExpiryInterval(10);
   uchar result[];
   ArrayCopy(result, this.m_session_exp_int);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_SetKeepAlive_ZERO()
  {
   Print(__FUNCTION__);
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
bool TestProtMethods::TEST_SetClientIdentifier()
  {
   Print(__FUNCTION__);
   uchar expected[] = {'M', 'Q', 'L', '5'};
   CConnect *cut = new CConnect();
   this.SetClientIdentifier("MQL5");
   uchar result[];
   ArrayCopy(result, m_clientId);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_GetClienIdLen()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 4};
   CConnect *cut = new CConnect();
   this.GetClienIdLen("MQL5");
   uchar result[2];
   result[0] = clientIdLen.msb;
   result[1] = clientIdLen.lsb;
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_SetKeepAlive()
  {
   Print(__FUNCTION__);
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
bool TestProtMethods::TEST_SetUserNameFlag()
  {
   Print(__FUNCTION__);
   uchar expected = {B'10000000'};
   CConnect *cut = new CConnect();
   this.SetUserNameFlag(true);
   delete cut;
   bool isTrue = this.m_connect_flags == expected;
   ZeroMemory(this.m_connect_flags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_SetPasswordFlag()
  {
   Print(__FUNCTION__);
   uchar expected = {B'01000000'};
   CConnect *cut = new CConnect();
   this.SetPasswordFlag(true);
   delete cut;
   bool isTrue = this.m_connect_flags == expected;
   ZeroMemory(this.m_connect_flags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_SetWillRetain()
  {
   Print(__FUNCTION__);
   uchar expected = {B'00100000'};
   CConnect *cut = new CConnect();
   this.SetWillRetain(true);
   delete cut;
   bool isTrue = this.m_connect_flags == expected;
   ZeroMemory(this.m_connect_flags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_SetWillQoS_2()
  {
   Print(__FUNCTION__);
   uchar expected = {B'00010000'};
   CConnect *cut = new CConnect();
   this.SetWillQoS_2(true);
   delete cut;
   bool isTrue = this.m_connect_flags == expected;
   ZeroMemory(this.m_connect_flags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_SetWillQoS_1()
  {
   Print(__FUNCTION__);
   uchar expected = {B'00001000'};
   CConnect *cut = new CConnect();
   this.SetWillQoS_1(true);
   delete cut;
   bool isTrue = this.m_connect_flags == expected;
   ZeroMemory(this.m_connect_flags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_SetWillFlag()
  {
   Print(__FUNCTION__);
   uchar expected = {B'00000100'};
   CConnect *cut = new CConnect();
   this.SetWillFlag(true);
   delete cut;
   bool isTrue = this.m_connect_flags == expected;
   ZeroMemory(this.m_connect_flags);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_SetCleanStart()
  {
   Print(__FUNCTION__);
   uchar expected = {B'00000010'};
   CConnect *cut = new CConnect();
   this.SetCleanStart(true);
   delete cut;
   bool isTrue = this.m_connect_flags == expected;
   ZeroMemory(this.m_connect_flags);
   return isTrue;
  }
//+------------------------------------------------------------------+
