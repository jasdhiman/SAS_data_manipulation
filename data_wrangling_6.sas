/* loops */

data tables;
do table=16 to 160 by 16; /* add 16 */
output;
end;
run;

proc print data = tables; run;

/* using if statement witrh do loops - saves us number of lines */

data class3;
set sashelp.class;
format stay category $30.;

if age <= 12 then do;
fee = '15k';
category = 'kid';
stay = 'allowed';
end;

else do;
fee = '25k';
category = 'teenage';
stay = 'not allowed';
end;
run;

/* do while loops */
data test;
x=1;
do while (x<=3);
	output;
	x+1;
end;
run;
/* while loop condition is evaluated at the top of loop - if conditionis true, only then loop works */

/* do until loops */
data test2;
x=1;
do until (x>3);
	output;
	x+1;
end;
run;
/* until loop condition is evaluated at the bottom of the loop - as long as the condition remains false, the loop works*/

/* MACROS */
/* let us forst create an examplw where we want to create summary by TYPE and ORIGIN of car */

/* looking at types of cars */
proc freq data=sashelp.cars; tables type; run;

proc sql;
create table SUV_summary as
select type
		,origin
		,avg(Invoice) as price
		,avg(EngineSize) as engine_L
		,avg(Weight) as Wt
		,avg(MPG_city) as MPG
	from sashelp.cars
	where upcase(type) = 'SUV'
group by type, origin;
quit;

proc print data=SUV_summary; run;

/* if we want to create same summary for SEDAN Sports Truck, etc - we need to repeat this code and change the */
/* variable name to Sedan, sports or truck at 3 places (name of the table, proc print statement and the variable in where statement) */
/* let us use MACRO to simplify this */

/* at the beginning - define a variable e.g. here it is car_type*/
%MACRO type_summary(car_type);
proc sql;
create table &car_type._summary as /* wherever SUV appears, write &car_type. - write & before and . after variable */
select type
		,origin
		,avg(Invoice) as price
		,avg(EngineSize) as engine_L
		,avg(Weight) as Wt
		,avg(MPG_city) as MPG
	from sashelp.cars
	where upcase(type) = "&car_type." /* use double quotation marks - wherever SUV appears, write &car_type. - write & before and . after variable */
group by type, origin;
quit;
proc print data = &car_type._summary; run;
%MEND;
/* at the end of statement */

/* running the MACRO */
/* simply type % followed by macro name and in parentheses write the variable name for which you want to run the code */
%type_summary(SEDAN);

/* the above MACRO type runs only for char variables */
/* let us look at assigning variable values - assigning numeric or char values to variable to be used in MACRO*/
%let first_num = 773;
%let second_num = 876;
/* the above variables are global variables */
/* if they were written within a MACRO - they would have been local variables - cannot be used outside */
/* run the above lines is called compiling assigned variables - global */
/* running the below line is called calling variables */
%put &first_num.;

/* running the following code by calling global assigned variables */
data test;
sum = &first_num. + &second_num.;
run;


/* variables which can be used in MACROS */
/* %LET */

%let hp = 200; /* defining let variable */
/* defining code */
data test;
set sashelp.cars;
where Horsepower in (&hp.); /* use IN command */
run;

/* benefit - we can run same code for many different Horsepower values by just adding those values in let variable */
%let hp = 200, 290, 225; /* to be used with IN command */
data test;
set sashelp.cars;
where Horsepower in (&hp.);
run;

/* MACRO variables */
/* running the same code with MACRO variables */
%MACRO test(hp);
data test;
set sashelp.cars;
where Horsepower in (&hp.);
run;
%MEND;
/* compile MACRO by running above llines - then call by running below statement */
%test(200); /* list cannot be used here */

/* MACRO variable using proc SQL */
proc sql noprint;
select Horsepower into: hp
from sashelp.cars;
quit;
/* seeing the variable */
%put &hp.; /* only one value is stored - 265 - which is first value */
/*let us test it */
data test;
set sashelp.cars; /* this can be from any table */
where Horsepower = &hp.;
run;

/* we use separated by comma function if we want to assign all Horsepower values to hp */
proc sql noprint;
select Horsepower into: hp separated by ','
from sashelp.cars; /* this can be from any table */
quit;
/* seeing the variable */
%put &hp.; /* all HP values are stored */
/*let us test it */
data test;
set sashelp.cars;
where Horsepower in (&hp.);
run;
/* the above code will give all observations */
/* the above function can be used to assign values from a separate table to a variable, and find observations */
/* corresponding to those values in separate table */


/* CALL SYMPUT */



