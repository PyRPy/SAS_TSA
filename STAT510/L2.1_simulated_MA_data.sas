*Simulate n = 150 values from MA(1);;
data x;
     w1 = 0;
     do i = -50 to 100;
        w = rannor( 21 );
        x = 10 + w - .7 * w1;
		t=i;
        if i > 0 then output;
        w1 = w;
     end;
	 keep t x;
   run;
title 'Simulated MA(1) data';
proc gplot data=x;
   symbol i=spline v=circle h=2;
   plot x*t;
run;
title 'ACF for simulated sample data';
proc timeseries data=x plots=acf;
  var x;
run;

*Simulate n = 150 values from MA(2);;
data x;
  w1 = 0; w2=0;
  do i = -50 to 100;
    w = rannor( 21 );
    x = 10 + w + .5 * w1 + .3*w2;
	t=i;
    if i > 0 then output;
	w2 = w1;
    w1 = w;
  end;
  keep t x;
run;
title 'Simulated MA(2) series';
proc gplot data=x;
   symbol i=spline v=circle h=2;
   plot x*t;
run;
title 'ACF for simulated MA(2) data';
proc timeseries data=x plots=acf;
  var x;
run;