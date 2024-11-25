//+------------------------------------------------------------------+
//|                                                 TEST_Pingreq.mq5 |
//+------------------------------------------------------------------+
#include <MQTT\Pingresp.mqh>
#include "TestUtil.mqh"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_IsPingresp_NO());
   Print(TEST_IsPingresp_YES());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsPingresp_YES()
  {
   Print(__FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {208};
   bool result = CPingresp().IsPingresp(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsPingresp_NO()
  {
   Print(__FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   bool result = CPingresp().IsPingresp(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
