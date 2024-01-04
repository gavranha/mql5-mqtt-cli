//+------------------------------------------------------------------+
//|                                              TestFixedHeader.mq5 |
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
   Print(TestFixedHeader_Connect());
   Print(TestFixedHeader_Connect_RemainingLength1_Fail());
   Print(TestFixedHeader_Publish());
   Print(TestFixedHeader_Publish_RemainingLength1_Fail());
   Print(TestFixedHeader_Puback());
   Print(TestFixedHeader_Puback_RemainingLength1_Fail());
   Print(TestFixedHeader_Pubrec());
   Print(TestFixedHeader_Pubrec_RemainingLength1_Fail());
   Print(TestFixedHeader_Pubrel());
   Print(TestFixedHeader_Pubrel_RemainingLength1_Fail());
   Print(TestFixedHeader_Pubcomp());
   Print(TestFixedHeader_Pubcomp_RemainingLength1_Fail());
   Print(TestFixedHeader_Subscribe());
   Print(TestFixedHeader_Subscribe_RemainingLength1_Fail());
   Print(TestFixedHeader_Puback());
   Print(TestFixedHeader_Puback_RemainingLength1_Fail());
   Print(TestFixedHeader_Unsubscribe());
   Print(TestFixedHeader_Unsubscribe_RemainingLength1_Fail());
   Print(TestFixedHeader_Pingreq());
   Print(TestFixedHeader_Pingreq_RemainingLength1_Fail());
   Print(TestFixedHeader_Disconnect());
   Print(TestFixedHeader_Disconnect_RemainingLength1_Fail());
   Print(TestFixedHeader_Auth());
   Print(TestFixedHeader_Auth_RemainingLength1_Fail());
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Connect()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 1; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(CONNECT, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Connect_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 1; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(CONNECT, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Publish()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 3; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(PUBLISH, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Publish_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 3; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(PUBLISH, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Puback()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 4; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(PUBACK, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Puback_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 4; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(PUBACK, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }
//+------------------------------------------------------------------+
bool TestFixedHeader_Pubrec()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 5; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(PUBREC, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Pubrec_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 5; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(PUBREC, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }
//+------------------------------------------------------------------+
bool TestFixedHeader_Pubrel()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 6; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(PUBREL, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Pubrel_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 6; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(PUBREL, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }
//+------------------------------------------------------------------+
bool TestFixedHeader_Pubcomp()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 7; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(PUBCOMP, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Pubcomp_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 7; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(PUBCOMP, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }
//+------------------------------------------------------------------+
bool TestFixedHeader_Subscribe()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 8; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(SUBSCRIBE, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Subscribe_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 8; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(SUBSCRIBE, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }
//+------------------------------------------------------------------+
bool TestFixedHeader_Unsubscribe()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 10; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(UNSUBSCRIBE, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Unsubscribe_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 10; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(UNSUBSCRIBE, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }
//+------------------------------------------------------------------+
bool TestFixedHeader_Pingreq()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 12; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(PINGREQ, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Pingreq_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 12; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(PINGREQ, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Disconnect()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 14; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(DISCONNECT, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Disconnect_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 14; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(DISCONNECT, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }
//+------------------------------------------------------------------+
bool TestFixedHeader_Auth()
  {
   uchar content_buffer[]; //empty
//---
   uint expected[2];
   expected[0] = 15; //pkt type
   expected[1] = 0; //remaining length
//---
   uint fixed_header[];
//---
   SetFixedHeader(AUTH, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return false;
     }
   Print(__FUNCTION__);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestFixedHeader_Auth_RemainingLength1_Fail()
  {
   uchar content_buffer[]; //empty
   ArrayResize(content_buffer, 1);
   content_buffer[0] = 1;
//---
   uint expected[2];
   expected[0] = 15; //pkt type
   expected[1] = 0; //remaining length should be 1
//---
   uint fixed_header[];
//---
   SetFixedHeader(AUTH, content_buffer, fixed_header);
//---
   if(!ArrayCompare(expected, fixed_header) == 0)
     {
      Print(__FUNCTION__);
      for(uint i = 0; i < expected.Size(); i++)
        {
         Print("expected: ", expected[i], " result: ", fixed_header[i]);
        }
      return true;
     }
   Print(__FUNCTION__);
   return false;
  }
//+------------------------------------------------------------------+
