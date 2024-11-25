//+------------------------------------------------------------------+
//|                                                    TEST_MQTT.mq5 |
//+------------------------------------------------------------------+
#include <MQTT\MQTT.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//| Tests for MQTT.mqh header                                        |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_EncodeTwoByteInteger_TwoBytes());
   Print(TEST_EncodeTwoByteInteger_OneByte());
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
   Print(TEST_EncodeVariableByteInteger_OneDigit());
   Print(TEST_EncodeVariableByteInteger_TwoDigits());
   Print(TEST_EncodeVariableByteInteger_ThreeDigits());
   Print(TEST_EncodeVariableByteInteger_FourDigits());
   Print(TEST_DecodeVariableByteInteger_OneByte());
   Print(TEST_DecodeVariableByteInteger_TwoBytes());
   Print(TEST_DecodeVariableByteInteger_ThreeBytes());
   Print(TEST_DecodeVariableByteInteger_FourBytes());
   Print(TEST_ReadUtf8String());
   Print(TEST_DecodeFourByteInt_OneByte());
   Print(TEST_DecodeFourByteInt_TwoBytes());
   Print(TEST_DecodeFourByteInt_ThreeBytes());
   Print(TEST_DecodeFourByteInt_FourBytes());
   Print(TEST_DecodeTwoByteInt_OneByte());
   Print(TEST_DecodeTwoByteInt_TwoBytes());
   Print(TEST_ReadUserProperty());
   Print(TEST_ReadRemainingLength_INVALID());
   Print(TEST_ReadRemainingLength_ZERO());
   Print(TEST_ReadRemainingLength_OneByte());
   Print(TEST_ReadRemainingLength_TwoBytes());
   Print(TEST_ReadRemainingLength_ThreeBytes());
   Print(TEST_ReadRemainingLength_FourBytes());
   Print(TEST_ReadPropertyLength_ZERO());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadPropertyLength_ZERO()
  {
   Print(__FUNCTION__);
   uchar pkt[] = {4, 4, 0, 1, 0, 0};
   uint expected = 0;
   uint result = ReadPropertyLength(pkt, 4);
   bool istrue = (result == expected);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//  Digits  From                               To
//4       2,097,152 (0x80, 0x80, 0x80, 0x01) 268,435,455 (0xFF, 0xFF, 0xFF, 0x7F)
bool TEST_ReadRemainingLength_FourBytes()
  {
   Print(__FUNCTION__);
   uint expected = 268435455;
   uchar inpkt[] = {00000000, 0xFF, 0xFF, 0xFF, 0x7F};
   uint result = ReadRemainingLength(inpkt);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//  Digits  From                               To
//3       16,384 (0x80, 0x80, 0x01)          2,097,151 (0xFF, 0xFF, 0x7F)
bool TEST_ReadRemainingLength_ThreeBytes()
  {
   Print(__FUNCTION__);
   uint expected = 2097151;
   uchar inpkt[] = {00000000, 0xFF, 0xFF, 0x7F, 0};
   uint result = ReadRemainingLength(inpkt);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//Digits  From                               To
//2       128 (0x80, 0x01)                   16,383 (0xFF, 0x7F) => (255,127)
bool TEST_ReadRemainingLength_TwoBytes()
  {
   Print(__FUNCTION__);
   ushort expected = 16383;
   uchar inpkt[] = {00000000, 0xFF, 0x7F, 0, 0};
   uint result = ReadRemainingLength(inpkt);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//Digits  From                               To
//1       0 (0x00)                           127 (0x7F)
bool TEST_ReadRemainingLength_OneByte()// TODO failing test
  {
   Print(__FUNCTION__);
   uchar expected = 2;
   uchar inpkt[] = {00000000, 2, 0, 0, 0};
   uint result = ReadRemainingLength(inpkt);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadRemainingLength_ZERO()
  {
   Print(__FUNCTION__);
   uchar expected = 0;
   uchar inpkt[] = {00000000, 0, 0, 0, 0};
   uint result = ReadRemainingLength(inpkt);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadRemainingLength_INVALID()// TODO failing test
  {
   Print(__FUNCTION__);
   int expected = 0;
   uchar inpkt[] = {00000000, 0xFF, 0xFF, 0xFF, 0xFF}; // remaining length 4228250625
   uint result = ReadRemainingLength(inpkt);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadUserProperty()
  {
   Print(__FUNCTION__);
   string expected[] = {"key:", "val"};
   uchar inpkt[] = {32, 15, 1, 0, 10, 38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'};
   string result[];
   ReadUserProperty(inpkt, 6, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_DecodeTwoByteInt_TwoBytes()
  {
   Print(__FUNCTION__);
   uchar encoded[] = {1, 0 };
   uint expected = 256 ;
   uint result = DecodeTwoByteInt(encoded);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_DecodeTwoByteInt_OneByte()
  {
   Print(__FUNCTION__);
   uchar encoded[] = {0, 1};
   uint expected = 1;
   uint result = DecodeTwoByteInt(encoded);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_DecodeFourByteInt_FourBytes()
  {
   Print(__FUNCTION__);
   uchar encoded[] = {1, 0, 0, 0};
   uint expected = 16777216;
   uint result = DecodeFourByteInt(encoded);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_DecodeFourByteInt_ThreeBytes()
  {
   Print(__FUNCTION__);
   uchar encoded[] = {0, 1, 0, 0};
   uint expected = 65536;
   uint result = DecodeFourByteInt(encoded);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_DecodeFourByteInt_TwoBytes()
  {
   Print(__FUNCTION__);
   uchar encoded[] = {0, 0, 1, 0};
   uint expected = 256;
   uint result = DecodeFourByteInt(encoded);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_DecodeFourByteInt_OneByte()
  {
   Print(__FUNCTION__);
   uchar encoded[] = {0, 0, 0, 1};
   uint expected = 1;
   uint result = DecodeFourByteInt(encoded);
   bool istrue = expected == result;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadUtf8String()
  {
   Print(__FUNCTION__);
   uchar char_array_to_read[] = {0, 10, 'u', 't', 'f', '8', 's', 't', 'r', 'i', 'n', 'g'};
   string expected = "utf8string";
   string result = ReadUtf8String(char_array_to_read, 2, 10);
   Print(result);
   return StringCompare(expected, result) == 0;
  }
/*
The maximum number of bytes in the Variable Byte Integer field is four.
The encoded value MUST use the minimum number of bytes necessary to represent the value
Size of Variable Byte Integer
Digits  From                               To
1       0 (0x00)                           127 (0x7F)
2       128 (0x80, 0x01)                   16,383 (0xFF, 0x7F) => (255,127)
3       16,384 (0x80, 0x80, 0x01)          2,097,151 (0xFF, 0xFF, 0x7F)
4       2,097,152 (0x80, 0x80, 0x80, 0x01) 268,435,455 (0xFF, 0xFF, 0xFF, 0x7F)
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//4       2,097,152 (0x80, 0x80, 0x80, 0x01) 268,435,455 (0xFF, 0xFF, 0xFF, 0x7F)
bool TEST_DecodeVariableByteInteger_FourBytes()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0xFF, 0xFF, 0xFF, 0x7F};
   uint result = DecodeVariableByteInteger(expected, 0);
   bool istrue = (result == 268435455);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//3       16,384 (0x80, 0x80, 0x01)          2,097,151 (0xFF, 0xFF, 0x7F)
bool TEST_DecodeVariableByteInteger_ThreeBytes()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0xFF, 0xFF, 0x7F};
   uint result = DecodeVariableByteInteger(expected, 0);
   bool istrue = (result == 2097151);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//2       128 (0x80, 0x01)                   16,383 (0xFF, 0x7F) => (255,127)
bool TEST_DecodeVariableByteInteger_TwoBytes()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0xFF, 0x7F};
   uint result = DecodeVariableByteInteger(expected, 0);
   bool istrue = (result == 16383);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//  Digits  From                               To
//1       0 (0x00)                           127 (0x7F)
bool TEST_DecodeVariableByteInteger_OneByte()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0x7F};
   uint result = DecodeVariableByteInteger(expected, 0);
   bool istrue = (result == 127);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//  Digits  From                               To
//1       0 (0x00)                           127 (0x7F)
//2       128 (0x80, 0x01)                   16,383 (0xFF, 0x7F) => (255,127)
//3       16,384 (0x80, 0x80, 0x01)          2,097,151 (0xFF, 0xFF, 0x7F)
//4       2,097,152 (0x80, 0x80, 0x80, 0x01) 268,435,455 (0xFF, 0xFF, 0xFF, 0x7F)
bool TEST_EncodeVariableByteInteger_FourDigits()
  {
   Print(__FUNCTION__);
   uint result[];
   uint expected[] = {0xFF, 0xFF, 0xFF, 0x7F};
   uint to_encode = 268435455;
   EncodeVariableByteInteger(to_encode, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//  Digits  From                               To
//1       0 (0x00)                           127 (0x7F)
//2       128 (0x80, 0x01)                   16,383 (0xFF, 0x7F) => (255,127)
//3       16,384 (0x80, 0x80, 0x01)          2,097,151 (0xFF, 0xFF, 0x7F)
bool TEST_EncodeVariableByteInteger_ThreeDigits()
  {
   Print(__FUNCTION__);
   uint result[];
   uint expected[] = {0xFF, 0xFF, 0x7F};
   uint to_encode = 2097151;
   EncodeVariableByteInteger(to_encode, result);
   printf("to_encode %d ", to_encode);
   ArrayPrint(result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//Digits  From                               To
//1       0 (0x00)                           127 (0x7F)
//2       128 (0x80, 0x01)                   16,383 (0xFF, 0x7F) => (255,127)
bool TEST_EncodeVariableByteInteger_TwoDigits()
  {
   Print(__FUNCTION__);
   uint result[];
   uint expected[] = {0xFF, 0x7F};
   uint to_encode = 16383;
   EncodeVariableByteInteger(to_encode, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//Digits  From                               To
//1       0 (0x00)                           127 (0x7F)
bool TEST_EncodeVariableByteInteger_OneDigit()
  {
   Print(__FUNCTION__);
   uint result[];
   uint expected[] = {0x7F};
   uint to_encode = 127;
   EncodeVariableByteInteger(to_encode, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeTwoByteInteger_TwoBytes()
  {
   Print(__FUNCTION__);
   uchar expected[] = {1, 0};
   uchar result[];
   EncodeTwoByteInteger(256, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeTwoByteInteger_OneByte()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 1};
   uchar result[];
   EncodeTwoByteInteger(1, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeFourByteInteger_FourBytes()
  {
   Print(__FUNCTION__);
   uchar expected[] = {1, 0, 0, 0};
   uchar result[];
   EncodeFourByteInteger(16777216, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeFourByteInteger_ThreeBytes()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 1, 0, 0};
   uchar result[];
   EncodeFourByteInteger(65536, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeFourByteInteger_TwoBytes()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 0, 1, 0};
   uchar result[];
   EncodeFourByteInteger(256, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_EncodeFourByteInteger_OneByte()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 0, 0, 1};
   uchar result[];
   EncodeFourByteInteger(1, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_TopicName5Char()
  {
   Print(__FUNCTION__);
   uint expected[] = {48, 9, 0, 1, 'a', 'b', 'c', 'd', 'e', 0, 1};
   uint result[];
   uchar buf[] = {};
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
   SetPacketIdentifier(buf, 9);
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
   uchar buf[] = {};
   ArrayResize(buf, 5);
   buf[0] = 48;
   buf[1] = 5;
   buf[2] = 0;
   buf[3] = 1;
   buf[4] = 'a';
   SetPacketIdentifier(buf, 5);
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
   uchar expected[] = {};
   uchar result[] = {};
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
   uchar expected[] = {};
   uchar result[] = {};
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
   uchar expected[] = {0, 6, 'a', 'b', 'c', '1', '2', '3'};
   uchar result[] = {};
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
   uchar expected[] = {0, 1, 'a'};
   uchar result[] = {};
   ArrayResize(result, expected.Size());
   EncodeUTF8String("a", result);
   bool is_true = AssertEqual(expected, result);
   ArrayPrint(result);
   ZeroMemory(result);
   return is_true;
  };
//+------------------------------------------------------------------+
