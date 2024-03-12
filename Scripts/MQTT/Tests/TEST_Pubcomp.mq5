//+------------------------------------------------------------------+
//|                                                  TEST_Pubcomp.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <MQTT\Pubcomp.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_IsPubcomp_NO());
   Print(TEST_IsPubcomp_YES());
      Print(TEST_ReadReasonCode());
   Print(TEST_ReadReasonString());
  }
  //+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadReasonString()
  {
   Print(__FUNCTION__);
   string expected = "reasonstr";
   uchar inpkt[] = {31, 0, 9, 'r', 'e', 'a', 's', 'o', 'n', 's', 't', 'r'};
   CPubcomp *cut = new CPubcomp(inpkt);
   string result = cut.ReadReasonString(inpkt, 1);
   bool istrue = StringCompare(expected, result) == 0;
   delete(cut);
   ZeroMemory(result);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_ReadReasonCode()
  {
   Print(__FUNCTION__);
   int expected = 10;
   uchar inpkt[] = {112, 2, 0, 1, 0xA};
   CPubcomp *cut = new CPubcomp(inpkt);
   int result = cut.ReadReasonCode(inpkt, 4);
   bool istrue = (result == expected);
   delete cut;
   return istrue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsPubcomp_YES()
  {
   Print( __FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {112};
   CPubcomp *cut = new CPubcomp(inpkt);
   bool result = cut.IsPubcomp(inpkt);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
bool TEST_IsPubcomp_NO()
  {
   Print( __FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   CPubcomp *cut = new CPubcomp(inpkt);
   bool result = cut.IsPubcomp(inpkt);
   bool isFalse = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isFalse;
  }
//+------------------------------------------------------------------+
