//+------------------------------------------------------------------+
//|                                             TEST_CPktPublish.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13998 **** |
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
   Print(TEST_SetTopicName_OneChar());
   Print(TEST_SetTopicName_TwoChar());
   Print(TEST_SetTopicName_WildcardChar_NumberSign());
   Print(TEST_SetTopicName_WildcardChar_PlusSign());
   Print(TEST_SetTopicName_Empty());
   Print(TEST_SetPacketID_QoS1_TopicName1Char());
   Print(TEST_SetPacketID_QoS1_TopicName5Char());
   Print(TEST_SetPacketID_QoS2_TopicName1Char());
   Print(TEST_SetPacketID_QoS2_TopicName5Char());
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
//+------------------------------------------------------------------+
//|            TEST_SetPacketID_QoS2_TopicName1Char                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_QoS2_TopicName5Char()
  {
   Print(__FUNCTION__);
// Arrange
   uchar payload[] = {};
   uchar result[]; // expected {52, 9, 0, 1, 'a', 'b', 'c', 'd', 'e', pktID MSB, pktID LSB}
// Act
   CPktPublish *cut = new CPktPublish(payload);
// FIX: if we call SetQoS first this test breaks
   cut.SetTopicName("abcde");
   cut.SetQoS_2(true);
   ArrayCopy(result, cut.ByteArray);
// Assert
   ArrayPrint(result);
   bool is_true = result[9] > 0 || result[10] > 0;
// cleanup
   delete cut;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|            TEST_SetPacketID_QoS2_TopicName1Char                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_QoS2_TopicName1Char()
  {
   Print(__FUNCTION__);
// Arrange
   uchar payload[] = {};
   uchar result[]; // expected {52, 5, 0, 1, 'a', pktID MSB, pktID LSB}
// Act
   CPktPublish *cut = new CPktPublish(payload);
// FIX: if we call SetQoS first this test breaks
   cut.SetTopicName("a");
   cut.SetQoS_2(true);
   ArrayCopy(result, cut.ByteArray);
// Assert
   ArrayPrint(result);
   bool is_true = result[5] > 0 || result[6] > 0;
// cleanup
   delete cut;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|            TEST_SetPacketID_QoS1_TopicName5Char                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_QoS1_TopicName5Char()
  {
   Print(__FUNCTION__);
// Arrange
   uchar payload[] = {};
   uchar result[]; // expected {50, 9, 0, 1, 'a', 'b', 'c', 'd', 'e', pktID MSB, pktID LSB}
// Act
   CPktPublish *cut = new CPktPublish(payload);
// FIX: if we call SetQoS first this test breaks
   cut.SetTopicName("abcde");
   cut.SetQoS_1(true);
   ArrayCopy(result, cut.ByteArray);
// Assert
   ArrayPrint(result);
   bool is_true = result[9] > 0 || result[10] > 0;
// cleanup
   delete cut;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|            TEST_SetPacketID_QoS1_TopicName1Char                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_QoS1_TopicName1Char()
  {
   Print(__FUNCTION__);
// Arrange
   uchar payload[] = {};
   uchar result[]; // expected {50, 5, 0, 1, 'a', pktID MSB, pktID LSB}
// Act
   CPktPublish *cut = new CPktPublish(payload);
// FIX: if we call SetQoS first this test breaks
   cut.SetTopicName("a");
   cut.SetQoS_1(true);
   ArrayCopy(result, cut.ByteArray);
// Assert
   ArrayPrint(result);
   bool is_true = result[5] > 0 || result[6] > 0;
// cleanup
   delete cut;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS0_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {48, 0};
   uchar buf[] = {};
   uchar result[];
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS0_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {49, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetRetain(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS1_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {50, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetQoS_1(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS1_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {51, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetQoS_1(true);
   cut.SetRetain(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS2_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {52, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetQoS_2(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_NoDUP_QoS2_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {53, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetQoS_2(true);
   cut.SetRetain(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS0_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {56, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetDup(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS0_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {57, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetDup(true);
   cut.SetRetain(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS1_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {58, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetDup(true);
   cut.SetQoS_1(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS1_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {59, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetDup(true);
   cut.SetQoS_1(true);
   cut.SetRetain(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS2_NoRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {60, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetDup(true);
   cut.SetQoS_2(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetFixedHeader_DUP_QoS2_RETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {61, 0};
   uchar buf[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(buf);
   cut.SetDup(true);
   cut.SetQoS_2(true);
   cut.SetRetain(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetTopicName_TwoChar()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {48, 4, 0, 2, 'a', 'b'};
   uchar payload[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(payload);
   cut.SetTopicName("ab");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetTopicName_OneChar()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {48, 3, 0, 1, 'a'};
   uchar payload[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(payload);
   cut.SetTopicName("a");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetTopicName_WildcardChar_PlusSign()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {};
   uchar payload[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(payload);
   cut.SetTopicName("a+");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|           TEST_SetTopicName_WildcardChar_NumberSign              |
//+------------------------------------------------------------------+
bool TEST_SetTopicName_WildcardChar_NumberSign()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {};
   uchar payload[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(payload);
   cut.SetTopicName("a#");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//All Topic Names and Topic Filters MUST be at least one character long [MQTT-4.7.3-1]
bool TEST_SetTopicName_Empty()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] = {};
   uchar payload[] = {};
//--- Act
   CPktPublish *cut = new CPktPublish(payload);
   cut.SetTopicName("");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
//cut.SetCleanStart(true);
//cut.SetKeepAlive(10);//10 sec
//cut.SetClientIdentifier("MQL5");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
//cut.SetClientIdentifier("MQL5");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
//cut.SetClientIdentifierLength("MQL5");
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
//cut.SetCleanStart(true);
//cut.SetKeepAlive(10); //10 secs
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
//cut.SetKeepAlive(10); //10 secs
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
//cut.SetCleanStart(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
//cut.SetCleanStart(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
//cut.SetCleanStart(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
//cut.SetCleanStart(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
//cut.SetCleanStart(true);
   uchar result[];
   ArrayCopy(result, cut.ByteArray);
//--- Assert
   bool isTrue = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return isTrue;
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
