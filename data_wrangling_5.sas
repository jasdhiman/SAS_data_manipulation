/* PROC SQL - structured query language */
/* if we need 2 columns from a dataset */
proc sql;
select model, type from sashelp.cars;
quit;

/* select all columns */
proc sql;
select * from sashelp.cars; /* all variables */
quit;

/* conditional statements - WHERE */
proc sql;
select model, type, invoice, weight from sashelp.cars 
where type = 'SUV' and weight > 5000;
quit;

/* summarize tables */
proc sql;
select type 
		,count(type) as num_units 
		,sum(invoice) as total_invoice
		,sum(weight) as total_weight
from sashelp.cars
group by type;
quit;

/* conditional with group by */
proc sql;
select type 
		,count(type) as num_units 
		,sum(invoice) as total_invoice
		,sum(weight) as total_weight
from sashelp.cars
where weight >= 5000
group by type;
quit;

/* filtering data */
proc sql;
select type 
		,count(type) as num_units 
		,sum(invoice) as total_invoice
		,sum(weight) as total_weight
from sashelp.cars
group by type
where num_units < 50;
quit;
/* this will give error as num_units is not existing in source data (CARS data) */

/* use HAVING instead of WHERE */
proc sql;
select type 
		,count(type) as num_units 
		,sum(invoice) as total_invoice
		,sum(weight) as total_weight
from sashelp.cars
group by type
having num_units <= 50;
quit;

/* ORDER BY clause */
proc sql;
select type 
		,count(type) as num_units 
		,sum(invoice) as total_invoice
		,sum(weight) as total_weight
from sashelp.cars
group by type
having num_units <= 50
order by num_units;
quit;

/* ORDER BY reverse order */
proc sql;
select type 
		,count(type) as num_units 
		,sum(invoice) as total_invoice
		,sum(weight) as total_weight
from sashelp.cars
group by type
having num_units <= 50
order by num_units desc;
quit;

/* CASE WHEN similar to IF ELSE */
proc sql;
select *
		,case when weight>=5000 then 'heavy' 
		else 'light'
		end as weight_class
		from sashelp.cars;
quit;

/* 3 categories */
proc sql;
select *
		,case when weight>=5000 then 'heavy'
		when weight < 5000 and weight >=3000 then 'medium'
		else 'light'
	end as weight_class
from sashelp.cars;
quit;

/* multiple columns based on different conditions can be made */
proc sql;
select *
		,case when weight>=5000 then 'heavy'
		when weight < 5000 and weight >=3000 then 'medium'
		else 'light'
	end as weight_class
		,case when msrp > 35000 and msrp < 40000 and horsepower < 250 then 'expensive'
		else 'ok or luxury'
	end as price_class
from sashelp.cars;
quit;

/* summarizing with COUNT FREQ N */
proc sql;
select type
		,count(*) as count_of_obs /* * will count all obs */
		,freq(type)as frequency /* non missing value will not be counted */
		,n(type) as num_obs
	from sashelp.cars
	group by type; /* we can also write group by 1 - 1st variable */
quit;
/* results show there are no missing value */

/* MIN MAX AVG MEAN RANGE STD SUM */
proc sql;
select type
		,min(invoice) as minimum_val
		,max(invoice) as maximum_val
		,mean(invoice) as mean_val
		,avg(invoice) as avg_val
		,range(invoice) as range_val
		,std(invoice) as std_val
		,sum(invoice) as sum_val
	from sashelp.cars
	group by type; /* we can also write group by 1 - 1st variable */
quit;

/* by 2 variables group and summarize */
proc sql;
select type, drivetrain
		,min(invoice) as minimum_val
		,max(invoice) as maximum_val
		,mean(invoice) as mean_val
		,avg(invoice) as avg_val
		,range(invoice) as range_val
		,std(invoice) as std_val
		,sum(invoice) as sum_val
	from sashelp.cars
	group by type, drivetrain; /* we can also write group by 1 - 1st variable */
quit;

/* JOINS */
/* first we make tables required for this ex */
data class1;
set sashelp.class (keep= name sex age obs=8);
run;
data class2;
set sashelp.class (keep=name height weight obs=15 firstobs=6);
run;

/* left join */
proc sql;
select a.name /* tables are defined as a and b, so selecting the variables within them */
		,a.sex
		,a.age
		,b.height
		,b.weight
from class1 as a
left join class2 as b
on a.name = b.name;
quit;

/* alternate */
proc sql;
select a.* /* since all vars/cols are selected for table a, we can use '*' */
		,b.height
		,b.weight
from class1 as a
left join class2 as b
on a.name = b.name;
quit;

/* right join */
proc sql;
select a.* /* since all vars/cols are selected for table a, we can use '*' */
		,b.height
		,b.weight
from class1 as a
right join class2 as b
on a.name = b.name;
quit;

/* inner join */
proc sql;
select a.* /* since all vars/cols are selected for table a, we can use '*' */
		,b.height
		,b.weight
from class1 as a
inner join class2 as b
on a.name = b.name;
quit;

/* full join */
proc sql;
select a.* /* since all vars/cols are selected for table a, we can use '*' */
		,b.height
		,b.weight
from class1 as a
full join class2 as b
on a.name = b.name;
quit;

/* a merge requires a common col name, but join just requires a column with common shared values - name can be diff */
/* merge needs the tables to be sorted on the common variable - not join */

/* cross join or cartesian join */
/* table 1 has 3 rows, table 2 has 2 rows, crossjoin will have 3 x 2 = 6 rows */

/* let us make tables for this ex */
data personal;
input name $ sex $ age;
cards;
John M 23
Jane F 21
James M 22
;
run;

data physical;
input height;
cards;
5.25
5.5
5.8
;
run;

/* now let's join */
proc sql;
select a.*
		,b.height
from personal as a
cross join physical as b; /* no need to provide 'on' statement in cross join */
quit;

/* what of we have to put the result of a sql statement in a table */
/* let us look at example bellow */
proc sql;
create table combined as /* add this statement with a table name*/
select a.*
		,b.height
from personal as a
cross join physical as b; /* no need to provide 'on' statement in cross join */
quit;

