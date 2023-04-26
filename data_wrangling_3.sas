/* search for a pattern in a string */
/* PRXMATCH */
/* getting all entries where remarks start with letter 's' or 'c' */
data test;
set sastut.online;
flag = prxmatch("/^s|^c/", remarks); /* we need to put expression in double quote and in double forward slash // */
run;
/* all flag values where expression is satisfied is 1 */

/* if we want case insesitive */
data test;
set sastut.online;
flag = prxmatch("/^s|^c/i", remarks); /* put an 'i' after closing forward slash / */
run;

/* if we want flag where digit value occurs */
data test;
set sastut.online;
flag = prxmatch("/\d/", remarks); /* use \d - flag variabe here will also give the position*/
run;

/* let us test for SEPARATING mobile numbers */
/* create data first */
data mobile;
input comments $70.;
cards;
he called yesterday and his phone number is 5148885643. Thats it
9888885431 is her phone number. Call her and ask for $450
you dont know her number? it is 6543219999. Thanks! now go call her
;
run;
/* now we extract mobile numbers */
data extract;
set mobile;
mobile_num_pos = prxmatch("/\d{10}/", comments); /* 10 digit digit number */
mobile_number = substr(comments, mobile_num_pos, 10); /* from the specified position to 10 characters */
run;

/* data type conversion */
/* INPUT function - char to num */
/* PUT function - num to char */
data sample;
set sastut.online;
acct_num = put(acctno, best.); /* converts num to char */
acc_num = input(acct_num, best.); /* converts char to num */
run;

/* current date TODAY(), DAY(), WEEKDAY(), WEEK(), MONTH(), QTR() and YEAR() functions */
data dates;
format curr_date date9.; /* to get in date format - if not used you will get a number */
curr_date = today();
run;
/* previous day's date */
data dates;
format curr_date date9.; /* to get in date format - if not used you will get a number */
curr_date = today()-1;
day = day(curr_date); /* get day of the month */
weekday = weekday(curr_date); /* which day of the week 1-7 with 1 as sunday*/
week = week(curr_date); /* which week of the year 1-52 range*/
month = month(curr_date); /* which month of the year */
quarter = qtr(curr_date); /* quarter of year 1-4 */
year = year(curr_date); /* 4 digit year value */
run;

/* creating date from month day year */
/* MDY() function */
data sample;
format next_day date9.;
next_day = mdy(12, 04, 2022);
run;

/* INFORMAT and FORMAT functions */
data test;
input date;
cards;
01/01/1957
;
run;
/* we get missing value */
/* SAS get confused as / is a spl char */
/* we use informat to fix this */
/* informat can be a method for SAS to read the data */

data test;
input date ddmmyy10.; /* ddmmyy10. is informat */
cards;
01/01/1961
;
run;
/* SAS will count the number of days after 01/01/1960 and give here */
/* if date occurs before 01/01/1960, SAS will give number of days before this date with a -ve sign */
/* use format to fix the issue */

data test;
input date ddmmyy10.;
format date ddmmyy10.;
cards;
01/01/1961
;
run;

/* lets try date9. format */
data test;
input date ddmmyy10.;
format date date9.; 
cards;
01/01/1961
;
run;
/* note that informat has to match the data input structure, whereas format does not have to match */

/* INTCK calculates difference betweek 2 dates, times or datetimes */
data sample;
format addmission_date discharge_date application_date current_date date9.;
addmission_date= '10jan2020'd;
discharge_date= '12may2020'd;
application_date= '12jun2020'd;
current_date= today();
run;

/* lets do */
data test;
set sample;
days = intck('day', addmission_date, discharge_date);
months = intck('month', addmission_date, discharge_date);
run;

/* optional statements in intck */
/* discrete option - diff between 31 dec 2019 and 1 jan 2020 will be 1 month - default method */
/* continous option - diff between 31 dec 2019 and 1 jan 2020 will be 0 months */
data test;
set sample;
format start_date end_date date9.;
start_date = '31dec2019'd;
end_date = '01jan2020'd;
months_cont = intck('month', start_date, end_date, 'C');
months_discrete = intck('month', start_date, end_date, 'D');
run;

/* INTNX option - increments a date, time or datetime value by a given interval */
/* we want to increase number of days by 20 units from a given date - lets see */
data dates;
format first_visit second_visit third_visit fourth_visit date9.;
first_visit = '10oct2020'd;
second_visit = intnx('day', first_visit, 20);
third_visit = intnx('day', second_visit, 20);
fourth_visit = intnx('day', third_visit, 20);
run;

/* let us use INTNX options */
data alignment;
format start endd end_beginning end_middle end_end end_sameday date9.;
start = '25oct2020'd;
endd = intnx('month', start, 3);
end_middle = intnx('month', start, 3, 'm');
end_beginning = intnx('month', start, 3, 'b');
end_end = intnx('month', start, 3, 'e');
end_sameday = intnx('month', start, 3, 's');
run;

/* EXPORTING IN SAS */
proc export data=sastut.customers
			outfile = "/home/u62306491/sasuser.v94/SAS_tut_files/test_export.xlsx"
			dbms = xlsx replace;
			sheet = "you_can_give_sheet_name";
run;

/* doing it in CSV */
proc export data=sastut.customers
			outfile = "/home/u62306491/sasuser.v94/SAS_tut_files/test_export.csv"
			dbms = csv replace;
run;

/* how to xport mult tables in one excel file?	 */
/* provide same file address but different sheet names */
proc export data=sastut.customers
			outfile = "/home/u62306491/sasuser.v94/SAS_tut_files/test_export.xlsx"
			dbms = xlsx replace;
			sheet='customers';
run;
/* run the proc steps one by one */
proc export data=sastut.online
			outfile = "/home/u62306491/sasuser.v94/SAS_tut_files/test_export.xlsx"
			dbms = xlsx replace;
			sheet='online';
run;
/* run the proc steps one by one */
proc export data=sastut.orderdetails
			outfile = "/home/u62306491/sasuser.v94/SAS_tut_files/test_export.xlsx"
			dbms = xlsx replace;
			sheet='order_details';
run;


