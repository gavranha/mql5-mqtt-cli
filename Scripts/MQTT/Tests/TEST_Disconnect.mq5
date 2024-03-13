//+------------------------------------------------------------------+
//|                                             TEST_ Disconnect.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <MQTT\Disconnect.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Print(TEST_IsDisconnect_NO());
   Print(TEST_IsDisconnect_YES());
   Print(TEST_Build());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Build() // TODO ========>> START HERE  <<============
  {
   uchar expected[] = {};
   uchar result[];
   CDisconnect *cut = new CDisconnect();
   cut.Build(result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsDisconnect_YES()
  {
   Print(__FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {224};
   bool result = CDisconnect().IsDisconnect(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsDisconnect_NO()
  {
   Print(__FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   bool result = CDisconnect().IsDisconnect(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
