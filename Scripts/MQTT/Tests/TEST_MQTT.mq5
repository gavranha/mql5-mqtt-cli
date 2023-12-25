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
   Print(TEST_EncodeUTF8String_Disalowed_CodePoint());
//Print(TEST_EncodeUTF8String_EmptyString());
//Print(TEST_EncodeUTF8String_ASCII());
//Print(TEST_EncodeUTF8String_OneChar());
//Print(TEST_DecodeVariableByteInteger());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeUTF8String_Disalowed_CodePoint()
  {
   Print(__FUNCTION__);
// arrange
   uint expected[] = {};
   uint result[] = {};
   ArrayResize(result, expected.Size());
   uchar char_array_with_null[] = {'a', 0x00, 'b'}; //{a, NULL, b}
//char_array_with_null[0] = 'a';
//char_array_with_null[1] = B'00000000';
//char_array_with_null[2] = 'b';
   string string_with_disallowed_code_point = CharArrayToString(char_array_with_null);
// act
   EncodeUTF8String(string_with_disallowed_code_point, result);
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
