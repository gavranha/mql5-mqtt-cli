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

  };
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
