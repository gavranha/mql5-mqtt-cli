//+------------------------------------------------------------------+
//|                                             TEST_CPktConnect.mq5 |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13388 **** |
//+------------------------------------------------------------------+
#include <MQTT\CPktConnect.mqh>
#include "TestUtil.mqh"

//+------------------------------------------------------------------+
//|           Tests for CPktConnect class                            |
//+------------------------------------------------------------------+
void OnStart()
  {
   TestProtMethods *t = new TestProtMethods();
   Print(t.TEST_SetFixHeader_RemLength_1digit());
   Print(t.TEST_SetFixHeader_RemLength_2digits());
   delete(t);
//Print(TEST_SetUserNameFlag());
//Print(TEST_SetUserNameFlag_FAIL());
//Print(TEST_SetPasswordFlag());
//Print(TEST_SetPasswordFlag_FAIL());
//Print(TEST_SetWillRetain());
//Print(TEST_SetWillRetain_FAIL());
//Print(TEST_SetWillQoS2());
//Print(TEST_SetWillQoS2_FAIL());
//Print(TEST_SetWillQoS1());
//Print(TEST_SetWillQoS1_FAIL());
//Print(TEST_SetWillFlag());
//Print(TEST_SetWillFlag_FAIL());
//Print(TEST_SetCleanStart_KeepAlive_ClientIdentifier());
//Print(TEST_SetClientIdentifier());
//Print(TEST_SetClientIdentifierLength());
//Print(TEST_SetCleanStart_and_SetKeepAlive());
//Print(TEST_SetKeepAlive());
//Print(TEST_SetCleanStart());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TestProtMethods: public CPktConnect
  {
public:
                     TestProtMethods() {};
                    ~TestProtMethods() {};
   bool              TEST_SetFixHeader_RemLength_1digit();
   bool              TEST_SetFixHeader_RemLength_2digits();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_SetFixHeader_RemLength_2digits()
  {
   Print(__FUNCTION__);
   uint expected[] = {16, 0xFF, 0x7F};
   uchar buf[10];
   CPktConnect *cut = new CPktConnect(buf);
   uint result[];
   this.SetFixHeader(16383, result);
   bool is_true = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TestProtMethods::TEST_SetFixHeader_RemLength_1digit()
  {
   Print(__FUNCTION__);
   uint expected[] = {16, 127};
   uchar buf[10];
   CPktConnect *cut = new CPktConnect(buf);
   uint result[];
   this.SetFixHeader(127, result);
   bool is_true = AssertEqual(expected, result);
   ZeroMemory(result);
   delete cut;
   return is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetUserNameFlag()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 128};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetUserNameFlag(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetUserNameFlag_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 64};// last element should be 128 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetUserNameFlag(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPasswordFlag()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 64};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetPasswordFlag(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetPasswordFlag_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 32};// last element should be 64 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetPasswordFlag(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetWillRetain()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 32};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetWillRetain(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetWillRetain_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 16};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetWillRetain(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetWillQoS2()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 16};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetWillQoS_2(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetWillQoS2_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 8}; // last element should be 16 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetWillQoS_2(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetWillQoS1()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 8};
   uchar buf[expected.Size() - 2];
//--- Act
   CPktConnect *cut = new CPktConnect(buf);
   cut.SetWillQoS_1(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetWillQoS1_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 4};// last element should be 8 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetWillQoS_1(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetWillFlag()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 4};
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetWillFlag(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TEST_SetWillFlag_FAIL()
  {
   Print(__FUNCTION__);
//--- Arrange
   static uchar expected[] =
     {16, 8, 0, 4, 77, 81, 84, 84, 5, 2};//last element should be 4 instead of 2 - FAIL()
   uchar buf[expected.Size() - 2];
   CPktConnect *cut = new CPktConnect(buf);
//--- Act
   cut.SetWillFlag(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = AssertNotEqual(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
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
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
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
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
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
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
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
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
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
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
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
//--- Act
   CPktConnect *cut = new CPktConnect(buf);
   cut.SetCleanStart(true);
   uchar result[];
   ArrayCopy(result, cut.m_byte_array);
//--- Assert
   bool is_true = Assert(expected, result);
//--- cleanup
   delete cut;
   ZeroMemory(result);
   return  is_true;
  }
//+------------------------------------------------------------------+
