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
   Print(TEST_Ctor());
   Print(TEST_IsPendingPkt_True());
   Print(TEST_IsPendingPkt_False());
   Print(TEST_GetReasonCode());
   Print(TEST_GetPropertyLength());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetPropertyLength()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {0, 111, MQTT_REASON_CODE_SUCCESS, 0};
   uint expected = 0;
   CPuback *cut = new CPuback();
   uint result = cut.GetPropertyLength(pkt);
   bool isTrue = (result == expected);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetReasonCode()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {0, 111, MQTT_REASON_CODE_SUCCESS, 0};
   uchar expected = MQTT_REASON_CODE_SUCCESS;
   CPuback *cut = new CPuback();
   uchar result = cut.GetReasonCode(pkt);
   bool isTrue = (result == expected);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsPendingPkt_False()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {0, 111, MQTT_REASON_CODE_SUCCESS, 0};
   bool expected = false;
   CPuback *cut = new CPuback();
   bool result = cut.IsPendingPkt(pkt);
   bool isTrue = expected && result;
   delete cut;
   return !isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsPendingPkt_True()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {255, 255, MQTT_REASON_CODE_SUCCESS, 0};// packet ID 65535
   bool expected = true;
   CPuback *cut = new CPuback();
   bool result = cut.IsPendingPkt(pkt);
   bool isTrue = expected && result;
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
