//+------------------------------------------------------------------+
//|                                                    TEST_MQTT.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13651 **** |
//+------------------------------------------------------------------+
#include <MQTT\MQTT.mqh>

//+------------------------------------------------------------------+
//| Tests for MQTT.mqh header                                        |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_DecodeVariableByteInteger());
  }
//+------------------------------------------------------------------+
bool TEST_DecodeVariableByteInteger()
  {
   Print(__FUNCTION__);
   uint buf[] = {1, 127, 0, 0, 0};
   uint expected = 127;
   uint result = DecodeVariableByteInteger(buf, 1);
   ZeroMemory(buf);
   return AssertEqual(expected, result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AssertEqual(uint expected, uint result)
  {
   if(expected != result)
     {
      printf("expected\t%d\t\t%d result", expected, result);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
