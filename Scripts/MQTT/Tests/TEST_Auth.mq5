//+------------------------------------------------------------------+
//|                                                    TEST_Auth.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14677 **** |
//+------------------------------------------------------------------+
#include <MQTT\Auth.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_IsAuth_NO());
   Print(TEST_IsAuth_YES());
   Print(TEST_Build());
   Print(TEST_SetAuthMethod());
   Print(TEST_SetAuthData());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetAuthData()
  {
   Print(__FUNCTION__);
   uchar expected[] = {22, 'b', 'i', 'n', 'd', 'a', 't', 'a'};
   CAuth *cut = new CAuth();
   uchar result[];
   cut.SetAuthData("bindata", result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetAuthMethod()
  {
   Print(__FUNCTION__);
   uchar expected[] = {21, 0, 10, 'a', 'u', 't', 'h', 'm', 'e', 't', 'h', 'o', 'd'};
   CAuth *cut = new CAuth();
   uchar result[];
   cut.SetAuthMethod("authmethod", result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Build()
  {
   Print(__FUNCTION__);
   uchar expected[] = {240, 0};
   uchar result[];
   CAuth *cut = new CAuth();
   cut.Build(result);
   bool istrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return istrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsAuth_YES()
  {
   Print(__FUNCTION__);
   bool expected = true;
   uchar inpkt[] = {240};
   bool result = CAuth().IsAuth(inpkt);
   return expected == result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_IsAuth_NO()
  {
   Print(__FUNCTION__);
   bool expected = false;
   uchar inpkt[] = {'n', 'o', 'a', 'c', 'k'};
   bool result = CAuth().IsAuth(inpkt);
   return expected == result;
   return false;
  }


//+------------------------------------------------------------------+
