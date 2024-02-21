//+------------------------------------------------------------------+
//|                                                 TEST_CPuback.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13998 **** |
//+------------------------------------------------------------------+
#include <MQTT\CPktPuback.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//|               Tests for CPuback class                            |
//+------------------------------------------------------------------+
void OnStart()
  {

  }
//+------------------------------------------------------------------+
//|                          payload                                 |
//+------------------------------------------------------------------+
bool TEST_SetPayload()
  {
   Print(__FUNCTION__);
   static uchar expected[] =
     {50, 19, 0, 1, 'a', 0, 1, 2, 1, 1, 0, 0, 0, 7, 'p', 'a', 'y', 'l', 'o', 'a', 'd'}; // QoS1 for pkt ID generation
   uchar result[];
   CPktPublish *cut = new CPktPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetPayloadFormatIndicator(UTF8);
   cut.SetPayload("payload");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
