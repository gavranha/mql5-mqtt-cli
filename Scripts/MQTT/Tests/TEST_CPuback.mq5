//+------------------------------------------------------------------+
//|                                                 TEST_CPuback.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14391 **** |
//+------------------------------------------------------------------+
#include <MQTT\CPuback.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//|               Tests for CPuback class                            |
//+------------------------------------------------------------------+
void OnStart()
  {
   TestProtMethods *t = new TestProtMethods();
   Print(t.TEST_GetPacketID());
   Print(t.TEST_GetReasonCode());
   Print(t.TEST_IsPendingPkt_True());
   Print(t.TEST_IsPendingPkt_False());
   Print(t.TEST_ReadProperties_ReasonString());
   Print(t.TEST_ReadProperties_UserProperty());
   Print(t.TEST_ReadProperties_ReasonString_and_UserProperty());
   delete(t);
   Print(TEST_Ctor());
   Print(TEST_Read_NoReasonCode_NoProps());
   Print(TEST_Read_PropLength_ONE());
   Print(TEST_Read_InvalidRemainingLength_0());
   Print(TEST_Read_InvalidRemainingLength_4228250625());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Read_InvalidRemainingLength_4228250625()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {4, 0xFF, 0xFF, 0xFF, 0xFF, 0, 1, 0, 0};
   int expected = -1;
   CPuback *cut = new CPuback();
   int result = cut.Read(pkt);
   bool isTrue = (result == expected);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Read_InvalidRemainingLength_0()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {4, 0, 0, 1, 0, 0};
   int expected = -1;
   CPuback *cut = new CPuback();
   int result = cut.Read(pkt);
   bool isTrue = (result == expected);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Read_PropLength_ONE()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {4, 4, 0, 1, 0, 0};
   int expected = 0;
   CPuback *cut = new CPuback();
   int result = cut.Read(pkt);
   bool isTrue = (result == expected);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Read_NoReasonCode_NoProps()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {4, 2, 0, 1};
   int expected = 0;
   CPuback *cut = new CPuback();
   int result = cut.Read(pkt);
   bool isTrue = (result == expected);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                          Ctor                                    |
//+------------------------------------------------------------------+
bool TEST_Ctor()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {64, 0};
   uchar result[];
   CPuback *cut = new CPuback();
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TestProtMethods: public CPuback
  {
public:
                     TestProtMethods() {};
                    ~TestProtMethods() {};
   bool              TEST_GetPacketID();
   bool              TEST_GetReasonCode();
   bool              TEST_IsPendingPkt_False();
   bool              TEST_IsPendingPkt_True();
   bool              TEST_ReadProperties_ReasonString();
   bool              TEST_ReadProperties_UserProperty();
   bool              TEST_ReadProperties_ReasonString_and_UserProperty();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_ReadProperties_ReasonString_and_UserProperty()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {4, 27, 0, 1, 24, 31, 0, 9, 'r', 'e', 'a', 's', 'o', 'n', 's', 't', 'r', \
                  38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'
                 };
   uint expected = 2;
   CPuback *cut = new CPuback();
   uint result = this.ReadProperties(pkt, 24, 5);
   bool isTrue = expected == result;
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_ReadProperties_UserProperty()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {4, 15, 0, 1, 12, 38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'};
   uint expected = 1;
   CPuback *cut = new CPuback();
   uint result = this.ReadProperties(pkt, 12, 5);
   bool isTrue = expected == result;
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_ReadProperties_ReasonString()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {4, 15, 0, 1, 12, 31, 0, 9, 'r', 'e', 'a', 's', 'o', 'n', 's', 't', 'r'};
   uint expected = 1;
   CPuback *cut = new CPuback();
   uint result = this.ReadProperties(pkt, 12, 5);
   bool isTrue = expected == result;
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_GetReasonCode()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {4, 2, 0, 1, 0};
   int expected = 0;
   CPuback *cut = new CPuback();
   int result = this.GetReasonCode(pkt, 4);
   bool isTrue = (result == expected);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_GetPacketID()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {4, 2, 0, 1};
   int expected = 1;
   CPuback *cut = new CPuback();
   int result = this.GetPacketid(pkt, 2);
   bool isTrue = (result == expected);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_IsPendingPkt_False()
  {
   Print(__FUNCTION__);
   uchar pkt_id = 0;
   bool expected = false;
   CPuback *cut = new CPuback();
   bool result = this.IsPendingPkt(pkt_id);
   bool isTrue = expected && result;
   delete cut;
   return !isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_IsPendingPkt_True()
  {
   Print(__FUNCTION__);
   ushort pkt_id = 65535;
   bool expected = true;
   CPuback *cut = new CPuback();
   bool result = this.IsPendingPkt(pkt_id);
   bool isTrue = expected && result;
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
