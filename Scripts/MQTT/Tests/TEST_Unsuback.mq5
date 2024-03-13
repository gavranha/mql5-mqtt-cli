//+------------------------------------------------------------------+
//|                                                TEST_Unsuback.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14391 **** |
//+------------------------------------------------------------------+
#include <MQTT\Unsuback.mqh>
#include <MQTT\IControlPacket.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_IsUnsuback_NO());
   Print(TEST_IsUnsuback_YES());
   Print(TEST_ReadReasonString());
   Print(TEST_ReadPayload());
   
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadPayload()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 1, 2};
   uchar inpkt[] = {0x00, 0x01, 0x02};
   uchar result[];
   CUnsuback *cut = new CUnsuback();
   cut.ReadPayload(inpkt,result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadReasonString()
  {
   Print(__FUNCTION__);
   string expected = "reasonstr";
   uchar inpkt[] = {31, 0, 9, 'r', 'e', 'a', 's', 'o', 'n', 's', 't', 'r'};
   CUnsuback *cut = new CUnsuback();
   string result = cut.ReadReasonString(inpkt, 1);
   bool istrue = StringCompare(expected, result) == 0;
   delete(cut);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsUnsuback_YES()
  {
   Print(__FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {176};
   bool result = CUnsuback().IsUnsuback(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsUnsuback_NO()
  {
   Print(__FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   bool result = CUnsuback().IsUnsuback(inpkt);
   return expected == result;
  }