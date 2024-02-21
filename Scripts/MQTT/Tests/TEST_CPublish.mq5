//+------------------------------------------------------------------+
//|                                             TEST_CPublish.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13998 **** |
//+------------------------------------------------------------------+
#include <MQTT\CPublish.mqh>
#include "TestUtil.mqh"
//+------------------------------------------------------------------+
//|           Tests for CPublish class                            |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- props
   Print(TEST_SetProps_PayloadFormatIndicator_UTF8());
   Print(TEST_SetProps_PayloadFormatIndicator_RawBytes());
   Print(TEST_SetProps_MessageExpiryInterval_OneByte());
   Print(TEST_SetProps_MessageExpiryInterval_TwoBytes());
   Print(TEST_SetProps_MessageExpiryInterval_ThreeBytes());
   Print(TEST_SetProps_MessageExpiryInterval_FourBytes());
   Print(TEST_SetProps_TopicAlias_TwoBytes());
   Print(TEST_SetProps_TopicAlias_OneByte());
   Print(TEST_SetProps_ResponseTopic());
   Print(TEST_SetProps_CorrelationData());
   Print(TEST_SetProps_UserProperty());
   Print(TEST_SetProps_SubscriptionIdentifier_OneByte());
   Print(TEST_SetProps_SubscriptionIdentifier_TwoBytes());
   Print(TEST_SetProps_SubscriptionIdentifier_ThreeBytes());
   Print(TEST_SetProps_SubscriptionIdentifier_FourBytes());
   Print(TEST_SetProps_ContentType());
   Print(TEST_SetPayload());
//--- topic name
   Print(TEST_SetTopicName_OneChar());
   Print(TEST_SetTopicName_TwoChar());
   Print(TEST_SetTopicName_WildcardChar_NumberSign());
   Print(TEST_SetTopicName_WildcardChar_PlusSign());
   Print(TEST_SetTopicName_Empty());
//--- packet ID
   Print(TEST_SetPacketID_QoS1_TopicName1Char());
   Print(TEST_SetPacketID_QoS1_TopicName5Char());
   Print(TEST_SetPacketID_QoS2_TopicName1Char());
   Print(TEST_SetPacketID_QoS2_TopicName5Char());
//--- Ctor
   Print(TEST_Ctor_NoTopicName());
   Print(TEST_Ctor_NoFlags_TopicName1Char());
   Print(TEST_Ctor_NoFlags_TopicName2Char());
   Print(TEST_Ctor_NoFlags_TopicName5Char());
   Print(TEST_Ctor_Retain_TopicName1Char());
   Print(TEST_Ctor_Retain_QoS1_TopicName1Char());
   Print(TEST_Ctor_Retain_QoS1_Dup_TopicName1Char());
   Print(TEST_Ctor_Retain_QoS2_Dup_TopicName1Char());
   Print(TEST_Ctor_Retain_QoS2_Dup_TopicName5Char());
  }
