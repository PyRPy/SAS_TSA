libname sas510 'X:\My Documents\sas\510'; *if you choose to permanently store any data or output from below;
data cortex;
   infile 'C:\Users\Documents\My SAS Files\TS_SAS\Data\cortex.dat' dlmstr=' ';
   input cortex @@;
   second=2*_N_; *because we do not have dates in our data;
   format second mmss.; 
run;
proc print; run;
proc sgplot data=cortex;
  series x=second y=cortex / markers markerattrs=(symbol=circlefilled);
run;
proc spectra data=cortex out=cortexP p;
  var cortex;
run;
proc means data=cortexP max; var p_01; run;
proc print data=cortexP; where p_01 > 14; run;
proc sgplot data=cortexP;
  series x=freq y=p_01;
  refline .19635 / axis = x;
run;

data sunspots;
   infile 'C:\Users\Documents\My SAS Files\TS_SAS\Data\sunspots.dat' dlmstr=' ';
   input sunspots @@;
   t=_N_;
   lag1=lag(sunspots);
   x=sunspots-lag1;
run;
proc print; run;
proc sgplot data=sunspots;
  series x=t y=sunspots / markers markerattrs=(symbol=circlefilled);
run;
proc spectra data=sunspots out=sunP p;
  var x;
run;
proc means data=sunP max; var p_01; run;
proc print data=sunP; where p_01 > 12900; run;
proc sgplot data=sunP;
  series x=freq y=p_01;
  refline .31553 / axis = x;
run;








