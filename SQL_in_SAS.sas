data student;
input name$ sub1 sub2 sub3 gender$;
datalines;
sam 67 54 77 M
ann 87 65 76 F
ron 54 65 76 M
bob 34 68 56 M
Renee 77 66 68 F
;
run;

proc print data = student;
run;

proc sql;
select * from student;
quit;

proc sql;
select max(sub1) as highest_sub1, max(sub2) as highest_sub2, max(sub3) as highest_sub3 from student;
quit;

proc sql;
select min(sub1) as lowest_sub1, min(sub2) as lowest_sub2, min(sub3) as lowest_sub3 from student;
quit;

proc sql;
select mean(sub1) as avg_sub1, mean(sub2) as avg_sub2, mean(sub3) as avg_sub3 from student;
quit;

proc sql;
select * from student where gender="M";
quit;

proc sql;
select * from student where gender="F";
quit;

proc sql;
select *, (sub1+sub2+sub3) as total from student;
quit;

