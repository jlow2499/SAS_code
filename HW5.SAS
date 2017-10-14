/*Create the bicycle data set*/

DATA bicycle;
INPUT Model $ 1-12 Class $ Price Frame $ 28-38 ;
DATALINES;
Black Bora   Track     796 Aluminum
Delta Breeze Road      699 CroMoly
Jet Stream   Track    1130 CroMoly
Mistral      Road     1995 Carbon Comp
Nor'easter   Mountain  899 Aluminum
Santa Ana    Mountain  459 Aluminum
Scirocco     Mountain 2256 Titanium
Trade Wind   Road      759 Aluminum 
;
RUN;

/*Create the bike macro and set it to 'Mountain'*/
%LET bike = 'Mountain';

/*Print the bicycle dataset subset of the macro bike, format the Price to DOLLAR6.
Use the bike macro to create the title and subset the data. This will automatically adjust
the title and subset whenever a new bike type needs to be used. 
*/

PROC PRINT DATA = bicycle NOOBS;
WHERE Class = &bike;
FORMAT Price DOLLAR6.;
TITLE "Current Models of " &bike " Bicycles";
FOOTNOTE1 "Report by &sysuserid";
FOOTNOTE2 "&sysday, &sysdate9 at &systime";
RUN;

/*Turn off MPRINT and turn on SYMBOLGEN to show the macros used in the exercise being resolved. */
OPTIONS NOMPRINT SYMBOLGEN;
%PUT &bike;
%PUT &sysuserid;
%PUT &sysday;
%PUT &sysdate9;
%PUT &systime;
