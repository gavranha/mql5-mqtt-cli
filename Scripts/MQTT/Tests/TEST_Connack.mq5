//+------------------------------------------------------------------+
//|                                                 TEST_Connack.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <MQTT\Connack.mqh>
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
   Print(TEST_ReadSessionExpiryInterval());
   Print(TEST_ReadReceiveMaximum());
   Print(TEST_ReadMaximumQoS_0());
   Print(TEST_ReadMaximumQoS_1());
   Print(TEST_ReadRetainAvailable_NO());
   Print(TEST_ReadRetainAvailable_YES());
   Print(TEST_ReadMaximumPacketSize());
   Print(TEST_ReadAssignedClientIdentifier());
   Print(TEST_ReadTopicAliasMaximum());
   Print(TEST_ReadReasonString());
   Print(TEST_ReadWildcardSubscriptionAvailable_NO());
   Print(TEST_ReadWildcardSubscriptionAvailable_YES());
   Print(TEST_ReadSubscriptionIdentifiersAvailable_NO());
   Print(TEST_ReadSubscriptionIdentifiersAvailable_YES());
   Print(TEST_ReadSharedSubscriptionAvailable_NO());
   Print(TEST_ReadSharedSubscriptionAvailable_YES());
   Print(TEST_ReadServerKeepAlive());
   Print(TEST_ReadResponseInformation());
   Print(TEST_ReadServerReference());
   Print(TEST_ReadAuthenticationMethod());
   Print(TEST_ReadAuthenticationData());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadAuthenticationData()
  {
   Print( __FUNCTION__);
   string expected = "authdata";
   uchar inpkt[] = {32, 14, 1, 0, 10, 22, 0, 8, 'a', 'u', 't', 'h', 'd', 'a', 't', 'a'};
   CConnack *cut = new CConnack(inpkt);
   string result = cut.ReadAuthenticationData(inpkt, 6);
   bool isTrue = (StringCompare(expected, result) == 0);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadAuthenticationMethod()
  {
   Print( __FUNCTION__);
   string expected = "authmeth";
   uchar inpkt[] = {32, 14, 1, 0, 10, 21, 0, 8, 'a', 'u', 't', 'h', 'm', 'e', 't', 'h'};
   CConnack *cut = new CConnack(inpkt);
   string result = cut.ReadAuthenticationMethod(inpkt, 6);
   bool isTrue = (StringCompare(expected, result) == 0);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadServerReference()
  {
   Print( __FUNCTION__);
   string expected = "srvref";
   uchar inpkt[] = {32, 12, 1, 0, 10, 28, 0, 6, 's', 'r', 'v', 'r', 'e', 'f'};
   CConnack *cut = new CConnack(inpkt);
   string result = cut.ReadServerReference(inpkt, 6);
   bool isTrue = (StringCompare(expected, result) == 0);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadResponseInformation()
  {
   Print( __FUNCTION__);
   string expected = "rspinfo";
   uchar inpkt[] = {32, 13, 1, 0, 10, 26, 0, 7, 'r', 's', 'p', 'i', 'n', 'f', 'o'};
   CConnack *cut = new CConnack(inpkt);
   string result = cut.ReadResponseInformation(inpkt, 6);
   bool isTrue = (StringCompare(expected, result) == 0);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadServerKeepAlive()
  {
   Print( __FUNCTION__);
   ushort expected = 3600;
   uchar inpkt[] = {32, 6, 1, 0, 2, 19, 14, 16};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadServerKeepAlive(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadSharedSubscriptionAvailable_YES()
  {
   Print( __FUNCTION__);
   ushort expected = 1;
   uchar inpkt[] = {32, 5, 1, 0, 2, 42, 1};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadSharedSubscriptionAvailable(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadSharedSubscriptionAvailable_NO()
  {
   Print( __FUNCTION__);
   ushort expected = 0;
   uchar inpkt[] = {32, 5, 1, 0, 2, 42, 0};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadSharedSubscriptionAvailable(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadSubscriptionIdentifiersAvailable_YES()
  {
   Print( __FUNCTION__);
   ushort expected = 1;
   uchar inpkt[] = {32, 5, 1, 0, 2, 41, 1};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadSubscriptionIdentifierAvailable(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadSubscriptionIdentifiersAvailable_NO()
  {
   Print( __FUNCTION__);
   ushort expected = 0;
   uchar inpkt[] = {32, 5, 1, 0, 2, 41, 0};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadSubscriptionIdentifierAvailable(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadWildcardSubscriptionAvailable_YES()
  {
   Print( __FUNCTION__);
   ushort expected = 1;
   uchar inpkt[] = {32, 5, 1, 0, 2, 40, 1};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadWildcardSubscriptionAvailable(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadWildcardSubscriptionAvailable_NO()
  {
   Print( __FUNCTION__);
   ushort expected = 0;
   uchar inpkt[] = {32, 5, 1, 0, 2, 40, 0};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadWildcardSubscriptionAvailable(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadReasonString()
  {
   Print( __FUNCTION__);
   string expected = "reasstr";
   uchar inpkt[] = {32, 13, 1, 0, 10, 31, 0, 7, 'r', 'e', 'a', 's', 's', 't', 'r'};
   CConnack *cut = new CConnack(inpkt);
   string result = cut.ReadReasonString(inpkt, 6);
   bool isTrue = (StringCompare(expected, result) == 0);
   ZeroMemory(result);
   delete(cut);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadTopicAliasMaximum()
  {
   Print( __FUNCTION__);
   ushort expected = 256;
   uchar inpkt[] = {32, 13, 1, 0, 9, 34, 1, 0};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadTopicAliasMaximum(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadAssignedClientIdentifier()
  {
   Print( __FUNCTION__);
   string expected = "asscli";
   uchar inpkt[] = {32, 13, 1, 0, 9, 18, 0, 6, 'a', 's', 's', 'c', 'l', 'i'};
   CConnack *cut = new CConnack(inpkt);
   string result = cut.ReadAssignedClientIdentifier(inpkt, 6);
   bool istrue = (StringCompare(expected, result) == 0);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadMaximumPacketSize()
  {
   Print( __FUNCTION__);
   ushort expected = 1024;
   uchar inpkt[] = {32, 8, 1, 0, 5, 39, 0, 0, 4, 0};
   CConnack *cut = new CConnack(inpkt);
   ushort result = (ushort)cut.ReadMaximumPacketSize(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadRetainAvailable_YES()
  {
   Print( __FUNCTION__);
   ushort expected = 1;
   uchar inpkt[] = {32, 5, 1, 0, 2, 37, 1};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadRetainAvailable(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadRetainAvailable_NO()
  {
   Print( __FUNCTION__);
   ushort expected = 0;
   uchar inpkt[] = {32, 5, 1, 0, 2, 37, 0};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadRetainAvailable(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadMaximumQoS_1()
  {
   Print( __FUNCTION__);
   ushort expected = 1;
   uchar inpkt[] = {32, 5, 1, 0, 2, 36, 1};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadMaximumQoS(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadMaximumQoS_0()
  {
   Print( __FUNCTION__);
   ushort expected = 0;
   uchar inpkt[] = {32, 5, 1, 0, 2, 36, 0};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadMaximumQoS(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadReceiveMaximum()
  {
   Print( __FUNCTION__);
   ushort expected = 3600;
   uchar inpkt[] = {32, 6, 1, 0, 3, 33, 14, 16};
   CConnack *cut = new CConnack(inpkt);
   ushort result = cut.ReadReceiveMaximum(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadSessionExpiryInterval()
  {
   Print( __FUNCTION__);
   uint expected = 3600;
   uchar inpkt[] = {32, 8, 1, 0, 5, 17, 0, 0, 14, 16};
   CConnack *cut = new CConnack(inpkt);
   uint result = cut.ReadSessionExpiryInterval(inpkt, 6);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadPropertyLength_FourBytes()
  {
   Print( __FUNCTION__);
   uint expected = 268435455;
   uchar inpkt[] = {32, 6, 1, 0, 0xFF, 0xFF, 0xFF, 0x7F};
   CConnack *cut = new CConnack(inpkt);
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
   Print( __FUNCTION__);
   uint expected = 2097151;
   uchar inpkt[] = {32, 5, 1, 0, 0xFF, 0xFF, 0x7F};
   CConnack *cut = new CConnack(inpkt);
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
   Print( __FUNCTION__);
   uint expected = 16383;
   uchar inpkt[] = {32, 4, 1, 0, 0xFF, 0x7F};
   CConnack *cut = new CConnack(inpkt);
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
   Print( __FUNCTION__);
   uint expected = 127;
   uchar inpkt[] = {32, 3, 1, 0, 127};
   CConnack *cut = new CConnack(inpkt);
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
   Print( __FUNCTION__);
   uchar expected = MQTT_REASON_CODE_UNSPECIFIED_ERROR;
   uchar inpkt[] = {32, 2, 1, 0x80};
   CConnack *cut = new CConnack(inpkt);
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
   Print( __FUNCTION__);
   uchar expected = MQTT_REASON_CODE_SUCCESS;
   uchar inpkt[] = {32, 2, 1, 0x00};
   CConnack *cut = new CConnack(inpkt);
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
   Print( __FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {32, 1, 1};
   CConnack *cut = new CConnack(inpkt);
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
   Print( __FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {32, 1, 0};
   CConnack *cut = new CConnack(inpkt);
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
   Print( __FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {32, 0};
   CConnack *cut = new CConnack(inpkt);
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
   Print( __FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   CConnack *cut = new CConnack(inpkt);
   bool result = cut.IsConnack(inpkt);
   bool isFalse = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isFalse;
  }
//+------------------------------------------------------------------+
