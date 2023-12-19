//+------------------------------------------------------------------+
//|                                                         Util.mqh |
//|                                                         JS Lopes |
//|                                                     any@mail.net |
//+------------------------------------------------------------------+
#property copyright "JS Lopes"
#property link      "any@mail.net"

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
