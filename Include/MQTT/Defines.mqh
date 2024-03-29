//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/14391 **** |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|              PROTOCOL NAME AND VERSION                           |
//+------------------------------------------------------------------+
#define MQTT_PROTOCOL_NAME_LENGTH_MSB           0x00
#define MQTT_PROTOCOL_NAME_LENGTH_LSB           0x04
#define MQTT_PROTOCOL_NAME_BYTE_3               'M'
#define MQTT_PROTOCOL_NAME_BYTE_4               'Q'
#define MQTT_PROTOCOL_NAME_BYTE_5               'T'
#define MQTT_PROTOCOL_NAME_BYTE_6               'T'
#define MQTT_PROTOCOL_VERSION                   0x05
#define MQTT_PROTOCOL_VERSION_COMPAT            0x04
//+------------------------------------------------------------------+
//|              PROPERTIES                                          |
//+------------------------------------------------------------------+
/*
The last field in the Variable Header of the CONNECT, CONNACK, PUBLISH, PUBACK, PUBREC,
PUBREL, PUBCOMP, SUBSCRIBE, SUBACK, UNSUBSCRIBE, UNSUBACK, DISCONNECT, and
AUTH packet is a set of Properties. In the CONNECT packet there is also an optional set of Properties in
the Will Properties field with the Payload
*/
#define MQTT_PROP_IDENTIFIER_PAYLOAD_FORMAT_INDICATOR          0x01 // (1) Byte                  
#define MQTT_PROP_IDENTIFIER_MESSAGE_EXPIRY_INTERVAL           0x02 // (2) Four Byte Integer     
#define MQTT_PROP_IDENTIFIER_CONTENT_TYPE                      0x03 // (3) UTF-8 Encoded String  
#define MQTT_PROP_IDENTIFIER_RESPONSE_TOPIC                    0x08 // (8) UTF-8 Encoded String  
#define MQTT_PROP_IDENTIFIER_CORRELATION_DATA                  0x09 // (9) Binary Data           
#define MQTT_PROP_IDENTIFIER_SUBSCRIPTION_IDENTIFIER           0x0B // (11) Variable Byte Integer
#define MQTT_PROP_IDENTIFIER_SESSION_EXPIRY_INTERVAL           0x11 // (17) Four Byte Integer    
#define MQTT_PROP_IDENTIFIER_ASSIGNED_CLIENT_IDENTIFIER        0x12 // (18) UTF-8 Encoded String  
#define MQTT_PROP_IDENTIFIER_SERVER_KEEP_ALIVE                 0x13 // (19) Two Byte Integer      
#define MQTT_PROP_IDENTIFIER_AUTHENTICATION_METHOD             0x15 // (21) UTF-8 Encoded String 
#define MQTT_PROP_IDENTIFIER_AUTHENTICATION_DATA               0x16 // (22) Binary Data          
#define MQTT_PROP_IDENTIFIER_REQUEST_PROBLEM_INFORMATION       0x17 // (23) Byte                  
#define MQTT_PROP_IDENTIFIER_WILL_DELAY_INTERVAL               0x18 // (24) Four Byte Integer    
#define MQTT_PROP_IDENTIFIER_REQUEST_RESPONSE_INFORMATION      0x19 // (25) Byte                  
#define MQTT_PROP_IDENTIFIER_RESPONSE_INFORMATION              0x1A // (26) UTF-8 Encoded String  
#define MQTT_PROP_IDENTIFIER_SERVER_REFERENCE                  0x1C // (28) UTF-8 Encoded String 
#define MQTT_PROP_IDENTIFIER_REASON_STRING                     0x1F // (31) UTF-8 Encoded String
#define MQTT_PROP_IDENTIFIER_RECEIVE_MAXIMUM                   0x21 // (33) Two Byte Integer     
#define MQTT_PROP_IDENTIFIER_TOPIC_ALIAS_MAXIMUM               0x22 // (34) Two Byte Integer     
#define MQTT_PROP_IDENTIFIER_TOPIC_ALIAS                       0x23 // (35) Two Byte Integer     
#define MQTT_PROP_IDENTIFIER_MAXIMUM_QOS                       0x24 // (36) Byte                 
#define MQTT_PROP_IDENTIFIER_RETAIN_AVAILABLE                  0x25 // (37) Byte                 
#define MQTT_PROP_IDENTIFIER_USER_PROPERTY                     0x26 // (38) UTF-8 String Pair   
#define MQTT_PROP_IDENTIFIER_MAXIMUM_PACKET_SIZE               0x27 // (39) Four Byte Integer    
#define MQTT_PROP_IDENTIFIER_WILDCARD_SUBSCRIPTION_AVAILABLE   0x28 // (40) Byte                  
#define MQTT_PROP_IDENTIFIER_SUBSCRIPTION_IDENTIFIER_AVAILABLE 0x29 // (41) Byte                  
#define MQTT_PROP_IDENTIFIER_SHARED_SUBSCRIPTION_AVAILABLE     0x2A // (42) Byte 
//+------------------------------------------------------------------+
//|              REASON CODES                                        |
//+------------------------------------------------------------------+
/*
A Reason Code is a one byte unsigned value that indicates the result of an operation. Reason Codes less
than 0x80 indicate successful completion of an operation. The normal Reason Code for success is 0.
Reason Code values of 0x80 or greater indicate failure.

The CONNACK, PUBACK, PUBREC, PUBREL, PUBCOMP, DISCONNECT and AUTH Control Packets
have a single Reason Code as part of the Variable Header. The SUBACK and UNSUBACK packets
contain a list of one or more Reason Codes in the Payload.
*/
#define MQTT_REASON_CODE_SUCCESS                                0x00 // (0)
#define MQTT_REASON_CODE_NORMAL_DISCONNECTION                   0x00 // (0)
#define MQTT_REASON_CODE_GRANTED_QOS_0                          0x00 // (0)
#define MQTT_REASON_CODE_GRANTED_QOS_1                          0x01 // (1)
#define MQTT_REASON_CODE_GRANTED_QOS_2                          0x02 // (2)
#define MQTT_REASON_CODE_DISCONNECT_WITH_WILL_MESSAGE           0x04 // (4)
#define MQTT_REASON_CODE_NO_MATCHING_SUBSCRIBERS                0x10 // (16)
#define MQTT_REASON_CODE_NO_SUBSCRIPTION_EXISTED                0x11 // (17)
#define MQTT_REASON_CODE_CONTINUE_AUTHENTICATION                0x18 // (24)
#define MQTT_REASON_CODE_RE_AUTHENTICATE                        0x19 // (25)
#define MQTT_REASON_CODE_UNSPECIFIED_ERROR                      0x80 // (128)
#define MQTT_REASON_CODE_MALFORMED_PACKET                       0x81 // (129)
#define MQTT_REASON_CODE_PROTOCOL_ERROR                         0x82 // (130)
#define MQTT_REASON_CODE_IMPLEMENTATION_SPECIFIC_ERROR          0x83 // (131)
#define MQTT_REASON_CODE_UNSUPPORTED_PROTOCOL_VERSION           0x84 // (132)
#define MQTT_REASON_CODE_CLIENT_IDENTIFIER_NOT_VALID            0x85 // (133)
#define MQTT_REASON_CODE_BAD_USER_NAME_OR_PASSWORD              0x86 // (134)
#define MQTT_REASON_CODE_NOT_AUTHORIZED                         0x87 // (135)
#define MQTT_REASON_CODE_SERVER_UNAVAILABLE                     0x88 // (136)
#define MQTT_REASON_CODE_SERVER_BUSY                            0x89 // (137)
#define MQTT_REASON_CODE_BANNED                                 0x8A // (138)
#define MQTT_REASON_CODE_SERVER_SHUTTING_DOWN                   0x8B // (139)
#define MQTT_REASON_CODE_BAD_AUTHENTICATION_METHOD              0x8C // (140)
#define MQTT_REASON_CODE_KEEP_ALIVE_TIMEOUT                     0x8D // (141)
#define MQTT_REASON_CODE_SESSION_TAKEN_OVER                     0x8E // (142)
#define MQTT_REASON_CODE_TOPIC_FILTER_INVALID                   0x8F // (143)
#define MQTT_REASON_CODE_TOPIC_NAME_INVALID                     0x90 // (144)
#define MQTT_REASON_CODE_PACKET_IDENTIFIER_IN_USE               0x91 // (145)
#define MQTT_REASON_CODE_PACKET_IDENTIFIER_NOT_FOUND            0x92 // (146)
#define MQTT_REASON_CODE_RECEIVE_MAXIMUM_EXCEEDED               0x93 // (147)
#define MQTT_REASON_CODE_TOPIC_ALIAS_INVALID                    0x94 // (148)
#define MQTT_REASON_CODE_PACKET_TOO_LARGE                       0x95 // (149)
#define MQTT_REASON_CODE_MESSAGE_RATE_TOO_HIGH                  0x96 // (150)
#define MQTT_REASON_CODE_QUOTA_EXCEEDED                         0x97 // (151)
#define MQTT_REASON_CODE_ADMINISTRATIVE_ACTION                  0x98 // (152)
#define MQTT_REASON_CODE_PAYLOAD_FORMAT_INVALID                 0x99 // (153)
#define MQTT_REASON_CODE_RETAIN_NOT_SUPPORTED                   0x9A // (154)
#define MQTT_REASON_CODE_QOS_NOT_SUPPORTED                      0x9B // (155)
#define MQTT_REASON_CODE_USE_ANOTHER_SERVER                     0x9C // (156)
#define MQTT_REASON_CODE_SERVER_MOVED                           0x9D // (157)
#define MQTT_REASON_CODE_SHARED_SUBSCRIPTIONS_NOT_SUPPORTED     0x9E // (158)
#define MQTT_REASON_CODE_CONNECTION_RATE_EXCEEDED               0x9F // (159)
#define MQTT_REASON_CODE_MAXIMUM_CONNECT_TIME                   0xA0 // (160)
#define MQTT_REASON_CODE_SUBSCRIPTION_IDENTIFIERS_NOT_SUPPORTED 0xA1 // (161)
#define MQTT_REASON_CODE_WILDCARD_SUBSCRIPTIONS_NOT_SUPPORTED   0xA2 // (162)

