//+------------------------------------------------------------------+
//|                                                         MQTT.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13651 **** |
//+------------------------------------------------------------------+
#include "Defines.mqh"
//+------------------------------------------------------------------+
//|              MQTT - CONTROL PACKET - TYPES                       |
//+------------------------------------------------------------------+
/*
Position: byte 1, bits 7-4.
Represented as a 4-bit unsigned value, the values are shown below.
*/
enum ENUM_PKT_TYPE
  {
   CONNECT     =  0x01, // Connection request
   CONNACK     =  0x02, // Connection Acknowledgment
   PUBLISH     =  0x03, // Publish message
   PUBACK      =  0x04, // Publish acknowledgment (QoS 1)
   PUBREC      =  0x05, // Publish received (QoS 2 delivery part 1)
   PUBREL      =  0x06, // Publish release (QoS 2 delivery part 2)
   PUBCOMP     =  0x07, // Publish complete (QoS 2 delivery part 3)
   SUBSCRIBE   =  0x08, // Subscribe request
   SUBACK      =  0x09, // Subscribe acknowledgment
   UNSUBSCRIBE =  0x0A, // Unsubscribe request
   UNSUBACK    =  0x0B, // Unsubscribe acknowledgment
   PINGREQ     =  0x0C, // PING request
   PINGRESP    =  0x0D, // PING response
   DISCONNECT  =  0x0E, // Disconnect notification
   AUTH        =  0x0F, // Authentication exchange
  };
//+------------------------------------------------------------------+
//|             CONNECT - VARIABLE HEADER - CONNECT FLAGS            |
//+------------------------------------------------------------------+
/*
The Connect Flags byte contains several parameters specifying the behavior of the MQTT connection. It
also indicates the presence or absence of fields in the Payload.
*/
enum ENUM_CONNECT_FLAGS
  {
   RESERVED       = 0x00,
   CLEAN_START    = 0x02,
   WILL_FLAG      = 0x04,
   WILL_QOS_1     = 0x08,
   WILL_QOS_2     = 0x10,
   WILL_RETAIN    = 0x20,
   PASSWORD_FLAG  = 0x40,
   USER_NAME_FLAG = 0x80
  };
//+------------------------------------------------------------------+
//|             CONNECT - VARIABLE HEADER - QoS LEVELS               |
//+------------------------------------------------------------------+
/*
Position: bits 4 and 3 of the Connect Flags.
These two bits specify the QoS level to be used when publishing the Will Message.
If the Will Flag is set to 0, then the Will QoS MUST be set to 0 (0x00) [MQTT-3.1.2-11].
If the Will Flag is set to 1, the value of Will QoS can be 0 (0x00), 1 (0x01), or 2 (0x02) [MQTT-3.1.2-12].
*/
enum ENUM_QOS_LEVEL
  {
   AT_MOST_ONCE   = 0x00,
   AT_LEAST_ONCE  = 0x01,
   EXACTLY_ONCE   = 0x02
  };
//+------------------------------------------------------------------+
//|                   SetProtocolVersion                             |
//+------------------------------------------------------------------+
void SetProtocolVersion(uchar& dest_buf[])
  {
   dest_buf[8] = MQTT_PROTOCOL_VERSION;
  }
//+------------------------------------------------------------------+
//|                     SetProtocolName                              |
//+------------------------------------------------------------------+
void SetProtocolName(uchar& dest_buf[])
  {
   dest_buf[2] = MQTT_PROTOCOL_NAME_LENGTH_MSB;
   dest_buf[3] = MQTT_PROTOCOL_NAME_LENGTH_LSB;
   dest_buf[4] = MQTT_PROTOCOL_NAME_BYTE_3;
   dest_buf[5] = MQTT_PROTOCOL_NAME_BYTE_4;
   dest_buf[6] = MQTT_PROTOCOL_NAME_BYTE_5;
   dest_buf[7] = MQTT_PROTOCOL_NAME_BYTE_6;
  }
//+------------------------------------------------------------------+
//|                     SetFixedHeader                               |
//+------------------------------------------------------------------+
void SetFixedHeader(ENUM_PKT_TYPE pkt_type, uchar& buf[], uchar& dest_buf[])
  {
   dest_buf[0] = (uchar)pkt_type << 4;
   dest_buf[1] = EncodeVariableByteInteger(buf);
  }
