//+------------------------------------------------------------------+
//|                                               TEST_Subscribe.mq5 |
//+------------------------------------------------------------------+
#include <MQTT\Subscribe.mqh>
#include "TestUtil.mqh"

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//+------------------------------------------------------------------+
//|test protected methods or public methods that set protected fields|
//+------------------------------------------------------------------+
   CProtMembers *t = new CProtMembers();
   Print(t.TEST_SetTopicFilter_QoS_0_NoSubOpts());
   Print(t.TEST_SetTopicFilter_QoS_1());
   Print(t.TEST_SetTopicFilter_QoS_2_NonLocal());
   Print(t.TEST_SetTopicFilter_QoS_1_RetainAsPublished_RetainHandling_2());
   Print(TEST_SetSubscriptionIdentifier_OneByte());
   Print(TEST_SetUserProperty());
   Print(TEST_Build_NoSubOpts_NoProps());
   delete(t);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_Build_NoSubOpts_NoProps()
  {
   Print(__FUNCTION__);
   uchar expected[] = {0x82, 7, 0, 1, 0, 0, 1, 't', 0};
   uchar result[];
   CSubscribe *cut = new CSubscribe();
   cut.SetTopicFilter("t");
   cut.Build(result);
   bool is_true = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetUserProperty()
  {
   Print(__FUNCTION__);
   uchar expected[] = {38, 0, 4, 'k', 'e', 'y', ':', 0, 3, 'v', 'a', 'l'};
   CSubscribe *cut = new CSubscribe();
   uchar result[];
   cut.SetUserProperty("key:", "val", result);
   bool isTrue = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return isTrue;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetSubscriptionIdentifier_OneByte()
  {
   Print(__FUNCTION__);
   uchar expected[] = {11, 1};
   uchar result[];
   CSubscribe *cut = new CSubscribe();
   cut.SetSubscriptionIdentifier(result);
   bool is_true = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return is_true;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
class CProtMembers: public CSubscribe
  {
public:
                     CProtMembers() {};
                    ~CProtMembers() {};
   bool              TEST_SetTopicFilter_QoS_0_NoSubOpts();
   bool              TEST_SetTopicFilter_QoS_1();
   bool              TEST_SetTopicFilter_QoS_2_NonLocal();
   bool              TEST_SetTopicFilter_QoS_1_RetainAsPublished_RetainHandling_2();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMembers::TEST_SetTopicFilter_QoS_1_RetainAsPublished_RetainHandling_2(void)
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 3, 'a', '/', 'b', 41};
   uchar result[];
   CSubscribe *cut = new CSubscribe();
   this.SetTopicFilter("a/b", MQTT_SUB_OPTS_QoS_1 \
                       | MQTT_SUB_OPTS_RETAIN_AS_PUBLISHED \
                       | MQTT_SUB_OPTS_RETAIN_HANDLING_2);
   ArrayCopy(result, this.m_topic_filter);
   bool is_true = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMembers::TEST_SetTopicFilter_QoS_2_NonLocal(void)
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 3, 'a', '/', 'b', 6};
   uchar result[];
   CSubscribe *cut = new CSubscribe();
   this.SetTopicFilter("a/b", MQTT_SUB_OPTS_QoS_2 | MQTT_SUB_OPTS_NON_LOCAL);
   ArrayCopy(result, this.m_topic_filter);
   bool is_true = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMembers::TEST_SetTopicFilter_QoS_1(void)
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 3, 'a', '/', 'b', 1};
   uchar result[];
   CSubscribe *cut = new CSubscribe();
   this.SetTopicFilter("a/b", MQTT_SUB_OPTS_QoS_1);
   ArrayCopy(result, this.m_topic_filter);
   bool is_true = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CProtMembers::TEST_SetTopicFilter_QoS_0_NoSubOpts(void)
  {
   Print(__FUNCTION__);
   uchar expected[] = {0, 3, 'a', '/', 'b', 0};
   uchar result[];
   CSubscribe *cut = new CSubscribe();
   this.SetTopicFilter("a/b");
   ArrayCopy(result, this.m_topic_filter);
   bool is_true = AssertEqual(expected, result);
   ZeroMemory(result);
   delete(cut);
   return is_true;
  }
//+------------------------------------------------------------------+
