data phleb;
input Animal Treatment Time Y;
datalines;
1	1	0	-0.3
1	1	30	-0.2
1	1	60	1.2
1	1	90	3.1
2	1	0	-0.5
2	1	30	2.2
2	1	60	3.3
2	1	90	3.7
3	1	0	-1.1
3	1	30	2.4
3	1	60	2.2
3	1	90	2.7
4	1	0	1
4	1	30	1.7
4	1	60	2.1
4	1	90	2.5
5	1	0	-0.3
5	1	30	0.8
5	1	60	0.6
5	1	90	0.9
6	2	0	-1.1
6	2	30	-2.2
6	2	60	0.2
6	2	90	0.3
7	2	0	-1.4
7	2	30	-0.2
7	2	60	-0.5
7	2	90	-0.1
8	2	0	-0.1
8	2	30	-0.1
8	2	60	-0.5
8	2	90	-0.3
9	2	0	-0.2
9	2	30	0.1
9	2	60	-0.2
9	2	90	0.4
10	2	0	-0.1
10	2	30	-0.2
10	2	60	0.7
10	2	90	-0.3
11	3	0	-1.8
11	3	30	0.2
11	3	60	0.1
11	3	90	0.6
12	3	0	-0.5
12	3	30	0
12	3	60	1
12	3	90	0.5
13	3	0	-1
13	3	30	-0.3
13	3	60	-2.1
13	3	90	0.6
14	3	0	0.4
14	3	30	0.4
14	3	60	-0.7
14	3	90	-0.3
15	3	0	-0.5
15	3	30	0.9
15	3	60	-0.4
15	3	90	-0.3
;
run;
proc print data=phleb;
run;
proc mixed data= phleb;
class Treatment Time Animal;
title 'Unstructured';
model Y = Treatment Time Treatment*Time / ddfm=kr outpm=outmixed;
repeated Time / subject=Animal type=un rcorr;
run; 
proc mixed data= phleb;
title 'Compound symmetry'; 
class Treatment Time Animal;
model Y = Treatment Time Treatment*Time / ddfm=kr outp=outmixed residual;
repeated Time / subject=Animal type=cs rcorr;
run; 
proc mixed data= phleb;
class Treatment Time Animal;
title 'AR lag 1';
model Y = Treatment Time Treatment*Time  / ddfm=kr outp=outmixed residual;
repeated Time / subject=Animal type=ar(1) rcorr;
run;

*SAS uses the well-known formula for AIC:
2k-2ln(L)
where k is the number of free parameters in the model.  With compound symmetry, k=2.  
R adds the rank of the variance-covariance matrix to k.  
In question 1 on the assignment this is 9, so you will see that the information 
criterion differ by 2*9=18 between SAS and R for each model.  
Because this is constant across all models, it is not problematic, but worth being 
aware of.
;