//+------------------------------------------------------------------+
//|                    EncodeVariableByteInteger                            |
//+------------------------------------------------------------------+
/*
Position: starts at byte 2.
The Remaining Length is a Variable Byte Integer that represents the number of bytes remaining within the
current Control Packet, including data in the Variable Header and the Payload. The Remaining Length
does not include the bytes used to encode the Remaining Length. The packet size is the total number of
bytes in an MQTT Control Packet, this is equal to the length of the Fixed Header plus the Remaining
Length.
*/
uchar EncodeVariableByteInteger(uchar &buf[])
  {
   uint x;
   x = ArraySize(buf);
   uint rem_len;
   do
     {
      rem_len = x % 128;
      x = (x / 128);
      if(x > 0)
        {
         rem_len = rem_len | 128;
        }
     }
   while(x > 0);
   return (uchar)rem_len;
  };

//+------------------------------------------------------------------+
uint DecodeVariableByteInteger(uint &buf[], uint idx)
  {
   uint multiplier = 1;
   uint value = 0;
   uint encodedByte;
   do
     {
      encodedByte = buf[idx];
      value += (encodedByte & 127) * multiplier;
      if(multiplier > 128 * 128 * 128)
        {
         Print("Error(Malformed Variable Byte Integer)");
         return -1;
        }
      multiplier *= 128;
     }
   while((encodedByte & 128) != 0);
   return value;
  };

//+------------------------------------------------------------------+
//MQTT_PROPERTY_PAYLOAD_FORMAT_INDICATOR          = Byte                  
//MQTT_PROPERTY_REQUEST_PROBLEM_INFORMATION       = Byte                  
//MQTT_PROPERTY_REQUEST_RESPONSE_INFORMATION      = Byte                  
//MQTT_PROPERTY_MAXIMUM_QOS                       = Byte                 
//MQTT_PROPERTY_RETAIN_AVAILABLE                  = Byte                 
//MQTT_PROPERTY_WILDCARD_SUBSCRIPTION_AVAILABLE   = Byte                  
//MQTT_PROPERTY_SUBSCRIPTION_IDENTIFIER_AVAILABLE = Byte                  
//MQTT_PROPERTY_SHARED_SUBSCRIPTION_AVAILABLE     = Byte 
//MQTT_PROPERTY_SERVER_KEEP_ALIVE                 = TwoByteInteger      
//MQTT_PROPERTY_RECEIVE_MAXIMUM                   = TwoByteInteger     
//MQTT_PROPERTY_TOPIC_ALIAS_MAXIMUM               = TwoByteInteger     
//MQTT_PROPERTY_TOPIC_ALIAS                       = TwoByteInteger     
//MQTT_PROPERTY_MESSAGE_EXPIRY_INTERVAL           = FourByteInteger     
//MQTT_PROPERTY_SESSION_EXPIRY_INTERVAL           = FourByteInteger    
//MQTT_PROPERTY_MAXIMUM_PACKET_SIZE               = FourByteInteger    
//MQTT_PROPERTY_WILL_DELAY_INTERVAL               = FourByteInteger    
//MQTT_PROPERTY_CORRELATION_DATA                  = BinaryData           
//MQTT_PROPERTY_AUTHENTICATION_DATA               = BinaryData          
//MQTT_PROPERTY_SUBSCRIPTION_IDENTIFIER           = VariableByteInteger
//MQTT_PROPERTY_CONTENT_TYPE                      = UTF-8EncodedString  
//MQTT_PROPERTY_RESPONSE_TOPIC                    = UTF-8EncodedString  
//MQTT_PROPERTY_ASSIGNED_CLIENT_IDENTIFIER        = UTF-8EncodedString  
//MQTT_PROPERTY_AUTHENTICATION_METHOD             = UTF-8EncodedString 
//MQTT_PROPERTY_RESPONSE_INFORMATION              = UTF-8EncodedString  
//MQTT_PROPERTY_SERVER_REFERENCE                  = UTF-8EncodedString 
//MQTT_PROPERTY_REASON_STRING                     = UTF-8EncodedString
//MQTT_PROPERTY_USER_PROPERTY                     = UTF-8EncodedStringStringPair   