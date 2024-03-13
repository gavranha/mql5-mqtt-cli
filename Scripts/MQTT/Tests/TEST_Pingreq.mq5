//+------------------------------------------------------------------+
//|                                                 TEST_Pingreq.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <MQTT\Pingreq.mqh>
#include "TestUtil.mqh"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_Build());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Build()
  {
  Print(__FUNCTION__);
   uchar expected[] = {192, 0};
   uchar result[];
   CPingreq *cut = new CPingreq();
   cut.Build(result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
