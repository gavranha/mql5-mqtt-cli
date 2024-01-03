//+------------------------------------------------------------------+
//|                                                     TestUtil.mqh |
//|                                                         JS Lopes |
//|                                                     any@mail.net |
//+------------------------------------------------------------------+
#property copyright "JS Lopes"
#property link      "any@mail.net"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AssertNotEqual(uchar & expected[], uchar & result[])
  {
   if(!ArrayCompare(expected, result) == 0)
     {
      for(uint i = 0; i < expected.Size(); i++)
        {
         printf("expected\t%d\t\t%d result", expected[i], result[i]);
        }
      printf("expected size %d <=> %d result size", expected.Size(), result.Size());
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AssertEqual(uchar & expected[], uchar & result[])
  {
   if(!ArrayCompare(expected, result) == 0)
     {
      for(uint i = 0; i < expected.Size(); i++)
        {
         printf("expected\t%d\t\t%d result", expected[i], result[i]);
        }
      printf("expected size %d <=> %d result size", expected.Size(), result.Size());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Assert(uchar& expected[], uchar& result[])
  {
   if(!ArrayCompare(expected, result) == 0)
     {
      for(uint i = 0; i < expected.Size(); i++)
        {
         printf("expected\t%d\t\t%d result", expected[i], result[i]);
        }
      printf("expected size %d <=> %d result size", expected.Size(), result.Size());
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ArrayToHex(uchar &arr[], int count = -1)
  {
   string res = "";
//--- check
   if(count < 0 || count > ArraySize(arr))
      count = ArraySize(arr);
//--- transform to HEX string
   for(int i = 0; i < count; i++)
      res += StringFormat("%.2X ", arr[i]);
//---
   return(res);
  }
//+------------------------------------------------------------------+
