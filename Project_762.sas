/*Declare the library ASSIGN1*/ 
LIBNAME PROJECT '/home/jeremiahlowhorn0/my_courses/INFS762/Project/';
FILENAME ORGANICS '/home/jeremiahlowhorn0/my_courses/INFS762/Project/organics.csv';

goptions reset=global
         gunit=pct
         hsize= 10.625 in
         vsize= 8.5 in
         htitle=4
         htext=3
         vorigin=0 in
         horigin= 0 in
         cback=white border
         ctext=black 
         colors=(black blue green red yellow)
         ftext=swiss
         lfactor=3;
         
%web_drop_table(PROJECT.ORGANICS);         

PROC IMPORT DATAFILE=ORGANICS
	DBMS=CSV
	OUT=PROJECT.ORGANICS;
	GETNAMES=YES;
RUN;

%web_open_table(PROJECT.ORGANICS);

DATA PROJECT.ORGANICS;
SET PROJECT.ORGANICS;
IF TargetBuy=1 THEN Target_Buy="Yes"; 
ELSE Target_Buy="No";
LENGTH I_D $ 7;
I_D = ID;
PUT I_D;
DROP DemCluster TargetAmt ID TargetBuy;
RENAME I_D = ID;
RENAME Target_Buy=TargetBuy;
RUN;

%MACRO LOWHIST(Var1,Var2,Var3,Var4);
%Let Var1 = &Var1;
%Let Var2 = &Var2;
%Let Var3 = &Var3;
%Let Var4 = &Var4;
%do i=1 %to 4;
PROC UNIVARIATE DATA = PROJECT.ORGANICS NOPRINT;
HISTOGRAM &&Var&i;
TITLE 'Histogram for' &&Var&i;
RUN;
ODS SELECT EXTREMEVALUES; 
ODS select MissingValues;
PROC UNIVARIATE Data=PROJECT.ORGANICS NEXTRVAL=10; 
VAR &&Var&i; 
RUN;
%end;
%MEND LOWHIST;

%LOWHIST(DemAffl,DemAge,PromSpend,PromTime);


DATA PROJECT.ORGANICS;
SET PROJECT.ORGANICS;
PromSpend = log(PromSpend);
RUN;

PROC UNIVARIATE DATA=PROJECT.ORGANICS NOPRINT;
HISTOGRAM PromSpend;
TITLE 'Log-Transformed Histogram of PromSpend';
RUN;


%MACRO LOWFREQ(Var1, Var2, Var3, Var4, Var5, Var6);
%Let Var1 = &Var1;
%Let Var2 = &Var2;
%Let Var3 = &Var3;
%Let Var4 = &Var4;
%Let Var5 = &Var5;
%Let Var6 = &Var6;
%do i=1 %to 6;
PROC FREQ DATA=PROJECT.ORGANICS;
TABLE &&Var&i;
TITLE "Table of" &&Var&i;
RUN;
%end;
%MEND LOWFREQ;

%LOWFREQ(DemClusterGroup,DemGender,DemReg,DemTVReg,PromClass,TargetBuy);

PROC SORT DATA=PROJECT.ORGANICS;
BY PromClass;
RUN;

PROC MEANS DATA= PROJECT.ORGANICS MEDIAN NOPRINT;
VAR DemAffl DemAge PromSpend PromTime; 
BY PromClass;
OUTPUT OUT = PROJECT.OUT MEDIAN(DemAffl)=MedAffl MEDIAN(DemAge)=MedAge MEDIAN(PromSpend)=MedSpend MEDIAN(PromTime)=MedTime;
RUN;

DATA PROJECT.ORGANICS;
SET PROJECT.ORGANICS;
MERGE PROJECT.ORGANICS PROJECT.OUT;
BY PromClass;
DemAffl = COALESCE(DemAffl,MedAffl);
DemAge = COALESCE(DemAge,MedAge);
PromSpend = COALESCE(PromSpend,MedSpend);
PromTime = COALESCE(PromTime,MedTime);
IF MISSING(DemGender) THEN DEM_GENDER="U";
ELSE DEM_GENDER=DemGender;
IF MISSING(DemClusterGroup) THEN DEMCLUST="Missing";
ELSE DEMCLUST=DemClusterGroup;
IF MISSING(DemTVReg) THEN DEMTV="Missing";
ELSE DEMTV=DemTVReg;
IF MISSING(DemReg) THEN DEM_REG="Missing";
ELSE DEM_REG=DemReg;
DROP MedAffl MedAge MedSpend MedTime DemGender DemClusterGroup DemTVReg DemReg _TYPE_ _FREQ_;
RENAME DEM_GENDER=DemGender;
RENAME DEMCLUST=DemClusterGroup;
RENAME DEMTV=DemTVReg;
RENAME DEM_REG=DemReg;
RUN;

DATA PROJECT.ORGANICS;
SET PROJECT.ORGANICS;
IF DemClusterGroup = "A" THEN DemClusterGroup_1 = 1;
ELSE DemClusterGroup_1=0;
IF DemClusterGroup = "B" THEN DemClusterGroup_2 = 1;
ELSE DemClusterGroup_2=0;
IF DemClusterGroup = "C" THEN DemClusterGroup_3 = 1;
ELSE DemClusterGroup_3=0;
IF DemClusterGroup = "D" THEN DemClusterGroup_4 = 1;
ELSE DemClusterGroup_4=0;
IF DemClusterGroup = "E" THEN DemClusterGroup_5 = 1;
ELSE DemClusterGroup_5 = 0;
IF DemClusterGroup = "F" THEN DemClusterGroup_6 = 1;
ELSE DemClusterGroup_6 = 0;
DROP DemClusterGroup;
RUN;

data PROJECT.TEMP;
set PROJECT.ORGANICS;
n=ranuni(8);
RUN;

PROC SORT DATA=PROJECT.TEMP;
BY ID;
RUN;

DATA PROJECT.TRAINING PROJECT.TESTING;
SET PROJECT.TEMP NOBS=NOBS;
IF _N_<=.7*NOBS THEN OUTPUT PROJECT.TRAINING;
ELSE OUTPUT PROJECT.TESTING;
DROP n;
RUN;

PROC LOGISTIC DATA=PROJECT.ORGANICS;
CLASS PromClass DemGender DemTVReg DemReg;
MODEL TargetBuy= DemAffl DemAge PromSpend PromTime DemClusterGroup_1 DemClusterGroup_2 DemClusterGroup_3 DemClusterGroup_4 DemClusterGroup_5 DemClusterGroup_6/
SELECTION = STEPWISE
SLENTRY=0.6
SLSTAY=0.65;
RUN;

PROC EXPORT data=PROJECT.TRAINING
   OUTFILE='C:\Users\Jeremiah Lowhorn\Dektop\organics_training.csv'
   DBMS=csv REPLACE; 
RUN;

PROC EXPORT data=PROJECT.ORGANICS
   OUTFILE='C:\Users\Jeremiah Lowhorn\Dektop\organics.csv'
   DBMS=csv REPLACE; 
RUN;
PROC EXPORT data=PROJECT.TRAINING
   OUTFILE='C:\Users\Jeremiah Lowhorn\Dektop\organics_testing.csv'
   DBMS=csv REPLACE; 
RUN;
