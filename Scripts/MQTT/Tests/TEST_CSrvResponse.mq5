//+------------------------------------------------------------------+
//|                                            TEST_CSrvResponse.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13651 **** |
//+------------------------------------------------------------------+
#include <MQTT\CSrvResponse.mqh>

//+------------------------------------------------------------------+
//| Tests for CSrvResponse class                                     |
//+------------------------------------------------------------------+
void OnStart()
  {
   TestProtectedMethods *testProtectedMethods = new TestProtectedMethods();
   Print(testProtectedMethods.TEST_GetConnectReasonCode());
   Print(testProtectedMethods.TEST_GetConnectReasonCode_FAIL());
   Print(testProtectedMethods.TEST_HasProperties_CONNACK_No_Props());
   Print(testProtectedMethods.TEST_HasProperties_CONNACK_No_Props_FAIL());
   Print(testProtectedMethods.TEST_GetPropertyIdentifier());
   Print(testProtectedMethods.TEST_GetPropertyIdentifier_FAIL());
   Print(testProtectedMethods.TEST_ReadOneByteProperty_FAIL());
   Print(testProtectedMethods.TEST_ReadOneByteProperty());
   Print(testProtectedMethods.TEST_ReadTwoByteProperty_FAIL());
   Print(testProtectedMethods.TEST_ReadTwoByteProperty());
   Print(testProtectedMethods.TEST_ReadFourByteProperty_FAIL());
   Print(testProtectedMethods.TEST_ReadFourByteProperty());
   Print(testProtectedMethods.TEST_ReadVariableByteProperty_FAIL());
   Print(testProtectedMethods.TEST_ReadVariableByteProperty());
   Print(testProtectedMethods.TEST_ReadUTF8StringProperty_FAIL());
   Print(testProtectedMethods.TEST_ReadUTF8StringProperty());
   Print(testProtectedMethods.TEST_ReadBinaryDataProperty_FAIL());
   Print(testProtectedMethods.TEST_ReadBinaryDataProperty());
   delete(testProtectedMethods);
//---
   Print(TEST_IsRETAIN());
   Print(TEST_IsRETAIN_FAIL());
   Print(TEST_GetQoSLevel_2());
   Print(TEST_GetQoSLevel_1());
   Print(TEST_GetQoSLevel_0());
   Print(TEST_GetQoSLevel_0_FAIL());
   Print(TEST_IsDUP());
   Print(TEST_IsDUP_FAIL());
   Print(TEST_GetPktType());
   Print(TEST_GetPktType_FAIL());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TestProtectedMethods: public CSrvResponse
  {
public:
                     TestProtectedMethods() {};
                    ~TestProtectedMethods() {};
   bool              TEST_GetConnectReasonCode_FAIL();
   bool              TEST_GetConnectReasonCode();
   bool              TEST_HasProperties_CONNACK_No_Props_FAIL();
   bool              TEST_HasProperties_CONNACK_No_Props();
   bool              TEST_GetPropertyIdentifier_FAIL();
   bool              TEST_GetPropertyIdentifier();
   bool              TEST_ReadOneByteProperty_FAIL();
   bool              TEST_ReadOneByteProperty();
   bool              TEST_ReadTwoByteProperty_FAIL();
   bool              TEST_ReadTwoByteProperty();
   bool              TEST_ReadFourByteProperty_FAIL();
   bool              TEST_ReadFourByteProperty();
   bool              TEST_ReadVariableByteProperty_FAIL();
   bool              TEST_ReadVariableByteProperty();
   bool              TEST_ReadUTF8StringProperty_FAIL();
   bool              TEST_ReadUTF8StringProperty();
   bool              TEST_ReadBinaryDataProperty_FAIL();
   bool              TEST_ReadBinaryDataProperty();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadBinaryDataProperty()
  {
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadBinaryDataProperty_FAIL()
  {
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadUTF8StringProperty()
  {
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadUTF8StringProperty_FAIL()
  {
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadVariableByteProperty()
  {
   Print(__FUNCTION__);
//--- Arrange
   uint expected[1] = {1};
   uint variable_byte_prop[7] = {2, 5, 0, 0, 2, 11, 1};// MQTT_PROPERTY_SUBSCRIPTION_IDENTIFIER 0x0B (11) Variable Byte Integer
   uint result[];
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   this.ReadVariableByteProperty(variable_byte_prop, result, 6);
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
bool TestProtectedMethods::TEST_ReadVariableByteProperty_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   uint expected[1] = {0};
   uint variable_byte_prop_fail[7] = {2, 5, 0, 0, 2, 11, 1};// MQTT_PROPERTY_SUBSCRIPTION_IDENTIFIER 0x0B (11) Variable Byte Integer
   uint result[];
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   this.ReadVariableByteProperty(variable_byte_prop_fail, result, 6);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? false : true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadFourByteProperty()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected[4] = {1, 1, 1, 1};
   uchar four_byte_prop[10] = {2, 5, 0, 0, 4, 2, 1, 1, 1, 1};// MQTT_PROPERTY_MESSAGE_EXPIRY_INTERVAL 0x02 (2) Four Byte Integer
   uchar result[];
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   this.ReadFourByteProperty(four_byte_prop, result);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadFourByteProperty_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected[4] = {1, 1, 1, 1};
   uchar four_byte_prop_fail[10] = {2, 5, 0, 0, 4, 2, 0, 0, 0, 0};// MQTT_PROPERTY_MESSAGE_EXPIRY_INTERVAL 0x02 (2) Four Byte Integer
   uchar result[];
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   this.ReadFourByteProperty(four_byte_prop_fail, result);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? false : true;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadTwoByteProperty()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected[2] = {0, 0};
   uchar two_byte_prop[8] = {2, 5, 0, 0, 3, 19, 0, 0};//MQTT_PROPERTY_SERVER_KEEP_ALIVE 0x13 (19) Two Byte Integer
   uchar result[];
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   this.ReadTwoByteProperty(two_byte_prop, result);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadTwoByteProperty_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected[2] = {1, 1};
   uchar two_byte_prop_fail[8] = {2, 5, 0, 0, 3, 19, 0, 0};//MQTT_PROPERTY_SERVER_KEEP_ALIVE 0x13 (19) Two Byte Integer
   uchar result[];
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   this.ReadTwoByteProperty(two_byte_prop_fail, result);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? false : true;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadOneByteProperty()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected = 1;
   uchar one_byte_prop_fail[7] = {2, 5, 0, 0, 2, 1, 1};//MQTT_PROPERTY_PAYLOAD_FORMAT_INDICATOR 0x01 (1) Byte
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   uchar result =  this.ReadOneByteProperty(one_byte_prop_fail);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_ReadOneByteProperty_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected = 1;
   uchar one_byte_prop_fail[7] = {2, 5, 0, 0, 2, 1, 2};//MQTT_PROPERTY_PAYLOAD_FORMAT_INDICATOR 0x01 (1) Byte
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   uchar result =  this.ReadOneByteProperty(one_byte_prop_fail);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? false : true;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_GetPropertyIdentifier_FAIL(void)
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected = MQTT_PROPERTY_PAYLOAD_FORMAT_INDICATOR;//0x01 (1) Byte
   uchar connack_one_byte_prop_fail[7] = {2, 5, 0, 0, 2, 2, 1};// FAIL
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   uchar result =  this.GetPropertyIdentifier(connack_one_byte_prop_fail);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? false : true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_GetPropertyIdentifier(void)
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected = MQTT_PROPERTY_PAYLOAD_FORMAT_INDICATOR;//0x01 (1) Byte
   uchar connack_one_byte_prop[7] = {2, 5, 0, 0, 2, 1, 1};
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   uchar result =  this.GetPropertyIdentifier(connack_one_byte_prop);
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
bool TestProtectedMethods::TEST_HasProperties_CONNACK_No_Props_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   bool expected = false;
   uchar connack_no_props_fail[5] = {2, 3, 0, 0, 1};// FAIL - last byte is property length
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   bool result =  this.HasProperties(connack_no_props_fail);
//--- Assert
   bool isTrue = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? false : true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtectedMethods::TEST_HasProperties_CONNACK_No_Props()
  {
   Print(__FUNCTION__);
//--- Arrange
   bool expected = false;
   uchar connack_no_props[5] = {2, 3, 0, 0, 0};
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   bool result =  this.HasProperties(connack_no_props);
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
bool TestProtectedMethods::TEST_GetConnectReasonCode_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected = MQTT_REASON_CODE_SUCCESS;
   uchar reason_code_banned[4];
   reason_code_banned[0] = B'00100000'; // packet type
   reason_code_banned[1] = 2; // remaining length
   reason_code_banned[2] = 0; // connect acknowledge flags
   reason_code_banned[3] = MQTT_REASON_CODE_BANNED;
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   uchar result = this.GetConnectReasonCode(reason_code_banned);
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
bool TestProtectedMethods::TEST_GetConnectReasonCode()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected = MQTT_REASON_CODE_SUCCESS;
   uchar reason_code_success[4];
   reason_code_success[0] = B'00100000'; // packet type
   reason_code_success[1] = 2; // remaining length
   reason_code_success[2] = 0; // connect acknowledge flags
   reason_code_success[3] = MQTT_REASON_CODE_SUCCESS;
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   uchar result = this.GetConnectReasonCode(reason_code_success);
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
bool TEST_IsRETAIN()
  {
   Print(__FUNCTION__);
//--- Arrange
   bool expected = true;
   bool result;
   uchar first_byte_CONNACK_RETAIN[] = {B'00011000'};
//--- Act
   CSrvResponse * cut = new CSrvResponse();
   result = cut.IsRETAIN(first_byte_CONNACK_RETAIN);
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
bool TEST_IsRETAIN_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   bool expected = true; // we are expecting true...
   bool result;
   uchar first_byte_CONNACK_NO_RETAIN[] = {B'00010000'}; //... but passing NO RETAIN...
//--- Act
   CSrvResponse * cut = new CSrvResponse();
   result = cut.IsRETAIN(first_byte_CONNACK_NO_RETAIN);
//--- Assert
   bool isTrue = AssertNotEqual(expected, result);//... test should fail
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetQoSLevel_2()
  {
   Print(__FUNCTION__);
//--- Arrange
   ENUM_QOS_LEVEL expected = EXACTLY_ONCE;
   ENUM_QOS_LEVEL result;
   uchar connack_with_QoS_2[] = {B'00010110'};
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   result = cut.GetQoSLevel(connack_with_QoS_2);
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
bool TEST_GetQoSLevel_1()
  {
   Print(__FUNCTION__);
//--- Arrange
   ENUM_QOS_LEVEL expected = AT_LEAST_ONCE;
   ENUM_QOS_LEVEL result;
   uchar connack_with_QoS_1[] = {B'00010010'};
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   result = cut.GetQoSLevel(connack_with_QoS_1);
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
bool TEST_GetQoSLevel_0()
  {
   Print(__FUNCTION__);
//--- Arrange
   ENUM_QOS_LEVEL expected = AT_MOST_ONCE;
   ENUM_QOS_LEVEL result;
   uchar connack_with_QoS_0[] = {B'00010000'};
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   result = cut.GetQoSLevel(connack_with_QoS_0);
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
bool TEST_GetQoSLevel_0_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   ENUM_QOS_LEVEL expected = AT_MOST_ONCE;
   ENUM_QOS_LEVEL result;
   uchar connack_with_QoS_2[] = {B'00010110'}; // EXACTLY_ONCE
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   result = cut.GetQoSLevel(connack_with_QoS_2);
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
bool TEST_IsDUP()
  {
   Print(__FUNCTION__);
//--- Arrange
   bool expected = true;
   bool result;
   uchar first_byte_CONNACK_DUP[] = {B'00011000'};
//--- Act
   CSrvResponse * cut = new CSrvResponse();
   result = cut.IsDUP(first_byte_CONNACK_DUP);
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
bool TEST_IsDUP_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   bool expected = true; // we are expecting true...
   bool result;
   uchar first_byte_CONNACK_NO_DUP[] = {B'00010000'}; //... but passing NO DUP...
//--- Act
   CSrvResponse * cut = new CSrvResponse();
   result = cut.IsDUP(first_byte_CONNACK_NO_DUP);
//--- Assert
   bool isTrue = AssertNotEqual(expected, result);//... test should fail
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  isTrue ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_GetPktType()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected[] = {(uchar)CONNACK};
   uchar result[1] = {};
   uchar right_first_byte[] = {B'00100000'};
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   ENUM_PKT_TYPE pkt_type = cut.GetPktType(right_first_byte);
   ArrayFill(result, 0, 1, (uchar)pkt_type);
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
bool TEST_GetPktType_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   uchar expected[] = {(uchar)CONNACK};
   uchar result[1] = {};
   uchar wrong_first_byte[] = {'X'};
//--- Act
   CSrvResponse *cut = new CSrvResponse();
   ENUM_PKT_TYPE pkt_type = cut.GetPktType(wrong_first_byte);
   ArrayFill(result, 0, 1, (uchar)pkt_type);
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
bool AssertEqual(ENUM_QOS_LEVEL expected, ENUM_QOS_LEVEL result)
  {
   return expected == result ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AssertNotEqual(ENUM_QOS_LEVEL expected, ENUM_QOS_LEVEL result)
  {
   return expected == result ? false : true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AssertEqual(uint expected, uint result)
  {
   if(expected != result)
     {
      printf("expected\t%d\t\t%d result", expected, result);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AssertEqual(uchar expected, uchar result)
  {
   if(expected != result)
     {
      printf("expected\t%d\t\t%d result", expected, result);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AssertEqual(bool expected, bool result)
  {
   return expected == result ? true : false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AssertNotEqual(bool expected, bool result)
  {
   return expected == result ? false : true;
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
bool AssertEqual(uint & expected[], uint & result[])
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
