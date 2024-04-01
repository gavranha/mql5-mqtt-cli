//+------------------------------------------------------------------+
//|                                             mqtt_pub_service.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <MQTT\MQTT.mqh>
#include <MQTT\Connect.mqh>
#include <MQTT\Publish.mqh>

#property service

//--- input parameters
input string   host = "172.20.106.92";
input int      port = 80;
//---
int skt;
//+------------------------------------------------------------------+
//| Service program start function                                   |
//+------------------------------------------------------------------+
int OnStart()
  {
   Print(__FILE__ + " : " + __FUNCTION__);
   Print("MQTT Publish Service started");
//---
   uchar conn_pkt[];
   CConnect *conn = new CConnect(host, port);
   conn.SetCleanStart(true);
   conn.SetKeepAlive(3600);
   conn.SetClientIdentifier("MT5_PUB");
   conn.Build(conn_pkt);
   ArrayPrint(conn_pkt);
//---
   if(SendConnect(host, port, conn_pkt) == 0)
     {
      Print("Client connected ", host);
     }
   do
     {
      uchar pub_pkt[];
      CPublish *pub = new CPublish();
      pub.SetTopicName("MyBITCOIN");
      string payload = GetRates();
      pub.SetPayload(payload);
      pub.Build(pub_pkt);
      delete(pub);
      ArrayPrint(pub_pkt);
      if(!SendPublish(pub_pkt))
        {
         return -1;
         delete(conn);
         SocketClose(skt);
        }
      ZeroMemory(pub_pkt);
      Sleep(5000);
     }
   while(!IsStopped());
//---
   delete(conn);
   SocketClose(skt);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetRates()
  {
   MqlRates rates[];
   int copied = CopyRates("BITCOIN", PERIOD_M1, 0, 1, rates);
   if(copied > 0)
     {
      Print("Bars copied: " + (string)copied);
      string format = "%G-%G-%G-%G-%d-%d";
      string out;
      out = TimeToString(rates[0].time);
      out += "-"+StringFormat(format,
                          rates[0].open,
                          rates[0].high,
                          rates[0].low,
                          rates[0].close,
                          rates[0].tick_volume,
                          rates[0].real_volume);
      //out = TimeToString(rates[0].time);
      //out += "-" + DoubleToString(rates[0].open, 2);
      //out += "-" + DoubleToString(rates[0].high, 2);
      //out += "-" + DoubleToString(rates[0].low, 2);
      //out += "-" + DoubleToString(rates[0].close, 2);
      //out += "-" + DoubleToString(rates[0].tick_volume, 2);
      //out += "-" + DoubleToString(rates[0].real_volume, 2);
      Print(out);
      return out;
     }
   else
      Print("Failed to get rates for BITCOIN");
   return "";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SendPublish(uchar &pkt[])
  {
   if(skt == INVALID_HANDLE || SocketSend(skt, pkt, ArraySize(pkt)) < 0)
     {
      Print("Failed sending publish ", GetLastError());
      SocketClose(skt);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SendConnect(const string h, const int p, uchar &pkt[])
  {
   skt = SocketCreate();
   if(skt != INVALID_HANDLE)
     {
      if(SocketConnect(skt, h, p, 1000))
        {
         Print("Socket Connected ", h);
        }
     }
   if(SocketSend(skt, pkt, ArraySize(pkt)) < 0)
     {
      Print("Failed sending connect ", GetLastError());
     }
//---
   char rsp[];
   SocketRead(skt, rsp, 4, 1000);
   if(rsp[0] >> 4 != CONNACK)
     {
      Print("Not Connect acknowledgment");
      return -1;
     }
   if(rsp[3] != MQTT_REASON_CODE_SUCCESS)  // Connect Return code (Connection accepted)
     {
      Print("Connection Refused");
      return -1;
     }
   ArrayPrint(rsp);
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteToChart(datetime t, double o, double l, double h, double c, long v, long m = 0)
  {
   MqlRates r[1];
   r[0].time = t;
   r[0].open = o;
   r[0].low = l;
   r[0].high = h;
   r[0].close = c;
   r[0].tick_volume = v;
   r[0].spread = 0;
   r[0].real_volume = m;
   if(CustomRatesUpdate("MyBITCOIN", r) < 1)
     {
      Print("CustomRatesUpdate failed: ", _LastError);
     }
  }
//+------------------------------------------------------------------+
