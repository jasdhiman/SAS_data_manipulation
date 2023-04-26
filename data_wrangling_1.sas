/* CREATING TABLE WITH FORMAT SPECIFIED CHARACTER VAR*/
/*$ means character 6 means 6 characters max*/
data first_data;
input employee $6. salary; 
datalines;
manbir 67
jassbr 89
jasdhi 793
khandl 77
grgill 54
cheema 106
;
run;

/* CREATING TABLE WITHOUT FORMAT SPECIFIED CHARACTER VAR*/
/*no char format specified*/
data first_data;
input employee $ salary; 
datalines;
manbir 67
jass 89
jas 793
khandal 77
gill 54
cheema 106
;
run;

/* SAVING TABLE TO LIBRARY*/
data SASTUTOR.first_data; /*saving table to library*/
input employee $ salary;
datalines;
manbir 67
jass 89
jas 793
khandal 77
gill 54
cheema 106
;
run;

/* creating a library - setting library name*/
libname sastut "/home/u62306491/sasuser.v94/SAS_tut_files";

/* IMPORTING EXCEL*/
proc import datafile="/home/u62306491/sasuser.v94/SAS_tut_files/Categories.xlsx" /* specifying data location */
			out = sastut.cat /* specifies name of the SAS table that is to be created in sastut library*/
			dbms = xlsx replace; /* specifies type of the file imported, replace overwrites existing SAS dataset*/
			sheet = "categories"; /* specifies sheet oin the excel file to be imported*/
run;

/* you can dblclick on the SAS dataset to view it, or can access SAS dataset using following statement */
data test;
set sastut.cat; /* set command reads data from specified location*/
run;

/* working on another dataset*/
/* importing*/
proc import datafile="/home/u62306491/sasuser.v94/SAS_tut_files/Order_Details.xlsx"
			out = sastut.OrderDetails (drop = price) /*drops price column*/
			dbms=xlsx replace;
			sheet="OrderDetails";
run;

/*creating variable*/
data test;
set sastut.Orderdetails;
price = quantity*5; /*multiplies quantity column with 5 (each row)*/
run; /* please note that the resulting dataset is stored as test in work library*/		

/* Renaming a variable  */
data test;
set sastut.orderdetails;
rename quantity = qty;
run;

/* removing a variable  */
data test;
set sastut.orderdetails;
drop orderdetailid;
run;

/* create, rename and remove a variable all at once and saving the resulting file in our library */
data sastut.test;
set sastut.orderdetails;
price = quantity*5;
rename quantity = qty; 
drop orderdetailid;
run;

/* filtering data*/
/* first we import the data */
proc import datafile="/home/u62306491/sasuser.v94/SAS_tut_files/Customers.xlsx"
			out = sastut.customers
			dbms=xlsx replace;
			sheet="Customers";
run;
/* filter for USA in country column and amount > 600 in transaction column */
data test; /* create table*/
set sastut.customers; /* read data */
where country = 'USA' and transaction_amount > 600;
run;
/* filter for USA in country column OR amount > 600 in transaction column */
data test; /* create table*/
set sastut.customers; /* read data */
where country = 'USA' or transaction_amount > 600;
run;

/* CONDITIONAL STATEMENTS in SAS */
/* if then else */
data test;
set sastut.customers;
if transaction_amount < 500 then category = "Below Average";
else category = "Above Average";
run;
/* if then, else if the, else */
data test;
set sastut.customers;
if transaction_amount < 500 then category = "Below Average";
else if transaction_amount >= 500 and transaction_amount < 699 then category = "Premium";
else category = "Elite";
run;

