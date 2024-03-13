//+------------------------------------------------------------------+
//|                                               TEST_Subscribe.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14391 **** |
//+------------------------------------------------------------------+
#include <MQTT\Subscribe.mqh>
#include "TestUtil.mqh"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Print(TEST_Build_PacketID_NoProps());
   Print(TEST_SetSubscriptionIdentifier_OneByte());
   Print(TEST_SetUserProperty());
   Print(TEST_SetTopicFilter());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetTopicFilter()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 3, 'a', '/', 'b'};
   CSubscribe *cut = new CSubscribe();
   uchar result[];
   cut.SetTopicFilter("a/b", result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetUserProperty()
  {
   Print(__FUNCTION__);
   uchar expected[] = {38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'};
   CSubscribe *cut = new CSubscribe();
   uchar result[];
   cut.SetUserProperty("key:", "val", result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetSubscriptionIdentifier_OneByte()
  {
   Print(__FUNCTION__);
   uchar expected[] = {11, 1};
   uchar result[];
   CSubscribe *cut = new CSubscribe();
   cut.SetSubscriptionIdentifier(result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Build_PacketID_NoProps()
  {
   Print(__FUNCTION__);
   uchar expected[] = {130, 3, 0, 1, 0, 0}; // TODO check this last byte (0)
   uchar result[];
   CSubscribe *cut = new CSubscribe();
   cut.Build(result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
