//+------------------------------------------------------------------+
//|                                             TEST_CPktPublish.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13388 **** |
//+------------------------------------------------------------------+
#include <MQTT\CPktPublish.mqh>

//+------------------------------------------------------------------+
//|           Tests for CPktPublish class                            |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(TEST_SetFixedHeader_NoDUP_QoS0_NoRETAIN());
   Print(TEST_SetFixedHeader_NoDUP_QoS0_RETAIN());
   Print(TEST_SetFixedHeader_NoDUP_QoS1_NoRETAIN());
   Print(TEST_SetFixedHeader_NoDUP_QoS1_RETAIN());
   Print(TEST_SetFixedHeader_NoDUP_QoS2_NoRETAIN());
   Print(TEST_SetFixedHeader_NoDUP_QoS2_RETAIN());
   Print(TEST_SetFixedHeader_DUP_QoS0_NoRETAIN());
   Print(TEST_SetFixedHeader_DUP_QoS0_RETAIN());
   Print(TEST_SetFixedHeader_DUP_QoS1_NoRETAIN());
   Print(TEST_SetFixedHeader_DUP_QoS1_RETAIN());
   Print(TEST_SetFixedHeader_DUP_QoS2_NoRETAIN());
   Print(TEST_SetFixedHeader_DUP_QoS2_RETAIN());
   Print(TEST_SetVarHeader_TopicName());
   Print(TEST_SetVarHeader_TopicName_FAIL_WildcardChar());
   Print(TEST_SetVarHeader_TopicName_FAIL_Empty());
   Print(TEST_SetProps_Length());
   Print(TEST_SetProps_PayloadFormatIndicator());
   Print(TEST_SetProps_MessageExpiryInterval());
   Print(TEST_SetProps_TopicAlias());
   Print(TEST_SetProps_ResponseTopic());
   Print(TEST_SetProps_CorrelationData());
   Print(TEST_SetProps_UserProperty());
   Print(TEST_SetProps_SubscriptionIdentifier());
   Print(TEST_SetProps_ContentType());
   Print(TEST_SetPayload());
  }
/* REFERENCE ARRAY (FIXTURE)
{16, 24, 0, 4, 77, 81, 84, 84, 5, 2, 0, 10, 0, 4, 7, 17, 0, 0, 0, 10, 25, 1, 77, 81, 76, 53}
*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS0_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 128};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetUserNameFlag(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS0_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 64};// last element should be 128 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetUserNameFlag(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS1_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 64};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetPasswordFlag(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS1_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 32};// last element should be 64 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetPasswordFlag(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS2_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 32};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetWillRetain(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS2_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 16};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetWillRetain(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS0_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 16};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetWillQoS_2(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
  //+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS0_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 16};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetWillQoS_2(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS1_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 8}; // last element should be 16 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetWillQoS_2(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
  //+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS1_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 8}; // last element should be 16 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetWillQoS_2(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS2_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 8};
   uchar buf[expected.Size() - 2];
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetWillQoS_1(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS2_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 8};
   uchar buf[expected.Size() - 2];
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetWillQoS_1(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetVarHeader_TopicName()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 4};// last element should be 8 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetWillQoS_1(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetVarHeader_TopicName_FAIL_WildcardChar()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 4};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetWillFlag(true);
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
bool TEST_SetVarHeader_TopicName_FAIL_Empty()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 2};//last element should be 4 instead of 2 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
//--- Act
   cut.SetWillFlag(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_Length()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 16, 0, 4, 77, 81, 84, 84, 5, 2, 0, 10, 0, 4, 77, 81, 76, 53};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
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
bool TEST_SetProps_PayloadFormatIndicator()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 16, 0, 4, 77, 81, 84, 84, 5, 0, 0, 0, 0, 4, 77, 81, 76, 53};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
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
bool TEST_SetProps_MessageExpiryInterval()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 12, 0, 4, 77, 81, 84, 84, 5, 0, 0, 0, 0, 4};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
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
bool TEST_SetProps_TopicAlias()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 10, 0, 4, 77, 81, 84, 84, 5, 2, 0, 10};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
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
bool TEST_SetProps_ResponseTopic()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 10, 0, 4, 77, 81, 84, 84, 5, 0, 0, 10};
   uchar buf[expected.Size() - 2];
   CPktPublish *cut = new CPktPublish(buf);
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
bool TEST_SetProps_CorrelationData()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 2};
   uchar buf[expected.Size() - 2];
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetCleanStart(true);
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
bool TEST_SetProps_UserProperty()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 2};
   uchar buf[expected.Size() - 2];
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetCleanStart(true);
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
bool TEST_SetProps_SubscriptionIdentifier()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 2};
   uchar buf[expected.Size() - 2];
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetCleanStart(true);
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
bool TEST_SetProps_ContentType()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 2};
   uchar buf[expected.Size() - 2];
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetCleanStart(true);
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
bool TEST_SetPayload()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 2};
   uchar buf[expected.Size() - 2];
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetCleanStart(true);
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
