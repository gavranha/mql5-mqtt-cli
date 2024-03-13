//+------------------------------------------------------------------+
//|                                             TEST_ Disconnect.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14391 **** |
//+------------------------------------------------------------------+
#include <MQTT\Disconnect.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Print(TEST_IsDisconnect_NO());
   Print(TEST_IsDisconnect_YES());
   Print(TEST_Build());
   Print(TEST_ReadDisconnReasonCode());
   Print(TEST_SetSessionExpiryInterval());
   Print(TEST_ReadServerReference());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadServerReference()
  {
  Print(__FUNCTION__);
   string expected = "srvref";
   uchar inpkt[] = {28, 0, 6, 's', 'r', 'v', 'r', 'e', 'f'};
   CDisconnect *cut = new CDisconnect();
   string result = cut.ReadServerReference(inpkt, 1);
   bool istrue = StringCompare(expected, result) == 0;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetSessionExpiryInterval()
  {
   Print(__FUNCTION__);
   uchar expected[] = {17, 0, 0, 0, 60};
   uchar result[];
   CDisconnect *cut = new CDisconnect();
   cut.SetSessionExpiryInterval(60, result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadDisconnReasonCode()
  {
   Print(__FUNCTION__);
   uchar expected[] = {MQTT_DISCONN_REASON_CODE_ADMINISTRATIVE_ACTION};
   uchar inpkt[] = {224, 1, 0x98};
   CDisconnect *cut = new CDisconnect();
   uchar result = cut.ReadDisconnReasonCode(inpkt);
   bool istrue = result == expected[0];
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*
The Client or Server sending the DISCONNECT packet MUST use one of the DISCONNECT Reason
Code values [MQTT-3.14.2-1]. The Reason Code and Property Length can be omitted if the Reason
Code is 0x00 (Normal disconnecton) and there are no Properties. In this case the DISCONNECT has a
Remaining Length of 0.
*/
bool TEST_Build()
  {
   Print(__FUNCTION__);
   uchar expected[] = {224, 0x00};
   uchar result[];
   CDisconnect *cut = new CDisconnect();
   cut.Build(result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsDisconnect_YES()
  {
   Print(__FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {224};
   bool result = CDisconnect().IsDisconnect(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsDisconnect_NO()
  {
   Print(__FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   bool result = CDisconnect().IsDisconnect(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
