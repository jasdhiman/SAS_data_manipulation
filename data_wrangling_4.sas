/* COMBINING tables */
/* if a column is exactlly the same between 2 datasets */
/* lets create 2 tables to check this */
data table1;
set sastut.cust(keep = contactname transaction_amount obs=5);
run;

data table2;
set sastut.cust(keep = contactname city country obs=5);
run;

data combined;
set table1;
set table2;
run;
/* this will combine the 2 datasets with a common and exactly same column in both */
/* if we have 2 tables with same column name but different values, still this would work but */
/* data from column (with common column name) of 2nd table will be written in resulting table */

/* create another table */
data table3;
set sastut.cust (keep = contactname city country obs=10 firstobs=6);
run;

data combined;
set table1;
set table3;
run;
/* this table is not correct */

/* use only 1 set statement to fix this */
data combined;
set table1
	table3;
run;

/* this is not what we want - we want to merge the tables */
/* there should be atleast 2 tables */
/* one of the variables (columns) should be common between the 2 tables */
/* both tables must be sorted by the common column */
/* let us create a table to be used in this excercise */
data table4;
set sastut.cust (keep = contactname city country obs=8 firstobs=4);
run;

/* now let us merge */
/* first we sort */
proc sort data=table1; by contactname; run;
proc sort data=table4; by contactname; run;

data combined;
merge table1 table4;
by contactname;
run;

/* let us say we want values only based on table 1 in the contactname variable */
/* this is also called left join */
data combined;
merge table1(in=a) table4(in=b); /* in command is used to name a table and should be used when merging based on a condition like this */
by contactname;
if a;
run;

/* right join */
data combined;
merge table1(in=a) table4(in=b); /* in command is used to name a table and should be used when merging based on a condition like this */
by contactname;
if b;
run;

/* now we want only those observations which are common in both tables */
/* inner join */
data combined;
merge table1(in=a) table4(in=b); /* in command is used to name a table and should be used when merging based on a condition like this */
by contactname;
if a and b;
run;

/* outer join */
data combined;
merge table1(in=a) table4(in=b); /* in command is used to name a table and should be used when merging based on a condition like this */
by contactname;
if a or b;
run;

/* APPEND function */
/* let us create tables required first */
data table5;
set sastut.cust (keep= contactname transaction_amount city country obs=5);
run;
data table6;
set sastut.cust (keep= contactname transaction_amount city country obs=10 firstobs=6);
run;
/* lets append */
proc append base=table5 data=table6; run;
proc print data = table5; run;
/* keep in mind that here the base dataset gets changed */

/* an option for APPEND procedure is the FORCE statement (e.g. if column names are not same in 2 tables) */
/* let us try without force first */
proc append base=table1 data=table3; run;
/* we get error - use FORCE now */
proc append base=table1 data=table3 force; run;
proc print data=table1; run;
/* keep in mind, only columns from base table will be available in output table */

/* Appending all tables with similar initial name (e.g. starts with CUST) into one table within library */
data combined_all;
set sastut.cust:; /* put a colon after */
run;



