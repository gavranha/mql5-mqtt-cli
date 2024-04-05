//+------------------------------------------------------------------+
//|                                                  TEST_Pubrec.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14677 **** |
//+------------------------------------------------------------------+
#include <MQTT\Pubrec.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_IsPubrec_NO());
   Print(TEST_IsPubrec_YES());
   Print(TEST_ReadReasonCode());
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
   CPubrec *cut = new CPubrec(inpkt);
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
   Print( __FUNCTION__);
   int expected = 10;
   uchar inpkt[] = {80, 2, 0, 1, 0xA};
   CPubrec *cut = new CPubrec(inpkt);
   int result = cut.ReadReasonCode(inpkt, 4);
   bool istrue = (result == expected);
   delete cut;
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsPubrec_YES()
  {
   Print(__FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {80};
   bool result = CPubrec(inpkt).IsPubrec(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
bool TEST_IsPubrec_NO()
  {
   Print(__FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   bool result = CPubrec(inpkt).IsPubrec(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
