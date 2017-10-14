/*
 * Import the Michelso data into SAS. 
 */

FILENAME REFFILE '/home/jeremiahlowhorn0/sasuser.v94/STAT 700/Week 8/michelso.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=Michelso;
	GETNAMES=YES;
RUN;

/*
 * Plot the Michelso data to a histogram. Set the nbins option equal to 16
 * Set the X Axis and Title labels for the plot. 
 */
proc sgplot data=Michelso;
  histogram Y /
  nbins=16;
  XAxis Label = "Millions of meters per second";
  Title "Michelso Speed of Light";
run;

/*
 * Import the AtmWtAg file into SAS. 
 */

FILENAME REFFILE2 '/home/jeremiahlowhorn0/sasuser.v94/STAT 700/Week 8/AtmWtAg.csv';
PROC IMPORT DATAFILE=REFFILE2
	DBMS=CSV
	OUT=AtmWtAg;
	GETNAMES=YES;
RUN;

/*
 * Create a scatter plot of the data setting Instrument to the X axis and AgWt to the Y Axis. 
 * Set the labels for the Title, X Axis, and Y Axis. 
 */

proc sgplot data=AtmWtAg;
	scatter X=Instrument Y=AgWt;
	Title "Atomic Ag Weight vs Instrument";
	XAxis label = "Instrument";
	YAxis Label = "Atomic Weight of Ag";
run;

/*
 * Load the Filip dataset into SAS after cleaning with R. 
 */

FILENAME REFFILE '/home/jeremiahlowhorn0/sasuser.v94/STAT 700/Week 8/Filip.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=Filip;
	GETNAMES=YES;
RUN;

/*
 * Create a scatter plot for the Filip data set with X=X, Y=Y and labels for the Title, X, and Y Axises. 
 * 
 */

proc sgplot data = Filip;
	scatter X=X Y=Y;
	Title "Filip Y vs X";
	XAxis Label = "X";
	YAxis Label = "Y";
run;