/* SAS options */
/* KEEP - we only want to keep few columns*/
/* first look at the whole table */
data keeps;
set sashelp.cars;
run;
/* just select 3 columns out of the whole table */
data keeps;
set sashelp.cars (keep=model type msrp);
run;
/* also works when SAS options are given in data statement line */
data keeps(keep=model type msrp);
set sashelp.cars;
run;
/* DROP - few columsn we do not want to keep*/
data drops;
set sashelp.cars (drop = msrp);
run;
/* OUTPUT - create 2 tables, one with msrp <19000 and that too with only 3 columns*/
/* second with msrp >= 19000, but should not keep the 3 variables */
/* we will use keep/drop options in data statement */
data price(keep=model type msrp) features(drop=model type msrp);
set sashelp.cars;
if msrp<19000 then output price;
else output features;
run;
/* _N_ - represents observation lines - lets say we want to keep lines 10 to 20*/
data linenumber;
set work.price;
if _N_>= 10 and _N_ < 20;
run;
/* OBS option - lets only output 15 observations - by default 1st to 15th obs */
data observation;
set work.price(obs = 15);
run;
/* FIRSTOBS option - lets only output 10 observations but it should start from 7th observation */
data observation;
set work.price(obs = 16 firstobs=7); /*we use 16 observations because if we count from 7th obs in this 16 obs table, we will get 10 obs which we wanted */
run;

/* PROC PRINT */
proc print data = sastut.customers;
run; /* this prints the whole table */
/* let us print only first 10 obs */
proc print data = sastut.customers(obs=10);
run;
/* let us limit the number of variables - use VAR statement */
proc print data = sastut.customers(obs=10);
var contactname country transaction_amount;
run;
/* let us give title to the table */
proc print data = sastut.customers(obs=10);
var contactname country transaction_amount;
title "Customers Table";
run;
/* let us use by statement to get country wise grouping of printed tables */
proc print data = sastut.customers(obs=10);
var contactname country transaction_amount;
title "Customers Table";
by notsorted country;
run;
/* let us use sum statement to get sum of trasaction amount for each sub-table */
proc print data = sastut.customers(obs=10);
var contactname country transaction_amount;
title "Customers Table";
by notsorted country;
sum transaction_amount;
run;
/* let us use where statement to get sum of trasaction amount for USA */
proc print data = sastut.customers;
var contactname country transaction_amount;
title "Customers Table";
by notsorted country; /* this statement can be deleted here */
sum transaction_amount;
where country = 'USA';
run;
/* adding a footnote */
proc print data = sastut.customers;
var contactname country transaction_amount;
title "Customers Table";
by notsorted country; /* this statement can be deleted here */
sum transaction_amount;
where country = 'USA';
footnote 'footnote text here';
run;

/* PROC SORT */
/* let us sort on country */
proc sort data = sastut.customers;
by country;
run;
/* let us sort on country and transaction amount */
proc sort data = sastut.customers;
by country transaction_amount;
run;
/* if we want to save sorted data in another table */
proc sort data = sastut.customers out = sorted;
by country transaction_amount;
run;
/* if we want to save by country in descending order */
proc sort data = sastut.customers out = sorted;
by descending country transaction_amount;
run;
/* if we want to save by transaction amount in descending order */
proc sort data = sastut.customers out = sorted;
by country descending transaction_amount;
run;
/* NODUPKEY - keep one obs for each country*/
proc sort data = sastut.customers nodupkey out = sorted;
by country; /* duplicate countries will be removed */
run;
/* NODUP - remove throughout duplicate rows - suplicate values in all columns */
proc sort data = sastut.customers nodup out = sorted;
by country; /* by variable is required for sort command */
run;
/* SAS only compares consecutive rows and will not compare e.g. 1st and 3rd rows */
/* use by _all_ to workaround that */
proc sort data = sastut.customers nodup out = sorted;
by _all_; /* by variable is required for sort command */
run;
/* DUPOUT - output the duplicate values identified by nodupkey or nodup */
proc sort data = sastut.customers nodupkey out = sorted dupout = duplicated;
by country; /* by variable is required for sort command */
run;

/* PROC FREQ */
/* first we import the data */
proc import datafile="/home/u62306491/sasuser.v94/SAS_tut_files/customer_details.xlsx"
			out = sastut.cust
			dbms=xlsx replace;
			sheet="data";
