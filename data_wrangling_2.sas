/* TYPES OF BLANKS */
/* trailing blanks - blanks at the end of the string */
/* leading blanks - before the string */
/* blanks in between - as the name suggests */

/* how to remove the blanks/spaces */
/* TRIM TRIMN STRIP COMPRESS COMPBL */
/* HERE WE WILL USE COMPRESS AND COMPBL - REST ARE EASY TO USE */
/* COMPRESS - removes all blank spaces from data */
/* COMPBL - compresses more than one consecutive blank spaces into 1 blank space */

/* creating sample data */
data sample;
NAME = "Jaskaran Singh Dhiman";
len = length(NAME);
run;

/* putting some space */
data sample;
NAME = "Jaskaran     Singh       Dhiman";
len = length(NAME);
run;

/* compressing */
data sample;
NAME = "Jaskaran     Singh       Dhiman";
len = length(NAME);
compress = compress(NAME);
len_c = length(compress);
compbl = compbl(NAME);
len_cbl = length(compbl);
run;

/* compress can also be used to remove specific characters from string */
data sample2;
values = '165236837jhHkshdvsvdfk<>:"';
new_values = compress(values, '<>:"'); /* removing spcl char */
run;

/* removing a letter - h */
data sample2;
values = '165236837jhHkshdvsvdfk<>:"';
new_values = compress(values, 'h'); /* removing h */
run;

/* we see that capital H is not removed - if we want all h to be removed irrespective of the case - we use modifier */
/* e.g. 'i' modifier ignores case */
data sample2;
values = '165236837jhHkshdvsvdfk<>:"';
new_values = compress(values, 'h', 'i'); /* removing h and H */
run;

/* we want to remove all number values - use digits modifier - d */
data sample2;
values = '165236837jhHkshdvsvdfk<>:"';
new_values = compress(values, '', 'd'); /* removing all digits - keep character as blank - '' */
run;

/* CONCATENATION - COMBINE MULTIPLE STRINGS */
/* MANUAL WAY TO JOIN USING PIPE - | */
data sample;
firstname = 'Jaskaran';
middlename = 'Singh';
lastname = 'Dhiman';
fullname = firstname||middlename||lastname; /* using double pipe - || */
run;

/* here there is no space - let us add space manually */
data sample;
firstname = 'Jaskaran';
middlename = 'Singh';
lastname = 'Dhiman';
fullname = firstname||' '||middlename||' '||lastname; /* using double pipe - || and space */
run;

/* now using CAT function */
data sample;
firstname = 'Jaskaran';
middlename = 'Singh';
lastname = 'Dhiman';
fullname = firstname||' '||middlename||' '||lastname;
fullname2 = cat(firstname, middlename, lastname);
run;

/* to separate using single space - use CATX */
data sample;
firstname = 'Jaskaran';
middlename = 'Singh';
lastname = 'Dhiman';
fullname = firstname||' '||middlename||' '||lastname;
fullname2 = cat(firstname, middlename, lastname);
fullname3 = catx(' ',firstname, middlename, lastname); /* catx uses a separator before - this can be any value */
run;

/* CATS and CATT are other functions */
/* CATS is similar to CAT and CATT is combination of CAT and TRIM function - you can try */

/* EXTRACTING a part of the string */
/* e.g. getting last 4 digits of credit card number */
/* in EXCEL we use MID function */
/* in SAS we use SUBSTR */
data card_info;
input card_num $ 16.;
datalines;
572848221752577
337904780994715
401860789452657
382609120165135
709455401928619
618737423328593
874440208793747
126776030172856
280138656321611
;
run;

/* let us use SUBSTR */
data sample;
set card_info;
last_digits = substr(card_num, 12, 4); /* SUBSTR(var_name, position of first value, no. of values to follow) */
run;
/* you can get any middle characters as well using SUBSTR */

/* we can replace a part of string with any character using SUBSTR - let's see */
data sample;
set card_info;
substr(card_num, 5, 8) = '********'; /* from 5th value, we want 8 * values */
run;

/* CHANGE CASE FUNCTIONS */
/* capital, lower, sentence, all first letters caps, etc */
data sample;
input name $;
cards;
Yusuf
renee
CORRINNE
aLLyX
aHMAD
;
run;

data change_case;
set sample;
CAPS = upcase(name);
LOW = lowcase(name);
sentence = propcase(name);
run;

/* REPLACE PART OF A STRING */
/* TRANWRD - replaces all occurences of a specific word in a string */
/* TRANWRD(var_name, REPLACE WHAT, REPLACE WITH) */
data sample;
name = "Amanpreet Kaur Punni";
changed = tranwrd(name, 'Punni', 'Dhiman');
run;

data sample;
string = "boy boy boy girl girl girl";
changed = tranwrd(string, 'boy', 'girl');
run;

/* you can correct e.g. prefixes using TRANWRD and  conditional statements like IF*/
/* making a dataset */
data sample2;
input name $ sex $;
cards;
Mr.Julie F
Ms.Ron M
Mrs.Daniel m
Mr.Allyx f
;
run;

/* trying TRANWRD */
data sample2_fixed;
set sample2;
if upcase(sex) = 'M' then name2 = tranwrd(name, 'Ms.', 'Mr. ');
else name2 = tranwrd(name, 'Mr.', 'Ms. ');
run;

/* we see that mrs is not changed */
data sample2_fixed_again;
set sample2_fixed;
if upcase(sex) = 'M' then name3 = tranwrd(name2, 'Mrs.', 'Mr. ');
else name3 = name2;
run;

/* TRANSLATE option - just like TRANWRD replaces a word in a sentence or string, TRANSLATE replaces characters */
/* TRANSLATE(var_name, REPLACE WHAT, REPLACE WITH) */
data sample3;
name = 'Justkaran';
name2 = translate(name, 'as', 'ust'); /* this will give extra space because we are changing 3 to 2*/
name3 = compress(name2, ' '); /* fixing the name */
run;

/* finding a word or character within a string using INDEX */
/* returns the position of specified string value */
/* INDEX(var_name, find what) */
/* first we import file */
proc import datafile='/home/u62306491/sasuser.v94/SAS_tut_files/online_sales.xlsx'
			out = sastut.online
			dbms= xlsx replace;
			sheet= 'Sheet1';
run;
/* lets try now */
data sample;
set sastut.online;
exists = index(remarks, '.com'); /* non-0 value under exist column will tell that .com exists there */
/* now let us see only that data where exist>0 */
if exists > 0 then output;
run;

/* CONDITIONAL FINDING OF CHAR OR WORD IN A STRING */
/* FIND FUNCTION - LIKE index BUT PROVIDE OPTIONAL FEATURES */
data sample;
set sastut.online;
exists = find(remarks, '.com', 'i'); /* i means modifier - ignore cases - caps or lower */
if exists > 0 then output;
run;
/* giving starting position */
data sample;
string = 'hanni minni goin gaa dimb babi illin aan dimb';
/* we want to look where dimb occurs */
exists = find(string, 'dimb');
run;
/* we see that dimb occurs first at 22 position */
/* we want to search after 22nd position */
data sample;
string = 'hanni minni goin gaa dimb babi illin aan dimb';
exists = find(string, 'dimb', 25); /* search after 25th position */
run;