//+------------------------------------------------------------------+
//|                          payload                                 |
//+------------------------------------------------------------------+
bool TEST_SetPayload()
  {
   Print(__FUNCTION__);
   static uchar expected[] =
     {50, 19, 0, 1, 'a', 0, 1, 2, 1, 1, 0, 0, 0, 7, 'p', 'a', 'y', 'l', 'o', 'a', 'd'}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetPayloadFormatIndicator(UTF8);
   cut.SetPayload("payload");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                      props                                       |
//+------------------------------------------------------------------+
bool TEST_SetProps_ContentType()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 12, 0, 1, 'a', 0, 1, 6, 3, 0, 3, 'a', 'b', 'c'}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetContentType("abc");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_SubscriptionIdentifier_FourBytes()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 11, 0, 1, 'a', 0, 1, 5, 11, 0x80, 0x80, 0x80, 0x01}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetSubscriptionIdentifier(2097152);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_SubscriptionIdentifier_ThreeBytes()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 10, 0, 1, 'a', 0, 1, 4, 11, 0x80, 0x80, 0x01}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetSubscriptionIdentifier(16384);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_SubscriptionIdentifier_TwoBytes()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 9, 0, 1, 'a', 0, 1, 3, 11, 0x80, 0x01}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetSubscriptionIdentifier(128);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_SubscriptionIdentifier_OneByte()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 8, 0, 1, 'a', 0, 1, 2, 11, 0x01}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetSubscriptionIdentifier(1);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
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
   static uchar expected[] = {50, 17, 0, 1, 'a', 0, 1, 11, 38, 0, 3, 'k', 'e', 'y', 0, 3, 'v', 'a', 'l'}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetUserProperty("key", "val");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
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
   static uchar expected[] = {50, 15, 0, 1, 'a', 0, 1, 9, 9, 0, 1, 0, 1, 0, 1, 0, 1}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   uchar binary_data[] = {0, 1, 0, 1, 0, 1, 0, 1};
   cut.SetCorrelationData(binary_data);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_ResponseTopic()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 12, 0, 1, 'a', 0, 1, 6, 8, 0, 3, 'a', 'b', 'c'}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetResponseTopic("abc");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_TopicAlias_TwoBytes()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 9, 0, 1, 'a', 0, 1, 3, 35, 1, 0}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetTopicAlias(256);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_TopicAlias_OneByte()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 9, 0, 1, 'a', 0, 1, 3, 35, 0, 1}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetTopicAlias(1);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_MessageExpiryInterval_FourBytes()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 11, 0, 1, 'a', 0, 1, 5, 2, 1, 0, 0, 0}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetMessageExpiryInterval(16777216);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_MessageExpiryInterval_ThreeBytes()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 11, 0, 1, 'a', 0, 1, 5, 2, 0, 1, 0, 0}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetMessageExpiryInterval(65536);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_MessageExpiryInterval_TwoBytes()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 11, 0, 1, 'a', 0, 1, 5, 2, 0, 0, 1, 0}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetMessageExpiryInterval(256);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_MessageExpiryInterval_OneByte()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 11, 0, 1, 'a', 0, 1, 5, 2, 0, 0, 0, 1}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetMessageExpiryInterval(1);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_PayloadFormatIndicator_RawBytes()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 8, 0, 1, 'a', 0, 1, 2, 1, 0}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetPayloadFormatIndicator(RAW_BYTES);
   cut.Build(result);
   bool isTrue = Assert(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetProps_PayloadFormatIndicator_UTF8()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {50, 8, 0, 1, 'a', 0, 1, 2, 1, 1}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetPayloadFormatIndicator(UTF8);
   cut.Build(result);
   bool isTrue = Assert(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                         Ctor                                     |
//+------------------------------------------------------------------+
bool TEST_Ctor_Retain_QoS2_Dup_TopicName5Char()
  {
   Print(__FUNCTION__);
   CPublish *cut = new CPublish();
   uchar expected[] = {61, 10, 0, 5, 'a', 'b', 'c', 'd', 'e', 0, 1, 0}; // QoS > 0 require packet ID
   uchar result[];
   cut.SetTopicName("abcde");
   cut.SetRetain(true);
   cut.SetQoS_2(true);
   cut.SetDup(true);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Ctor_Retain_QoS2_Dup_TopicName1Char()
  {
   Print(__FUNCTION__);
   CPublish *cut = new CPublish();
   uchar expected[] = {61, 6, 0, 1, 'a', 0, 1, 0}; // QoS > 0 require packet ID
   uchar result[];
   cut.SetTopicName("a");
   cut.SetRetain(true);
   cut.SetQoS_2(true);
   cut.SetDup(true);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Ctor_Retain_QoS1_Dup_TopicName1Char()
  {
   Print(__FUNCTION__);
   CPublish *cut = new CPublish();
   uchar expected[] = {59, 6, 0, 1, 'a', 0, 1, 0}; // QoS > 0 require packet ID
   uchar result[];
   cut.SetTopicName("a");
   cut.SetRetain(true);
   cut.SetQoS_1(true);
   cut.SetDup(true);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Ctor_Retain_QoS1_TopicName1Char()
  {
   Print(__FUNCTION__);
   CPublish *cut = new CPublish();
   uchar expected[] = {51, 6, 0, 1, 'a', 0, 1, 0}; // QoS > 0 require packet ID
   uchar result[];
   cut.SetTopicName("a");
   cut.SetRetain(true);
   cut.SetQoS_1(true);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Ctor_Retain_TopicName1Char()
  {
   Print(__FUNCTION__);
   CPublish *cut = new CPublish();
   uchar expected[] = {49, 4, 0, 1, 'a', 0};
   uchar result[];
   cut.SetTopicName("a");
   cut.SetRetain(true);
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Ctor_NoFlags_TopicName5Char()
  {
   Print(__FUNCTION__);
   CPublish *cut = new CPublish();
   uchar expected[] = {48, 8, 0, 5, 'a', 'b', 'c', 'd', 'e', 0};
   uchar result[];
   cut.SetTopicName("abcde");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Ctor_NoFlags_TopicName2Char()
  {
   Print(__FUNCTION__);
   CPublish *cut = new CPublish();
   uchar expected[] = {48, 5, 0, 2, 'a', 'b', 0};
   uchar result[];
   cut.SetTopicName("ab");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Ctor_NoFlags_TopicName1Char()
  {
   Print(__FUNCTION__);
   CPublish *cut = new CPublish();
   uchar expected[] = {48, 4, 0, 1, 'a', 0};
   uchar result[];
   cut.SetTopicName("a");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
// Topic Name is mandatory. Must return empty array and log error.
// "It is valid for a PUBLISH packet to contain a zero length Payload"
bool TEST_Ctor_NoTopicName()
  {
   Print(__FUNCTION__);
   CPublish *cut = new CPublish();
   uchar expected[] = {};
   uchar result[];
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete(cut);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|   rem_length = var_header + payload                             |
//|   var_header = topic_name + packet_id + props                    |
//+------------------------------------------------------------------+
bool TEST_Build(void)
  {
   Print(__FUNCTION__);
   uchar expected[] = {};
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetTopicName("a");
   cut.Build(result);
   bool is_true = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return is_true;
  }
//+------------------------------------------------------------------+
//|            packet ID                                             |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_QoS2_TopicName5Char()
  {
   Print(__FUNCTION__);
   uchar result[]; // expected {52, 9, 0, 1, 'a', 'b', 'c', 'd', 'e', pktID MSB, pktID LSB}
   CPublish *cut = new CPublish();
   cut.SetTopicName("abcde");
   cut.SetQoS_2(true);
   cut.Build(result);
   bool is_true = result[9] > 0 || result[10] > 0;
   delete cut;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_QoS2_TopicName1Char()
  {
   Print(__FUNCTION__);
   uchar result[]; // expected {52, 5, 0, 1, 'a', pktID MSB, pktID LSB}
   CPublish *cut = new CPublish();
   cut.SetTopicName("a");
   cut.SetQoS_2(true);
   cut.Build(result);
   bool is_true = result[5] > 0 || result[6] > 0;
   delete cut;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_QoS1_TopicName5Char()
  {
   Print(__FUNCTION__);
   uchar result[]; // expected {50, 9, 0, 1, 'a', 'b', 'c', 'd', 'e', pktID MSB, pktID LSB}
   CPublish *cut = new CPublish();
   cut.SetTopicName("abcde");
   cut.SetQoS_1(true);
   cut.Build(result);
   bool is_true = result[9] > 0 || result[10] > 0;
   delete cut;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPacketID_QoS1_TopicName1Char()
  {
   Print(__FUNCTION__);
   uchar result[]; // expected {50, 5, 0, 1, 'a', pktID MSB, pktID LSB}
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.Build(result);
   bool is_true = result[5] > 0 || result[6] > 0;
   delete cut;
   ZeroMemory(result);
   return is_true;
  }
//+------------------------------------------------------------------+
//|               topic name                                         |
//+------------------------------------------------------------------+
bool TEST_SetTopicName_TwoChar()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {48, 5, 0, 2, 'a', 'b', 0};
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetTopicName("ab");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
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
   static uchar expected[] = {48, 4, 0, 1, 'a', 0};
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetTopicName("a");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
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
   static uchar expected[] = {};
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetTopicName("a+");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetTopicName_WildcardChar_NumberSign()
  {
   Print(__FUNCTION__);
   static uchar expected[] = {};
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetTopicName("a#");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
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
   static uchar expected[] = {};
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetTopicName("");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