run;
/* the procedure */
proc freq data = sastut.cust;
tables city;
run;
/* lets say we only want frequency */
proc freq data = sastut.cust;
tables city / nopercent nocum;
run;
/* 2 dimensional freq report */
/* e.g. a given city occurs how many times in a country */
proc freq data = sastut.cust;
tables city*country;
run;
/* lets say we only want frequency */
proc freq data = sastut.cust;
tables city*country / nopercent norow nocol;
run;
/* conditional frequency - check occurences of a city within the country, only when transaction amount > 500 */
/* use where clause */
proc freq data = sastut.cust;
tables city*country / nopercent norow nocol;
where transaction_amount > 500;
run;

/* PROC TRANSPOSE */
proc transpose data = sastut.cust out = transposed;
by city; /*what we dont want to transpose*/
id country; /*needs to be transposed from obs to column*/
var transaction_amount; /*what we want to populate the table*/
run;
/* this willl give error as data needs to be sorted based on the "by" and "id" variables */
proc sort data = sastut.cust out = sorted_cust;
by city country;
run;
/* now do the transpose */
proc transpose data = sorted_cust out = transposed;
by city; /*what we dont want to transpose*/
id country; /*needs to be transposed from obs to column*/
var transaction_amount; /*what we want to populate the table*/
run;
/* we see some errors because more than one instance of city and country combination exists */
/* let us fix that first */
proc sort data=sorted_cust nodupkey out = sorted_cust_nodup;
by city country;
run;
/* now lets see */
proc transpose data = sorted_cust_nodup out = transposed;
by city; /*what we dont want to transpose*/
id country; /*needs to be transposed from obs to column*/
var transaction_amount; /*what we want to populate the table*/
run;
/* getting rid of the 2 unwanted labels */
proc transpose data = sorted_cust_nodup out = transposed(drop=_:); /*drop columns starting with '_' and put ':' after*/
by city; /*what we dont want to transpose*/
id country; /*needs to be transposed from obs to column*/
var transaction_amount; /*what we want to populate the table*/
run;
/* giving a prefix to the transposed variable */
/* use prefix function - dont use "" with it */
proc transpose data = sorted_cust_nodup prefix = trans_ out = transposed(drop=_:); /*drop columns starting with '_' and put ':' after*/
by city; /*what we dont want to transpose*/
id country; /*needs to be transposed from obs to column*/
var transaction_amount; /*what we want to populate the table*/
run;
/* using suffix as well */
proc transpose data = sorted_cust_nodup prefix = trans_ suffix = _done out = transposed(drop=_:); /*drop columns starting with '_' and put ':' after*/
by city; /*what we dont want to transpose*/
id country; /*needs to be transposed from obs to column*/
var transaction_amount; /*what we want to populate the table*/
run;
/* another example */
/* first let us sort the data and remove duplicate data*/
proc sort data=sastut.customers out=sorted_cust2;
by city contactname country;
run;
/* now let us transpose */
proc transpose data=sorted_cust2 out=transposed2(drop=_:);
by city contactname;
id country;
var transaction_amount;
run;
/* what if we want to transpose city and country value together */
/* change by and id statements accordingly */
proc transpose data=sorted_cust2 out=transposed2(drop=_:);
by contactname;
id country city;
var transaction_amount;
run;
/* we get error so changing the order of by statement variables */
proc sort data=sastut.customers out=sorted_cust2;
by contactname city country;
run;
/* next try */
proc transpose data=sorted_cust2 out=transposed2(drop=_:);
by contactname;
id country city;
var transaction_amount;
run;

/* PROC CONTENTS */
/* rows columns and variable type information */
proc contents data=sashelp.cars;
run;
/* the names of variables listed in the output table is in alphabetical order and not in actual order */
/* for actual order, use VARNUM option */
proc contents data=sashelp.cars varnum;
run;





