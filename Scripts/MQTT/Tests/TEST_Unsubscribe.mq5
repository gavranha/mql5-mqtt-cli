//+------------------------------------------------------------------+
//|                                             TEST_Unsubscribe.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include "TestUtil.mqh"
#include <MQTT\MQTT.mqh>
#include <MQTT\Unsubscribe.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_Build_PacketID_NoProps());
   Print(TEST_SetPayload());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPayload()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 3, 'a', '/', 'b'};
   uchar result[];
   string topic = "a/b";
   CUnsubscribe *cut = new CUnsubscribe();
   cut.SetPayload(topic, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Build_PacketID_NoProps() // Failing test
  {
   Print(__FUNCTION__);
   uchar expected[] = {162, 4, 0, 1, 0, 0}; // TODO check this last byte (0)
   uchar result[];
   CUnsubscribe *cut = new CUnsubscribe();
   cut.Build(result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
