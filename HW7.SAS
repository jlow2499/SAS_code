/*
First we will build a table using proc sql to determine what our ouput will need to be for the assignment
I am building a table here first because conceptually it is easier for me to understand and helped me sole the
desired solution.

Write  macro with the Data, GroupVar and CountVar arguments. Select the distinct groupVar (Type) and 
count the distinct values of the countVar (Model). Group by the groupVar (Type) for the desired result in
the table
*/
%Macro aggregate(Data, GroupVar = Type, CountVar = Model);
proc sql;
	
	select distinct &GroupVar, count(distinct &CountVar) as Distinct_&CountVar.s
	from &data group by &GroupVar;
	quit;
%mend aggregate;   

options symbolgen;
%aggregate(sashelp.Cars, GroupVar = Type, CountVar = Model);

/*After examining the table in the ouput we now know what our intended results need to be.
Use a proc sql statement to slect the Type and count of the model into the macro variables types1-types6 and count1 - count6
grouping by Type.

Create a macro with a do loop to iterate throught the count1-count6 macro variables putting the type and count
of the distinct Models by Type. 
*/

proc sql noprint;
   select distinct Type, count(Model)
      into :types1 - :types6 notrim, :count1 - :count6
            from sashelp.Cars group by Type;

%macro putit;
   %do i=1 %to 6;
      %put Type=**&&types&i** Count=**&&count&i**;
   %end;
%mend putit;
%putit



/*
 This problem is easily solved by changing the while loop to an until loop. The previous state of the macro
 looped through the string until it ended (until an empty string was encountered). Rather than looping to 
 the end we want the first occurence thus %until will accomplish this because the macro will loop until 
 it reaches the desired word. 
 */

%macro revscan(list, word);
   %local wcnt wnum;
   %
   %let wcnt=0;
   %let wnum=0;
   %do %until(%scan(&list,%eval(&wcnt+1),%str( )) =&word); /*1*/
      %let wcnt = %eval(&wcnt+1);
      %if %upcase(%scan(&list,&wcnt,%str( )))=%upcase(&word) %then
         %let wnum=&wcnt;
   %end;
   &wnum /*2*/
%mend revscan;

/*(1)the %DO %WHILE statement is used to step through the list (&LIST) using the 
	%SCAN function. We scan the list while the selected word is not blank.
	Once the word is found the word position is passed back(2)*/

/*%str( ) resolves to one blank*/

/*it will help to look up the syntax of these functions*/

/*if you are new to macro functions it may be helpful to write the code out as it 
	would resolve to visually see what is happening*/


%put fish is at position %REVSCAN(one Fish two fish, fish);


