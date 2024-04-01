//+------------------------------------------------------------------+
//|                                                       endian.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  { 
   string to_split="_life_is_good_"; // A string to split into substrings 
   string sep="_";                // A separator as a character 
   ushort u_sep;                  // The code of the separator character 
   string result[];               // An array to get strings 
   //--- Get the separator code 
   u_sep=StringGetCharacter(sep,0); 
   //--- Split the string to substrings 
   int k=StringSplit(to_split,u_sep,result); 
   //--- Show a comment  
   PrintFormat("Strings obtained: %d. Used separator '%s' with the code %d",k,sep,u_sep); 
   //--- Now output all obtained strings 
   if(k>0) 
     { 
      for(int i=0;i<k;i++) 
        { 
         PrintFormat("result[%d]=\"%s\"",i,result[i]); 
        } 
     }
  }
