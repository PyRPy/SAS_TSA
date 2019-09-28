libname sas510 'C:\Users\Documents\My SAS Files\TS_SAS\Data'; *if you choose to permanently store any data or output from below;
data quakes;
   infile 'C:\Users\Documents\My SAS Files\TS_SAS\Data\quakes.dat' dlmstr=' ';
   input quakes @@;
   t=_N_; *because we do not have dates in our data;
   lag1=lag(quakes);
run;
proc print;
run;
title "Plot of Quakes Data";
proc gplot data=quakes;
   symbol i=spline v=circle h=2;
   plot quakes*t;
run; quit;
title "Plot of Quakes vs. Lag 1 of Quakes";
proc gplot data=quakes;
   symbol i=none v=circle h=2;
   plot quakes*lag1;
run; quit;
title "ACF/PACF of Quakes";
proc timeseries data=quakes plots=(acf pacf);
  var quakes;
run;
title "Store Regression results";
proc reg data=quakes;
  model quakes = lag1 / r;
  output out=quakesres r=residuals;
  *plot predicted.residual.; *if you do not use the r option within the model statement;
run; quit;
title "ACF of Residuals";
proc timeseries data=quakesres plots=acf;
  var residuals;
run;

* mortality data;
data mort;
   infile 'C:\Users\Documents\My SAS Files\TS_SAS\Data\cmort.dat' dlmstr=' ';
   input cmort @@;
run;
proc print;
run;
title "Plot of Mortality Rate Data"; 
proc timeseries data=mort plot=series out=tsmort; *as an alternative to data step and proc gplot above;
  var cmort;
run;
title "Plots of Mortality Rate First Differences"; 
proc timeseries data=mort plot=(series acf) out=tsmort; 
  var cmort / dif=1;
run;
data tsmort;
  set tsmort;
  lag1=lag(cmort); *Note that cmort in tsmort are the first differences;
run;
title "Store Regression results";
proc reg data=tsmort;
  model cmort = lag1 / r;
  output out=dif1res r=residuals;
run; quit; 
title "ACF of Residuals";
proc timeseries data=dif1res plots=acf;
  var residuals;
run;






