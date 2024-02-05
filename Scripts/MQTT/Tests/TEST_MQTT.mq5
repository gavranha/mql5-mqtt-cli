//+------------------------------------------------------------------+
//|                                                    TEST_MQTT.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13998 **** |
//+------------------------------------------------------------------+
#include <MQTT\MQTT.mqh>
#include "TestUtil.mqh"

//+------------------------------------------------------------------+
//| Tests for MQTT.mqh header                                        |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_EncodeFourByteInteger_OneByte());
   Print(TEST_EncodeFourByteInteger_TwoBytes());
   Print(TEST_EncodeFourByteInteger_ThreeBytes());
   Print(TEST_EncodeFourByteInteger_FourBytes());
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
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
Four Byte Integer data values are 32-bit unsigned integers in big-endian order: the high order byte
precedes the successively lower order bytes. This means that a 32-bit word is presented on the network
as Most Significant Byte (MSB), followed by the next most Significant Byte (MSB), followed by the next
most Significant Byte (MSB), followed by Least Significant Byte (LSB).
*/
bool TEST_EncodeFourByteInteger_FourBytes()
  {
   uchar expected[] = {1, 0, 0, 0};
   uchar result[];
   EncodeFourByteInteger(16777216, result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeFourByteInteger_ThreeBytes()
  {
   uchar expected[] = {0, 1, 0, 0};
   uchar result[];
   EncodeFourByteInteger(65536, result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeFourByteInteger_TwoBytes()
  {
   uchar expected[] = {0, 0, 1, 0};
   uchar result[];
   EncodeFourByteInteger(256, result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeFourByteInteger_OneByte()
  {
   uchar expected[] = {0, 0, 0, 1};
   uchar result[];
   EncodeFourByteInteger(1, result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_TopicName5Char()
  {
   Print(__FUNCTION__);
   uint expected[] = {48, 9, 0, 1, 'a', 'b', 'c', 'd', 'e', 0, 1};
   uint result[];
   uint buf[] = {};
   ArrayResize(buf, 9);
   buf[0] = 48;
   buf[1] = 9;
   buf[2] = 0;
   buf[3] = 1;
   buf[4] = 'a';
   buf[5] = 'b';
   buf[6] = 'c';
   buf[7] = 'd';
   buf[8] = 'e';
   SetPacketID(buf, 9);
   ArrayCopy(result, buf);
   bool is_true = AssertEqual(expected, result);
   if(!is_true)
     {
      printf("%s - did you set TEST to true in MQTT.mqh?", __FUNCTION__);
     }
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_TopicName1Char()
  {
   Print(__FUNCTION__);
   uint expected[] = {48, 5, 0, 1, 'a', 0, 1};
   uint result[];
   uint buf[] = {};
   ArrayResize(buf, 5);
   buf[0] = 48;
   buf[1] = 5;
   buf[2] = 0;
   buf[3] = 1;
   buf[4] = 'a';
   SetPacketID(buf, 5);
   ArrayCopy(result, buf);
   bool is_true = AssertEqual(expected, result);
   if(!is_true)
     {
      printf("%s - did you set TEST to true in MQTT.mqh?", __FUNCTION__);
     }
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_2_RETAIN_DUP()
  {
   Print(__FUNCTION__);
   uchar expected = 0x02;
   uchar buf[] = {61, 3, 0, 1, 'a'};
   uchar result = GetQoSLevel(buf);
   bool is_true = result == expected ? true : false;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_2_RETAIN()
  {
   Print(__FUNCTION__);
   uchar expected = 0x02;
   uchar buf[] = {53, 3, 0, 1, 'a'};
   uchar result = GetQoSLevel(buf);
   bool is_true = result == expected ? true : false;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                   TEST_GetQoSLevel_2                             |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_2()
  {
   Print(__FUNCTION__);
   uchar expected = 0x02;
   uchar buf[] = {52, 3, 0, 1, 'a'};
   uchar result = GetQoSLevel(buf);
   bool is_true = result == expected ? true : false;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_1_RETAIN_DUP()
  {
   Print(__FUNCTION__);
   uchar expected = 0x01;
   uchar buf[] = {59, 3, 0, 1, 'a'};
   uchar result = GetQoSLevel(buf);
   bool is_true = result == expected ? true : false;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_1_RETAIN()
  {
   Print(__FUNCTION__);
   uchar expected = 0x01;
   uchar buf[] = {51, 3, 0, 1, 'a'};
   uchar result = GetQoSLevel(buf);
   bool is_true = result == expected ? true : false;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_1()
  {
   Print(__FUNCTION__);
   uchar expected = 0x01;
   uchar buf[] = {50, 3, 0, 1, 'a'};// No DUP, no RETAIN
   uchar result = GetQoSLevel(buf);
   bool is_true = result == expected ? true : false;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_0_RETAIN()
  {
   Print(__FUNCTION__);
   uchar expected = 0x00;
   uchar buf[] = {49, 3, 0, 1, 'a'}; // // The DUP flag MUST be set to 0 for all QoS 0 messages
   uchar result = GetQoSLevel(buf);
   bool is_true = result == expected ? true : false;
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
   uchar expected = 0x00;
   uchar buf[] = {48, 3, 0, 1, 'a'};// No RETAIN
   uchar result = GetQoSLevel(buf);
   bool is_true = result == expected ? true : false;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeUTF8String_Disallowed_CodePoint_0x01_Ret_Empty_Array()
  {
   Print(__FUNCTION__);
   ushort expected[] = {};
   ushort result[] = {};
   ArrayResize(result, expected.Size());
   uchar char_array_with_0x01[3] = {'a', 0x01, 'b'}; //{a, NULL, b}
   string bad_string = CharArrayToString(char_array_with_0x01);
   EncodeUTF8String(bad_string, result);
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
   ushort expected[] = {};
   ushort result[] = {};
   ArrayResize(result, expected.Size());
   EncodeUTF8String("", result);
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
   ushort expected[] = {0, 6, 'a', 'b', 'c', '1', '2', '3'};
   ushort result[] = {};
   ArrayResize(result, expected.Size());
   EncodeUTF8String("abc123", result);
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
   ushort expected[] = {0, 1, 'a'};
   ushort result[] = {};
   ArrayResize(result, expected.Size());
   EncodeUTF8String("a", result);
   bool is_true = AssertEqual(expected, result);
   ArrayPrint(result);
   ZeroMemory(result);
   return is_true;
  };

//+------------------------------------------------------------------+
