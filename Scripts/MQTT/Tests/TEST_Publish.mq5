//+------------------------------------------------------------------+
//|                                                TEST_CPublish.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14391 **** |
//+------------------------------------------------------------------+
#include <MQTT\Publish.mqh>
#include <MQTT\Connect.mqh>

#include "TestUtil.mqh"
//---
const string srv_host = "172.20.106.92";
const int srv_port = 80;
const int srv_ssl_port = 443;
//+------------------------------------------------------------------+
//|           Tests for CPublish class                            |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- props
//   Print(TEST_SetProps_PayloadFormatIndicator_UTF8());
//   Print(TEST_SetProps_PayloadFormatIndicator_RawBytes());
//   Print(TEST_SetProps_MessageExpiryInterval_OneByte());
//   Print(TEST_SetProps_MessageExpiryInterval_TwoBytes());
//   Print(TEST_SetProps_MessageExpiryInterval_ThreeBytes());
//   Print(TEST_SetProps_MessageExpiryInterval_FourBytes());
//   Print(TEST_SetProps_TopicAlias_TwoBytes());
//   Print(TEST_SetProps_TopicAlias_OneByte());
//   Print(TEST_SetProps_ResponseTopic());
//   Print(TEST_SetProps_CorrelationData());
//   Print(TEST_SetProps_UserProperty());
//   Print(TEST_SetProps_SubscriptionIdentifier_OneByte());
//   Print(TEST_SetProps_SubscriptionIdentifier_TwoBytes());
//   Print(TEST_SetProps_SubscriptionIdentifier_ThreeBytes());
//   Print(TEST_SetProps_SubscriptionIdentifier_FourBytes());
//   Print(TEST_SetProps_ContentType());
//   Print(TEST_SetPayloadUTF8()); // why this is HERE? on Props?
////--- topic name
//   Print(TEST_SetTopicName_OneChar());
//   Print(TEST_SetTopicName_TwoChar());
//   Print(TEST_SetTopicName_WildcardChar_NumberSign());
//   Print(TEST_SetTopicName_WildcardChar_PlusSign());
//   Print(TEST_SetTopicName_Empty());
////--- packet ID
//   Print(TEST_SetPacketID_QoS1_TopicName1Char());
//   Print(TEST_SetPacketID_QoS1_TopicName5Char());
//   Print(TEST_SetPacketID_QoS2_TopicName1Char());
//   Print(TEST_SetPacketID_QoS2_TopicName5Char());
////--- Ctor
//   Print(TEST_Ctor_NoTopicName());
//   Print(TEST_Ctor_NoFlags_TopicName1Char());
//   Print(TEST_Ctor_NoFlags_TopicName2Char());
//   Print(TEST_Ctor_NoFlags_TopicName5Char());
//   Print(TEST_Ctor_Retain_TopicName1Char());
//   Print(TEST_Ctor_Retain_QoS1_TopicName1Char());
//   Print(TEST_Ctor_Retain_QoS1_Dup_TopicName1Char());
//   Print(TEST_Ctor_Retain_QoS2_Dup_TopicName1Char());
//   Print(TEST_Ctor_Retain_QoS2_Dup_TopicName5Char());
////--- Test Dev Environment
//   Print(TEST_Server_Is_Reachable());
//Print(TEST_Publish_QoS_0_NoProps());
//Print(TEST_Read_TopicName());
//Print(TEST_Read_Message());
   //Print(TEST_SetPayload_RawBytes()); // TODO failing!!!
   Print(TEST_Read_Message_RawBytes());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Read_Message_RawBytes()
  {
   Print(__FUNCTION__);
   string expected = "rawbytes";
   uchar inpkt[] = {'r', 'a', 'w', 'b', 'y', 't', 'e', 's'};
   string result = CPublish().ReadMessageRawBytes(inpkt);
   return StringCompare(expected, result) == 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Read_MessageUTF8()
  {
   Print(__FUNCTION__);
   string expected = "quote";
   uchar inpkt[] = {48, 17, 0, 9, 77, 121, 66, 73, 84, 67, 79, 73, 78, 0, 113, 117, 111, 116, 101};
   string result = CPublish().ReadMessageUTF8(inpkt);
   return StringCompare(expected, result) == 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Read_TopicName()
  {
   Print(__FUNCTION__);
   string expected = "MyBITCOIN";
   uchar inpkt[] = {48, 17, 0, 9, 77, 121, 66, 73, 84, 67, 79, 73, 78, 0, 113, 117, 111, 116, 101};
   string result = CPublish().ReadTopicName(inpkt);
   return StringCompare(expected, result) == 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Publish_QoS_0_NoProps()
  {
   Print(__FUNCTION__);
   uchar conn_pkt[] = {16, 16, 0, 4, 'M', 'Q', 'T', 'T', 5, 2, 0, 10, 0, 0, 3, 'M', 'T', '5'};
   int skt = SocketCreate();
   bool conn = SocketConnect(skt, srv_host, srv_port, 2000);
   int sent = SocketSend(skt, conn_pkt, ArraySize(conn_pkt));
//---
   int result = -1;
   if(sent != -1)
     {
      uchar publish_pkt[];
      ArrayResize(publish_pkt, 8);
      CPublish *cut = new CPublish();
      cut.SetTopicName("t");
      cut.SetPayloadUTF8("Hi2");
      cut.Build(publish_pkt);
      delete(cut);
      ArrayPrint(publish_pkt);
      result = SocketSend(skt, publish_pkt, ArraySize(publish_pkt));
     }
   return result > 0;
  }
//+------------------------------------------------------------------+
//|  We test the dev environment with a reference packet.            |
//|  Uncomment/comment in OnStart() before/after running it.         |
//+------------------------------------------------------------------+
bool TEST_Server_Is_Reachable()
  {
   Print(__FUNCTION__);
   uchar pkt[];
   ArrayResize(pkt, 18);
   pkt[0] = 16;
   pkt[1] = 16;
   pkt[2] = 0;
   pkt[3] = 4;
   pkt[4]  = 'M';
   pkt[5] = 'Q';
   pkt[6] = 'T';
   pkt[7] = 'T';
   pkt[8] = 5; // MQTT 5.0
   pkt[9] = 2; // clean start
   pkt[10] = 0;
   pkt[11] = 10; // keep alive 60sec
   pkt[12] = 0; // prop len
   pkt[13] = 0;
   pkt[14] = 3; // client ID
   pkt[15] = 'M';
   pkt[16] = 'T';
   pkt[17] = '5';
   ArrayPrint(pkt);
//---
   int result = SendConnect(srv_host, srv_port, pkt);
   return result == 0;
  }
//+------------------------------------------------------------------+
//|                          payload                                 |
//+------------------------------------------------------------------+
bool TEST_SetPayload_RawBytes()
  {
   Print(__FUNCTION__);
   static uchar expected[] =
     {50, 17, 0, 1, 'a', 0, 1, 2, 1, 0, 0, 0, 'p', 'a', 'y', 'l', 'o', 'a', 'd'}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetPayloadFormatIndicator(RAW_BYTES);
   cut.SetPayload("payload");
   cut.Build(result);
   bool isTrue = AssertEqual(expected, result);
   delete cut;
   ArrayPrint(expected);
   ArrayPrint(result);
   ZeroMemory(result);
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPayloadUTF8()
  {
   Print(__FUNCTION__);
   static uchar expected[] =
     {50, 19, 0, 1, 'a', 0, 1, 2, 1, 1, 0, 0, 0, 7, 'p', 'a', 'y', 'l', 'o', 'a', 'd'}; // QoS1 for pkt ID generation
   uchar result[];
   CPublish *cut = new CPublish();
   cut.SetQoS_1(true);
   cut.SetTopicName("a");
   cut.SetPayloadFormatIndicator(UTF8);
   cut.SetPayloadUTF8("payload");
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
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
