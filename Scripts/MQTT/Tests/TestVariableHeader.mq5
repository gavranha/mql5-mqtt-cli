//+------------------------------------------------------------------+
//|                                                   TestHeader.mq5 |
//|                                                         JS Lopes |
//|                                                     any@mail.net |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/12857 **** |
//+------------------------------------------------------------------+
#property copyright "JS Lopes"
#property link      "any@mail.net"
#property version   "1.00"

#include <MQTT\MQTT.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   Print(TestVariableHeader_Connect());
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestVariableHeader_Connect()
  {
   uchar fixed_header[];
   uchar variable_header[];
//---
   GenVariableHeader(CONNECT, fixed_header, variable_header);
//---
   uchar expected[25];
   expected[0] = 0; // Length MSB (0)
   expected[1] = 4; // Length LSB (4)
   expected[2] = 77; // M
   expected[3] = 81; // Q
   expected[4] = 84; // T
   expected[5] = 84; // T
   expected[6] = 5; // Protocol Version
   expected[7] = 2; // Connect Flags (0010)
   expected[8] = 2; // Keep Alive MSB 0010
   expected[9] = 88; // Keep Alive LSB 0101 1000
// client ID
   expected[10] = 0; // String length MSB
   expected[11] = 5; // String length LSB
// CONNECT properties
   expected[12] = 7; // properties length
   expected[13] = 17; // Session Expire Interval Identifier
   expected[14] = 0; // Session Expire Interval
   expected[15] = 0;
   expected[16] = 0;
   expected[17] = 10;
   expected[18] = 25; // Request Response Information Identifier
   expected[19] = 1; // Request Response Information
   expected[20] = 'C';
   expected[21] = 'l';
   expected[22] = 'i';
   expected[23] = 'I';
   expected[24] = 'D';
//---
   if(!ArrayCompare(expected, variable_header) == 0)
     {
      Print(__FUNCTION__);
      Print(ArrayCompare(expected, variable_header));
      ArrayPrint(expected);
      ArrayPrint(variable_header);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", variable_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }
//+------------------------------------------------------------------+