//+------------------------------------------------------------------+
//|                 Variable Byte Integer Limits                     |
//+------------------------------------------------------------------+
/*
The maximum number of bytes in the Variable Byte Integer field is four.
The encoded value MUST use the minimum number of bytes necessary to represent the value
Size of Variable Byte Integer
Digits  From                               To
1       0 (0x00)                           127 (0x7F)
2       128 (0x80, 0x01)                   16,383 (0xFF, 0x7F) => (255,127)
3       16,384 (0x80, 0x80, 0x01)          2,097,151 (0xFF, 0xFF, 0x7F)
4       2,097,152 (0x80, 0x80, 0x80, 0x01) 268,435,455 (0xFF, 0xFF, 0xFF, 0x7F)
*/
#define VARINT_MIN_ONE_BYTE      0x00        // (0)
#define VARINT_MAX_ONE_BYTE      0x7F        // (127)
#define VARINT_MIN_TWO_BYTES     0x80        // (128)
#define VARINT_MAX_TWO_BYTES     0x3FFF      // (16,383)
#define VARINT_MIN_THREE_BYTES   0x4000      // (16,384)
#define VARINT_MAX_THREE_BYTES   0x1FFFFF    // (2,097,151)
#define VARINT_MIN_FOUR_BYTES    0x200000    // (2,097,152)
#define VARINT_MAX_FOUR_BYTES    0xFFFFFFF   // (268,435,455)

