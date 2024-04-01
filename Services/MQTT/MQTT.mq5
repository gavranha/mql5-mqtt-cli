//+------------------------------------------------------------------+
//|                                                         MQTT.mq5 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property service

//--- input parameters
input string   broker_host = "172.20.106.92";
input int      broker_port = 80;
//+------------------------------------------------------------------+
//| Service program start function                                   |
//+------------------------------------------------------------------+
void OnStart()
  {
   Print(__FUNCTION__);
   Print("MQTT Service started");

   uchar arr[];
   struct MyStruct
     {
      MqlRates       r;
     } my;
   MyStruct mys[];
   CharArrayToStruct(my, arr);
   
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
