//+------------------------------------------------------------------+
//|                                                 TEST_CPuback.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13998 **** |
//+------------------------------------------------------------------+
#include <MQTT\CPuback.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//|               Tests for CPuback class                            |
//+------------------------------------------------------------------+
void OnStart()
  {
  Print(TEST_Ctor());

  }
//+------------------------------------------------------------------+
//|                          payload                                 |
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
