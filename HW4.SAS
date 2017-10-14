
/** Create a data set containing the required output for the homework requirements **/
data title;
	input Title $20.;
	datalines;
	Jeremiah Lowhorn
	SAS Homework 4
	6/28/2017
	Version 1
 	;
run;


/**Create a report for the output of the table. **/
proc report data=title nowd noheader style(report)={rules=none frame=void} 
     style(column)={font_weight=bold font_size=20pt just=c};
     format Title $20.;
run;

/**Import the sales.csv file**/
PROC IMPORT DATAFILE='/home/jeremiahlowhorn0/sasuser.v94/STAT 700/Week 4/Data/sales.csv'
		    OUT=WORK.sales
		    DBMS=CSV
		    REPLACE;
RUN;

/** Print the results--set obs=5. **/
PROC PRINT DATA=WORK.sales (obs=5);
title "Exercise 1";
 RUN;
 
/**Data step, create sales 2 by setting it equal to WORK.sales.
Format Birth_Date, Hire_Date, and Salary to date currency formats.
Set age_at_hiring equal to the truncated value of Hire_Date-Birthdate over 365.25.
 **/
DATA sales2;
SET WORK.sales;
format Birth_Date Hire_Date mmddyy10. Salary dollar10.2;
age_at_hiring = int((Hire_Date - Birth_Date)/365.25);
RUN;

/**Print the first 5 observations of the sales 2 data set**/
proc print data=sales2(obs=5);
title 'Exercise 2 & 3';
run; 

/**Create the sales3 data set keeping only Employee_ID, Salary, and age_at_hiring**/
/**Rename age_at_hiring to Age for the requested homework output**/
data sales3;
set sales2;
Keep Employee_ID Salary age_at_hiring;
rename age_at_hiring = Age;
run;

/**Print the first 5 observations of the sales3 data set.**/
proc print data=sales3(obs=5);
title 'Exercise 4';
run;

