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
   Print(TEST_EncodeUTF8String_Disallowed_CodePoint_0x01_Ret_Empty_Array());
   Print(TEST_EncodeUTF8String_EmptyString());
   Print(TEST_EncodeUTF8String_ASCII());
   Print(TEST_EncodeUTF8String_OneChar());
   Print(TEST_DecodeVariableByteInteger());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeUTF8String_Disallowed_CodePoint_0x01_Ret_Empty_Array()
  {
   Print(__FUNCTION__);
// arrange
   uint expected[] = {};
   uint result[] = {};
   ArrayResize(result, expected.Size());
   uchar charArrayWith_0x01[3] = {'a', 0x01, 'b'}; //{a, NULL, b}
   string badString = CharArrayToString(charArrayWith_0x01);
// act
   EncodeUTF8String(badString, result);
// assert
   bool isTrue = AssertEqual(expected, result);
   ArrayPrint(result);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeUTF8String_EmptyString()
  {
   Print(__FUNCTION__);
// arrange
   uint expected[] = {};
   uint result[] = {};
   ArrayResize(result, expected.Size());
// act
   EncodeUTF8String("", result);
// assert
   bool isTrue = AssertEqual(expected, result);
   ArrayPrint(result);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeUTF8String_ASCII()
  {
   Print(__FUNCTION__);
// arrange
   uint expected[] = {0, 6, 'a', 'b', 'c', '1', '2', '3'};
   uint result[] = {};
   ArrayResize(result, expected.Size());
// act
   EncodeUTF8String("abc123", result);
// assert
   bool isTrue = AssertEqual(expected, result);
   ArrayPrint(result);
   ZeroMemory(result);
   return isTrue;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeUTF8String_OneChar()
  {
   Print(__FUNCTION__);
// arrange
   uint expected[] = {0, 1, 'a'};
   uint result[] = {};
   ArrayResize(result, expected.Size());
// act
   EncodeUTF8String("a", result);
// assert
   bool isTrue = AssertEqual(expected, result);
   ArrayPrint(result);
   ZeroMemory(result);
   return isTrue;
  };
//+------------------------------------------------------------------+
//|                                                                  |
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
bool AssertEqual(uint & expected[], uint & result[])
  {
   if(!ArrayCompare(expected, result) == 0)
     {
      for(uint i = 0; i < expected.Size(); i++)
        {
         printf("expected\t%d\t\t%d result", expected[i], result[i]);
        }
      printf("expected size %d <=> %d result size", expected.Size(), result.Size());
      return false;
     }
   return true;
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
