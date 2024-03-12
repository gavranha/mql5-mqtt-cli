//+------------------------------------------------------------------+
//|                                                  TEST_Pubrel.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <MQTT\Pubrel.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_IsPubrel_NO());
   Print(TEST_IsPubrel_YES());
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
   CPubrel *cut = new CPubrel(inpkt);
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
   uchar inpkt[] = {96, 2, 0, 1, 0xA};
   CPubrel *cut = new CPubrel(inpkt);
   int result = cut.ReadReasonCode(inpkt, 4);
   bool istrue = (result == expected);
   delete cut;
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsPubrel_YES()
  {
   Print(__FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {96};
   CPubrel *cut = new CPubrel(inpkt);
   bool result = cut.IsPubrel(inpkt);
   bool istrue = expected == result;
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
bool TEST_IsPubrel_NO()
  {
   Print(__FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   CPubrel *cut = new CPubrel(inpkt);
   bool result = cut.IsPubrel(inpkt);
   bool isFalse = expected == result;
   ZeroMemory(result);
   delete(cut);
   return isFalse;
  }
//+------------------------------------------------------------------+
