libname sas510 'X:\My Documents\sas\510'; *if you choose to permanently store any data or output from below;
data xerie;
   infile 'C:\Users\Documents\My SAS Files\TS_SAS\Data\eriedata.dat' dlmstr=' ';
   input level @@;
   t=_N_; *because we do not have dates in our data;
run;
proc print;
run;
title "Plot of Lake Erie Levels";
proc gplot data=xerie;
   symbol i=spline v=circle h=2;
   plot level*t;
run;
title "ACF/PACF of Lake Erie Levels";
proc timeseries data=xerie plots=(acf pacf);
  var level;
run;
title "ARIMA(1,0,0)";
proc arima data=xerie;
  identify var=level;
  estimate p=1;
  *SAS provides both the mean (MU) and the intercept (Constant);
run; quit;
title "ARIMA(0,0,1)";
proc arima data=xerie;
  identify var=level;
  estimate q=1;
  *SAS defines the MA polynomial with negative signs rather than positive;
  *signs.  This changes the algebraic signs of the MA coefficients from R;
  *MA(1) polynomial is 1 - ?1B.;
run; quit;
title "ARIMA(1,0,1)"; * AIC is larger than ARIMA(1,0,0)
proc arima data=xerie;
  identify var=level;
  estimate p=1 q=1;
run; quit;
title "4 Forecasts from ARIMA(1,0,0)";
proc arima data=xerie;
  identify var=level;
  estimate p=1;
  forecast lead=4 id=t out=forecasts;
run; quit;




