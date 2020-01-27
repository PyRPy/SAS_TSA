libname sas510 'X:\My Documents\sas\510'; *if you choose to permanently store any data or output from below;
data flu;
   infile 'X:\My Documents\sas\510\flu.dat' dlmstr=' ';
   input flu @@;
   t=_n_;
run;
title "TS Plot";
proc sgplot data=flu;
  series x=t y=flu / markers markerattrs=(symbol=circlefilled);
run;
title "Plots of First Differences"; 
proc timeseries data=flu plot=(series acf) out=flu1; 
  var flu / dif=1;
run;
data flu1;
   set flu1;
   lag1=lag(flu);
   lag2=lag2(flu);
   lag3=lag3(flu);
   lag4=lag4(flu);
run;
title "Below Threshold";
proc reg data=flu1;
  model flu = lag1 lag2 lag3 lag4/ r;
  output out=below r=residuals;
  where lag1 < .05 & . < lag4;
run; quit;
title "Above Threshold";
proc reg data=flu1;
  model flu = lag1 lag2 lag3 lag4/ r;
  output out=above r=residuals;
  where lag1 >= .05;
run; quit;
data res;
  set above below;
run;
proc sort data=res; by time; run;
title "ACF of Residuals";
proc timeseries data=res plots=acf;
  var residuals;
run;










