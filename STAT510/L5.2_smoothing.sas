* libname sas510 'X:\My Documents\sas\510'; 
*if you choose to permanently store any data or output from below;
data beer;
   infile 'C:\Users\Documents\My SAS Files\TS_SAS\Data\beerprod.dat' dlmstr=' ';
   input beer @@;
   t=_N_; *because we do not have dates in our data;
   if mod(_N_,4)=0 then do; qtr=4; year=1899+t/4; end; else do; qtr=mod(_N_,4); year=1900+int(t/4); end;
   sasdate=mdy(qtr*3,30,year); *made up as actual dates unavailable;
   format sasdate MMDDYY10.; 
run;
proc print; run;
proc sort data=beer; by sasdate; run;
proc expand data=beer out=beerma method=none plots=all;
   id sasdate;
   convert beer = trendpattern   / transformout=( cmovave( .125 .25 .25 .25 .125 ) );
run;
data beerma;
  set beerma;
  seasonals=beer-trendpattern;
run;
title "Seasonal Pattern for Beer Production";
axis1 label=(angle=90 justify=left "Seasonals");
proc gplot data=beerma; 
  plot seasonals*t / vaxis=axis1;
  symbol v=dot i=join;
run; quit;

proc expand data=beer out=beerma method=none plots=all;
   id sasdate;
   convert beer = trendpattern   / transformout=( cmovave 4 );
run;
*Unemployment dataset;
data unemploy;
   infile 'C:\Users\Documents\My SAS Files\TS_SAS\Data\unemp.dat' dlmstr=' ';
   input unemploy @@;
   if mod(_N_,12)=0 then do; month=12; year=1947+_N_/12; end; 
   else do; month=mod(_N_,12); year=1948+int(_N_/12); end;
   sasdate=mdy(month,1,year); *actual dates available in Lesson 5.2 not stored in .dat file;
   format sasdate MMDDYY10.; 
run;
proc print data=unemploy;run;
title "Trend in U.S. Unemployment, 1948-1978";
proc expand data=unemploy out=unempma method=none plots=all;
   id sasdate;
   convert unemploy = trendpattern   / transformout=( cmovave (.04166667 .08333333 .08333333 .08333333 .08333333 
.08333333 .08333333 .08333333 .08333333 .08333333 .08333333 .08333333 .04166667 ) );
run;

title "Loess Smoothing of U.S. Unemployment, 1948-1978";
proc loess data=unemploy;
   model unemploy = sasdate / smooth=.667;
run;

data oilindex;
   infile 'C:\Users\Documents\My SAS Files\TS_SAS\Data\oildata.dat' dlmstr=' ';
   input oilindex @@;
   t=_N_;
run;
proc arima data=oilindex plots=forecast(forecast);
  identify var=oilindex(1);
  estimate q=1;
  forecast lead=1 id=t out=forecast;
  *check forecast t=4:  .0087161484+1.30756*.00076-.30756*.0060353896;
run; quit;





