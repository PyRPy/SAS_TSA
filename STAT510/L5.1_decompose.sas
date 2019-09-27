*libname sas510 'X:\My Documents\sas\510'; 
*if you choose to permanently store any data or output from below;
data beer;
   infile 'C:\Users\Documents\My SAS Files\TS_SAS\Data\beerprod.dat' dlmstr=' ';
   input beer @@;
   t=_N_; *because we do not have dates in our data;
   if mod(_N_,4)=0 then do; qtr=4; year=1899+t/4; end; 
   else do; qtr=mod(_N_,4); year=1900+int(t/4); end;
   sasdate=mdy(qtr*3,30,year); *made up as actual dates unavailable;
   format sasdate MMDDYY10.; 
run;
proc print; run;
proc sort data=beer; by sasdate; run;
*Additive;
proc timeseries data=beer outdecomp=decomp plots=(decomp);
  id sasdate interval=qtr; 
  var beer;
  decomp / mode=add;
run;
proc sort data=decomp out=decompadd nodupkey; by _season_; run;
proc print data=decompadd label; var _season_ sc; run;
*Multiplicative;
proc timeseries data=beer outdecomp=decomp plots=(decomp);
  id sasdate interval=qtr; 
  var beer;
run;
proc sort data=decomp out=decompmult nodupkey; by _season_; run;
proc print data=decompmult label; var _season_ sc; run;




