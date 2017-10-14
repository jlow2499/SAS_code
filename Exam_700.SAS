/*Data*/

data stavwood;

input group y x1 x2 x3;

datalines;

12 0.6 3.4 1.0 2.2

12 0.4 1.8 1.9 1.2

12 0.6 3.1 1.0 2.3

12 0.8 0.2 3.3 5.0

12 3.6 1.2 3.6 3.7

12 1.2 2.4 1.8 1.0

12 8.1 3.0 4.1 6.3

12 6.0 6.4 4.2 7.8

12 5.5 5.0 3.1 4.0

12 2.8 1.4 6.0 5.0

12 4.7 0.9 6.7 2.0

12 3.4 0.3 6.3 6.2

12 5.0 3.7 3.3 5.4

12 2.2 0.2 5.2 7.9

12 5.6 1.1 4.9 6.4

12 6.4 7.7 5.5 5.9

12 5.0 4.8 5.8 6.2

12 6.0 4.6 6.5 6.2

12 0.7 2.0 1.1 1.0

12 1.6 3.6 1.1 2.2

12 5.0 1.6 2.6 3.7

24 0.5 1.0 0.8 2.4

24 4.6 3.1 2.9 1.0

24 1.8 4.7 3.1 1.6

24 4.5 0.4 4.6 6.0

24 6.0 2.8 6.1 0.9

24 5.0 1.2 5.7 2.2

24 7.5 1.9 4.1 5.1

24 5.0 7.6 5.0 6.6

24 6.6 2.1 3.4 5.6

24 7.8 3.7 5.7 1.7

24 8.9 5.2 6.9 5.7

24 8.0 5.4 7.3 4.3

24 5.0 5.0 5.9 9.1

24 3.7 0.3 8.1 3.6

24 9.9 3.5 6.5 9.2

24 6.3 4.7 7.5 4.5

24 6.6 6.4 6.9 6.1

24 6.8 5.1 4.3 6.8

24 4.0 2.6 2.5 6.5

24 3.3 1.3 0.3 3.0

24 9.5 3.1 6.6 4.4

;

run;

/*
 * Create a SAS macro named exam with th arguments data, xvar, and yvvar. 
 */

%macro exam(data, xvar=, yvar=);
 
 
proc sql;

/*
 * Select the mean of the yvar into a SAS macro variable named vertline from the stavwood dataset.
 */

select mean(&yvar) into: vertline
from &data;
quit;

/*
 * Use PROC GPLOT on the data set plotting the x variable * the y variable and setting the vref option to the vertline 
 * macro variable
 */

PROC GPLOT data=&data;
plot &xvar * &yvar/vref=&vertline;
Title "Plot of &xvar * &yvar";
run;
quit;
%mend exam;

/*
 * Run the x1,x2, and x3 variables through the exam macro. 
 */

options symbolgen;
%exam(stavwood, xvar = x1, yvar = y);
%exam(stavwood, xvar = y, yvar = x1);
%exam(stavwood, xvar = x2, yvar = y);
%exam(stavwood, xvar = x3, yvar = y);
