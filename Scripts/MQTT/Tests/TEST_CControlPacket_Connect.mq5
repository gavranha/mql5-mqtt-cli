//+------------------------------------------------------------------+
//|                                  TEST_CControlPacket_Connect.mq5 |
//|                                                                  |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13334 **** |
//+------------------------------------------------------------------+
#include <MQTT\CPktConnect.mqh>

//+------------------------------------------------------------------+
//| Tests for CControlPacketConnect class                            |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_GetResponsePktType_CONNACK());
Print(TEST_GetResponsePktType_CONNACK_FAIL());
//Print(TEST_SetCleanStart_KeepAlive_ClientIdentifier());
//Print(TEST_SetClientIdentifier());
//Print(TEST_SetClientIdentifierLength());
//Print(TEST_SetCleanStart_and_SetKeepAlive());
//Print(TEST_SetKeepAlive());
//Print(TEST_SetCleanStart());
  }
/* REFERENCE ARRAY (FIXTURE)
{16, 24, 0, 4, 77, 81, 84, 84, 5, 2, 0, 10, 0, 4, 7, 17, 0, 0, 0, 10, 25, 1, 77, 81, 76, 53}
*/
bool TEST_GetResponsePktType_CONNACK()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected[] = {(uchar)CONNACK};
   uchar empty_buf[10] = {};
   uchar response_fixed_header[] = {(uchar)CONNACK};
   uchar result[];
//--- Act
   CPktConnect *cut = new CPktConnect(empty_buf);
   cut.GetResponsePktType(response_fixed_header, result);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetResponsePktType_CONNACK_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected[] = {(uchar)CONNACK};
   uchar empty_buf[10] = {};
   uchar response_fixed_header[] = {'X'};
   uchar result[];
//--- Act
   CPktConnect *cut = new CPktConnect(empty_buf);
   cut.GetResponsePktType(response_fixed_header, result);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? false : true; // flipped to return TRUE for FAIL
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetCleanStart_KeepAlive_ClientIdentifier()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 16, 0, 4, 77, 81, 84, 84, 5, 2, 0, 10, 0, 4, 77, 81, 76, 53};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetCleanStart(true);
   cut.SetKeepAlive(10);//10 sec
   cut.SetClientIdentifier("MQL5");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetClientIdentifier()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 16, 0, 4, 77, 81, 84, 84, 5, 0, 0, 0, 0, 4, 77, 81, 76, 53};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetClientIdentifier("MQL5");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetClientIdentifierLength()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 12, 0, 4, 77, 81, 84, 84, 5, 0, 0, 0, 0, 4};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetClientIdentifierLength("MQL5");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetCleanStart_and_SetKeepAlive()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 10, 0, 4, 77, 81, 84, 84, 5, 2, 0, 10};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetCleanStart(true);
   cut.SetKeepAlive(10); //10 secs
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
bool TEST_SetKeepAlive()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 10, 0, 4, 77, 81, 84, 84, 5, 0, 0, 10};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetKeepAlive(10); //10 secs
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetCleanStart()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 2};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetCleanStart(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
//ZeroMemory(result);
   return  isTrue ? true : false;
  }
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
