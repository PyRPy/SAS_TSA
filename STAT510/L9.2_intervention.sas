data ncar;
  infile 'C:\Users\OneDrive\Documents\STAT_PSU\STAT510\SAS501\Data\ncarfatals.dat' dlmstr=' ';
  input ncar @@;
  t=_n_;
  if _n_ < 71 then spl=0; else spl=1;
run;

proc print data=ncar;
run;quit;
data before;
  set ncar;
  where spl=0;
run;
title "Time Series Plot";
proc timeseries data=ncar plots=series;
  var ncar;
run;
title "Time Series Plot"; *To vary color pre/post intervention you must use proc gplot;
data anno;                                                                                                                              
   length function color $8;                                                                                                       
   retain xsys ysys '2' when 'a';                                                                                                        
   set ncar;                                                                                                                    
                                                                                                                                        
   function='symbol';                                                                                                                    
   x=t;                                                                                                                             
   y=ncar; 
   text='dot';                                                                                                                           
                                                                                                                                        
   if t gt 70 then color='depk';                                                                                                     
   else color='vibg';                                                                                                                    
   output;                                                                                                                               
run;                                                                                                                                                                                            
proc gplot data=ncar; 
  plot ncar*t / haxis=axis1 vaxis=axis2 href=70 lhref=20 chref=grp annotate=anno;
  symbol v=dot i=join;
   axis1 label=("Time Index") offset=(2,2)pct;                                                                                     
   axis2 label=(angle=90 "NC Fatality Rate") order=(3 to 8 by 1);                                                                                              
run; quit;
proc arima data=before plots=forecast(all);
  identify var=ncar(1,12) nlag=30;
  estimate p=(1, 2)(12) noint;
  forecast lead=16 id=t out=forecasts;
run; quit;
data afterpred;
  merge forecasts ncar;
  by t;
  residual=ncar-forecast;
run;
legend1 label=none
        position=(top center inside)
        mode=share;
title "Time series plot of actual, forecasts";
proc gplot data=afterpred; 
  where spl=1;
  plot ncar*t forecast*t / overlay legend=legend1 haxis=axis1 vaxis=axis2;
  symbol v=dot i=join;
   axis1 label=("Time Index") offset=(2,2)pct;                                                                                     
   axis2 label=(angle=90 "NC Fatality Rate");                                                                                              
run; quit;
title "Time series plot of differences";
proc gplot data=afterpred; 
  where spl=1;
  plot residual*t / haxis=axis1 vaxis=axis2;
  symbol v=dot i=join;
   axis1 label=("Time Index") offset=(2,2)pct;                                                                                     
   axis2 label=(angle=90 "Differences");                                                                                              
run; quit;
proc means data=afterpred; 
var residual; where spl=1; 
run;

*SAS has the ability to include spl, the indicator function for the speed limit change, 
as an indicator variable.  This intervention analysis differs from Lesson 9.2.  It estimates 
the ARIMA model for the entire data set and provides a hypothesis test for the intervention 
effect constant mean change.  Although the fatality rate was consistently lower than expected, 
it was not significantly so;
proc arima data=ncar;
  identify var=ncar(1,12) nlag=30 crosscorr=spl;
  estimate p=(1, 2)(12) input=spl;
run; quit;
