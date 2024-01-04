//+------------------------------------------------------------------+
//|                                                    TEST_MQTT.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13998 **** |
//+------------------------------------------------------------------+
#include <MQTT\MQTT.mqh>

//+------------------------------------------------------------------+
//| Tests for MQTT.mqh header                                        |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_SetPacketID_TopicName1Char());
   Print(TEST_SetPacketID_TopicName5Char());
   Print(TEST_GetQoSLevel_2_RETAIN_DUP());
   Print(TEST_GetQoSLevel_2_RETAIN());
   Print(TEST_GetQoSLevel_2());
   Print(TEST_GetQoSLevel_1_RETAIN_DUP());
   Print(TEST_GetQoSLevel_1_RETAIN());
   Print(TEST_GetQoSLevel_1());
   Print(TEST_GetQoSLevel_0_RETAIN());
   Print(TEST_GetQoSLevel_0());
   Print(TEST_EncodeUTF8String_Disallowed_CodePoint_0x01_Ret_Empty_Array());
   Print(TEST_EncodeUTF8String_EmptyString());
   Print(TEST_EncodeUTF8String_ASCII());
   Print(TEST_EncodeUTF8String_OneChar());
   Print(TEST_DecodeVariableByteInteger());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_TopicName5Char()
  {
   Print(__FUNCTION__);
// arrange
//ushort buf[] = {50, 7, 0, 1, 'a', 'b', 'c', 'd', 'e'}; // fixed array cannot be resized
   uint buf[] = {};
   ArrayResize(buf, 9);
   buf[0] = 50;
   buf[1] = 7;
   buf[2] = 0;
   buf[3] = 1;
   buf[4] = 'a';
   buf[5] = 'b';
   buf[6] = 'c';
   buf[7] = 'd';
   buf[8] = 'e';
// act
   SetPacketID(buf, 9);
// assert
   bool is_true = buf[9] > 0 || buf[10] > 0;
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_TopicName1Char()
  {
   Print(__FUNCTION__);
// arrange
//ushort buf[] = {50, 3, 0, 1, 'a'};
   uint buf[] = {};
   ArrayResize(buf, 5);
   buf[0] = 50;
   buf[1] = 3;
   buf[2] = 0;
   buf[3] = 1;
   buf[4] = 'a';
// act
   SetPacketID(buf, 5);
// assert
   bool is_true = buf[5] > 0 || buf[6] > 0;
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_2_RETAIN_DUP()
  {
   Print(__FUNCTION__);
//-- arrange
   uchar expected = 0x02;
   uchar buf[] = {61, 3, 0, 1, 'a'};
//-- act
   uchar result = GetQoSLevel(buf);
//-- assert
   bool is_true = AssertEqual(expected, result);
//-- cleanup
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_2_RETAIN()
  {
   Print(__FUNCTION__);
//-- arrange
   uchar expected = 0x02;
   uchar buf[] = {53, 3, 0, 1, 'a'};
//-- act
   uchar result = GetQoSLevel(buf);
//-- assert
   bool is_true = AssertEqual(expected, result);
//-- cleanup
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                   TEST_GetQoSLevel_2                             |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_2()
  {
   Print(__FUNCTION__);
//-- arrange
   uchar expected = 0x02;
   uchar buf[] = {52, 3, 0, 1, 'a'};
//-- act
   uchar result = GetQoSLevel(buf);
//-- assert
   bool is_true = AssertEqual(expected, result);
//-- cleanup
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_1_RETAIN_DUP()
  {
   Print(__FUNCTION__);
//-- arrange
   uchar expected = 0x01;
   uchar buf[] = {59, 3, 0, 1, 'a'};
//-- act
   uchar result = GetQoSLevel(buf);
//-- assert
   bool is_true = AssertEqual(expected, result);
//-- cleanup
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_1_RETAIN()
  {
   Print(__FUNCTION__);
//-- arrange
   uchar expected = 0x01;
   uchar buf[] = {51, 3, 0, 1, 'a'};
//-- act
   uchar result = GetQoSLevel(buf);
//-- assert
   bool is_true = AssertEqual(expected, result);
//-- cleanup
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_1()
  {
   Print(__FUNCTION__);
//-- arrange
   uchar expected = 0x01;
   uchar buf[] = {50, 3, 0, 1, 'a'};// No DUP, no RETAIN
//-- act
   uchar result = GetQoSLevel(buf);
//-- assert
   bool is_true = AssertEqual(expected, result);
//-- cleanup
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_0_RETAIN()
  {
   Print(__FUNCTION__);
//-- arrange
   uchar expected = 0x00;
   uchar buf[] = {49, 3, 0, 1, 'a'}; // // The DUP flag MUST be set to 0 for all QoS 0 messages
//-- act
   uchar result = GetQoSLevel(buf);
//-- assert
   bool is_true = AssertEqual(expected, result);
//-- cleanup
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                 TEST_GetQoSLevel_0                               |
//+------------------------------------------------------------------+
// The DUP flag MUST be set to 0 for all QoS 0 messages
bool TEST_GetQoSLevel_0()
  {
   Print(__FUNCTION__);
//-- arrange
   uchar expected = 0x00;
   uchar buf[] = {48, 3, 0, 1, 'a'};// No RETAIN
//-- act
   uchar result = GetQoSLevel(buf);
//-- assert
   bool is_true = AssertEqual(expected, result);
//-- cleanup
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeUTF8String_Disallowed_CodePoint_0x01_Ret_Empty_Array()
  {
   Print(__FUNCTION__);
// arrange
   ushort expected[] = {};
   ushort result[] = {};
   ArrayResize(result, expected.Size());
   uchar char_array_with_0x01[3] = {'a', 0x01, 'b'}; //{a, NULL, b}
   string bad_string = CharArrayToString(char_array_with_0x01);
// act
   EncodeUTF8String(bad_string, result);
// assert
   bool is_true = AssertEqual(expected, result);
   ArrayPrint(result);
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeUTF8String_EmptyString()
  {
   Print(__FUNCTION__);
// arrange
   ushort expected[] = {};
   ushort result[] = {};
   ArrayResize(result, expected.Size());
// act
   EncodeUTF8String("", result);
// assert
   bool is_true = AssertEqual(expected, result);
   ArrayPrint(result);
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeUTF8String_ASCII()
  {
   Print(__FUNCTION__);
// arrange
   ushort expected[] = {0, 6, 'a', 'b', 'c', '1', '2', '3'};
   ushort result[] = {};
   ArrayResize(result, expected.Size());
// act
   EncodeUTF8String("abc123", result);
// assert
   bool is_true = AssertEqual(expected, result);
   ArrayPrint(result);
   ZeroMemory(result);
   return is_true;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeUTF8String_OneChar()
  {
   Print(__FUNCTION__);
// arrange
   ushort expected[] = {0, 1, 'a'};
   ushort result[] = {};
   ArrayResize(result, expected.Size());
// act
   EncodeUTF8String("a", result);
// assert
   bool is_true = AssertEqual(expected, result);
   ArrayPrint(result);
   ZeroMemory(result);
   return is_true;
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
bool AssertEqual(ushort & expected[], ushort & result[])
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
bool AssertEqual(uchar expected, uchar result)
  {
   if(expected != result)
     {
      printf("expected\t%d\t\t%d result", expected, result);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AssertEqual(ushort expected, ushort result)
  {
   if(expected != result)
     {
      printf("expected\t%d\t\t%d result", expected, result);
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
