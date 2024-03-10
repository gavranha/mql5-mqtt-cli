//+------------------------------------------------------------------+
//|                                                TEST_CConnack.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <MQTT\Conack.mqh>
#include <MQTT\MQTT.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_IsConnack_NO());
   Print(TEST_IsConnack_YES());
   Print(TEST_IsSessionPresent_NO());
   Print(TEST_IsSessionPresent_YES());
   Print(TEST_ReadReasonCode_SUCCESS());
   Print(TEST_ReadReasonCode_ERROR());
   Print(TEST_ReadPropertyLength_OneByte());
   Print(TEST_ReadPropertyLength_TwoBytes());
   Print(TEST_ReadPropertyLength_ThreeBytes());
   Print(TEST_ReadPropertyLength_FourBytes());
   Print(TEST_ReadReasonString());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadReasonString()
  {
   Print(__FUNCTION__);
   string expected = "reasstr";
   uchar inpkt[] = {32, 13, 1, 0, 10, 31, 0, 7, 'r', 'e', 'a', 's', 's', 't', 'r'};
   CConack *cut = new CConack(inpkt);
   string result = cut.ReadReasonString(inpkt, 8, 7);
   bool isTrue = (StringCompare(expected, result) == 0);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadPropertyLength_FourBytes()
  {
   Print(__FUNCTION__);
   uint expected = 268435455;
   uchar inpkt[] = {32, 6, 1, 0, 0xFF, 0xFF, 0xFF, 0x7F};
   CConack *cut = new CConack(inpkt);
   uint result = cut.ReadPropertyLength(inpkt);
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadPropertyLength_ThreeBytes()
  {
   Print(__FUNCTION__);
   uint expected = 2097151;
   uchar inpkt[] = {32, 5, 1, 0, 0xFF, 0xFF, 0x7F};
   CConack *cut = new CConack(inpkt);
   uint result = cut.ReadPropertyLength(inpkt);
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadPropertyLength_TwoBytes()
  {
   Print(__FUNCTION__);
   uint expected = 16383;
   uchar inpkt[] = {32, 4, 1, 0, 0xFF, 0x7F};
   CConack *cut = new CConack(inpkt);
   uint result = cut.ReadPropertyLength(inpkt);
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadPropertyLength_OneByte()
  {
   Print(__FUNCTION__);
   uint expected = 127;
   uchar inpkt[] = {32, 3, 1, 0, 127};
   CConack *cut = new CConack(inpkt);
   uint result = cut.ReadPropertyLength(inpkt);
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadReasonCode_ERROR()
  {
   Print(__FUNCTION__);
   uchar expected = MQTT_REASON_CODE_UNSPECIFIED_ERROR;
   uchar inpkt[] = {32, 2, 1, 0x80};
   CConack *cut = new CConack(inpkt);
   uchar result = cut.ReadReasonCode(inpkt);
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadReasonCode_SUCCESS()
  {
   Print(__FUNCTION__);
   uchar expected = MQTT_REASON_CODE_SUCCESS;
   uchar inpkt[] = {32, 2, 1, 0x00};
   CConack *cut = new CConack(inpkt);
   uchar result = cut.ReadReasonCode(inpkt);
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsSessionPresent_YES()
  {
   Print(__FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {32, 1, 1};
   CConack *cut = new CConack(inpkt);
   bool result = cut.IsSessionPresent(inpkt);
   bool isTrue = expected == result;
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsSessionPresent_NO()
  {
   Print(__FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {32, 1, 0};
   CConack *cut = new CConack(inpkt);
   bool result = cut.IsSessionPresent(inpkt);
   bool isFalse = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isFalse;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsConnack_YES()
  {
   Print(__FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {32, 0};
   CConack *cut = new CConack(inpkt);
   bool result = cut.IsConnack(inpkt);
   bool isTrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsConnack_NO()
  {
   Print(__FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   CConack *cut = new CConack(inpkt);
   bool result = cut.IsConnack(inpkt);
   bool isFalse = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isFalse;
  }
//+------------------------------------------------------------------+
