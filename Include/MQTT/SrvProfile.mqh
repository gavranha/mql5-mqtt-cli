//+------------------------------------------------------------------+
//|                                                   SrvProfile.mqh |
//|            ********* WORK IN PROGRESS **********                 |
//| **** PART OF ARTICLE https://www.mql5.com/en/articles/13388 **** |
//+------------------------------------------------------------------+
#property copyright "JS Lopes"
#property link      "gavranha@gmail.com"
#property version   "1.00"
class CSrvProfile
  {
private:

public:
                     CSrvProfile();
                    ~CSrvProfile();
   void              Update(string serverIp, uchar &resp_buf[]);
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSrvProfile::Update(string serverIp, uchar &resp_buf[])
  {
   printf("Updating Server Profile %s", serverIp);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSrvProfile::CSrvProfile()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSrvProfile::~CSrvProfile()
  {
  }
//+------------------------------------------------------------------+
