//+------------------------------------------------------------------+
//|                                                  TEST_Puback.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14677 **** |
//+------------------------------------------------------------------+
#include <MQTT\Puback.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//|               Tests for CPuback class                            |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_ReadProperties_UserProperty());
   Print(TEST_ReadProperties_ReasonString_and_UserProperty());
//=============================== REFACTORED
   Print(TEST_Ctor());
   Print(TEST_IsPuback_NO());
   Print(TEST_IsPuback_YES());
   Print(TEST_ReadPacketIdentifier());
   Print(TEST_PUBACK_ReadReasonCode());
   Print(TEST_ReadReasonString_OLD());
   Print(TEST_ReadReasonString());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadReasonString()
  {
   Print( __FUNCTION__);
   string expected = "reasonstr";
   uchar inpkt[] = {31, 0, 9, 'r', 'e', 'a', 's', 'o', 'n', 's', 't', 'r'};
   CPuback *cut = new CPuback();
   string result = cut.ReadReasonString(inpkt, 1);
   bool istrue = StringCompare(expected, result) == 0;
   delete(cut);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadReasonString_OLD()
  {
   Print( __FUNCTION__);
   uchar pkt[] = {4, 15, 0, 1, 12, 31, 0, 9, 'r', 'e', 'a', 's', 'o', 'n', 's', 't', 'r'};
   uint expected = 1;
   CPuback *cut = new CPuback();
   uint result = cut.ReadProperties(pkt, 12, 5);
   bool istrue = expected == result;
   delete(cut);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_PUBACK_ReadReasonCode()
  {
   Print( __FUNCTION__);
   int expected = 10;
   uchar pkt[] = {4, 2, 0, 1, 0xA};
   CPuback *cut = new CPuback();
   int result = cut.ReadReasonCode(pkt, 4);
   bool istrue = (result == expected);
   delete cut;
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadPacketIdentifier()
  {
   Print( __FUNCTION__);
   ushort expected = 512;
   uchar inpkt[] = {64, 2, 2, 0};
   CPuback *cut = new CPuback(inpkt);
   ushort result = cut.ReadPacketIdentifier(inpkt, 2);
   bool istrue = result == expected;
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsPuback_YES()
  {
    Print(__FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {64};
   bool result = CPuback(inpkt).IsPuback(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsPuback_NO()
  {
   Print(__FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   bool result = CPuback().IsPuback(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
//|                          Ctor                                    |
//+------------------------------------------------------------------+
bool TEST_Ctor()
  {
   Print( __FUNCTION__);
   static uchar expected[] = {64};
   uchar result[];
   CPuback *cut = new CPuback();
   cut.Build(result);
   bool istrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadProperties_ReasonString_and_UserProperty()
  {
   Print( __FUNCTION__);
   uchar pkt[] = {4, 27, 0, 1, 24, 31, 0, 9, 'r', 'e', 'a', 's', 'o', 'n', 's', 't', 'r', \
                  38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'
                 };
   uint expected = 2;
   CPuback *cut = new CPuback();
   uint result = cut.ReadProperties(pkt, 24, 5);
   bool istrue = expected == result;
   delete(cut);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadProperties_UserProperty()
  {
   Print( __FUNCTION__);
   uchar pkt[] = {4, 15, 0, 1, 12, 38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'};
   uint expected = 1;
   CPuback *cut = new CPuback();
   uint result = cut.ReadProperties(pkt, 12, 5);
   bool istrue = expected == result;
   delete(cut);
   ZeroMemory(result);
   return istrue;
  }


//+------------------------------------------------------------------+