//+------------------------------------------------------------------+
//|                 Disconnect Reason Codes                          |
//+------------------------------------------------------------------+

#define MQTT_DISCONN_REASON_CODE_NORMAL_DISCONNECTION                        0x00    // (0)
#define MQTT_DISCONN_REASON_CODE_DISCONNECT_WITH_WILL_MESSAGE                0x04    // (4)
#define MQTT_DISCONN_REASON_CODE_UNSPECIFIED_ERROR                           0x80    // (128)
#define MQTT_DISCONN_REASON_CODE_MALFORMED_PACKET                            0x81    // (129)
#define MQTT_DISCONN_REASON_CODE_PROTOCOL_ERROR                              0x82    // (130)
#define MQTT_DISCONN_REASON_CODE_IMPLEMENTATION_SPECIFIC_ERROR               0x83    // (131)
#define MQTT_DISCONN_REASON_CODE_NOT_AUTHORIZED                              0x87    // (135)
#define MQTT_DISCONN_REASON_CODE_SERVER_BUSY                                 0x89    // (137)
#define MQTT_DISCONN_REASON_CODE_SERVER_SHUTTING_DOWN                        0x8B    // (139)
#define MQTT_DISCONN_REASON_CODE_KEEP_ALIVE_TIMEOUT                          0x8D    // (141)
#define MQTT_DISCONN_REASON_CODE_SESSION_TAKEN_OVER                          0x8E    // (142)
#define MQTT_DISCONN_REASON_CODE_TOPIC_FILTER_INVALID                        0x8F    // (143)
#define MQTT_DISCONN_REASON_CODE_TOPIC_NAME_INVALID                          0x90    // (144)
#define MQTT_DISCONN_REASON_CODE_RECEIVE_MAXIMUM_EXCEEDED                    0x93    // (147)
#define MQTT_DISCONN_REASON_CODE_TOPIC_ALIAS_INVALID                         0x94    // (148)
#define MQTT_DISCONN_REASON_CODE_PACKET_TOO_LARGE                            0x95    // (149)
#define MQTT_DISCONN_REASON_CODE_MESSAGE_RATE_TOO_HIGH                       0x96    // (150)
#define MQTT_DISCONN_REASON_CODE_QUOTA_EXCEEDED                              0x97    // (151)
#define MQTT_DISCONN_REASON_CODE_ADMINISTRATIVE_ACTION                       0x98    // (152)
#define MQTT_DISCONN_REASON_CODE_PAYLOAD_FORMAT_INVALID                      0x99    // (153)
#define MQTT_DISCONN_REASON_CODE_RETAIN_NOT_SUPPORTED                        0x9A    // (154)
#define MQTT_DISCONN_REASON_CODE_QOS_NOT_SUPPORTED                           0x9B    // (155)
#define MQTT_DISCONN_REASON_CODE_USE_ANOTHER_SERVER                          0x9C    // (156)
#define MQTT_DISCONN_REASON_CODE_SERVER_MOVED                                0x9D    // (157)
#define MQTT_DISCONN_REASON_CODE_SHARED_SUBSCRIPTIONS_NOT_SUPPORTED          0x9E    // (158)
#define MQTT_DISCONN_REASON_CODE_CONNECTION_RATE_EXCEEDED                    0x9F    // (159)
#define MQTT_DISCONN_REASON_CODE_MAXIMUM_CONNECT_TIME                        0xA0    // (160)
#define MQTT_DISCONN_REASON_CODE_SUBSCRIPTION_IDENTIFIERS_NOT_SUPPORTED      0xA1    // (161)
#define MQTT_DISCONN_REASON_CODE_WILDCARD_SUBSCRIPTIONS_NOT_SUPPORTED        0xA2    // (162)

#define MQTT_AUTH_REASON_CODE_SUCCESS                 0x00 // (0)
#define MQTT_AUTH_REASON_CODE_CONTINUE_AUTHENTICATION 0x18 // (24)
#define MQTT_AUTH_REASON_CODE_RE_AUTHENTICATE         0x19 // (25)

//+------------------------------------------------------------------+
//|                 Subscription Options                             |
//+------------------------------------------------------------------+
#define MQTT_SUB_OPTS_QoS_0               = 0x00;
#define MQTT_SUB_OPTS_QoS_1               = 0x01;
#define MQTT_SUB_OPTS_QoS_2               = 0x02;
#define MQTT_SUB_OPTS_NON_LOCAL           = 0x04;
#define MQTT_SUB_OPTS_RETAIN_AS_PUBLISHED = 0x08;
#define MQTT_SUB_OPTS_RETAIN_HANDLING_0   = 0x00;
#define MQTT_SUB_OPTS_RETAIN_HANDLING_1   = 0x10;
#define MQTT_SUB_OPTS_RETAIN_HANDLING_2   = 0x20;
