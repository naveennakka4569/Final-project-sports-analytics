/* 1.Create a table named ‘matches’ with appropriate data types for columns */

CREATE TABLE matches (id int, city	char (50),
date DATE,player_of_match char(50),	
venue char (50),	neutral_venue char(50),
team1 char (50),	team2 char(50),
toss_winner char(50), toss_decision	char (50),
winner char (50) ,result char (50), result_margin int ,
eliminator	char (50), method char(50),
umpire1	char (50) ,umpire2 char (50) );

Select * from matches;

alter table matches
alter column venue type char (100);


/* 3.Import data from csv file ’IPL_matches.csv’ attached in resources to ‘matches’ */

copy matches from 'C:\Users\nick\Desktop\SQL NOTES\Data for final project - IPL\Data for final project - IPL\IPL_matches.csv' delimiter ',' csv header;

/* 2. Create a table named ‘deliveries’ with appropriate data types for columns */

create table deliveries (id	int ,inning int,	
over int,	ball int,
batsman char(100) ,non_striker char(100),
bowler char(100), batsman_runs	int , extra_runs int ,
total_runs int,	is_wicket int,	
dismissal_kind char(50), player_dismissed char(50),	fielder char(100),
extras_type char(60),	batting_team char(100),
bowling_team char(100) );


select * from deliveries;

/* 4. Import data from csv file ’IPL_Ball.csv’ attached in resources to ‘matches’ */

copy deliveries from 'C:\Users\nick\Desktop\SQL NOTES\Data for final project - IPL\Data for final project - IPL\IPL_Ball.csv' delimiter ',' csv header;

select * from deliveries;

/* 4 .Select the top 20 rows of the deliveries table. */

select * from deliveries 
limit(20);

/*  5. Select the top 20 rows of the matches table. */

select * from matches
limit(20) ;

/* 6. Fetch data of all the matches played on 2nd May 2013. */
select * from matches where date = '2013-05-02';

/* 7. Fetch data of all the matches where the margin of victory is more than 100 runs. */
select * from matches where result_margin > 100;

/* 8. Fetch data of all the matches where the final scores of both teams tied and order it in descending order of the date.*/
select * from matches where winner = 'NA' 
ORDER BY date desc;

/* 9. Get the count of cities that have hosted an IPL match. */
select count ( distinct city) from matches;

/* 10.Create table deliveries_v02 with all the columns of deliveries 
and an additional column ball_result containing value boundary, 
dot or other depending on the total_run (boundary for >= 4, dot for 0 and other for any other number) */

create table deliveries_v02 as table deliveries;

copy deliveries_v02 from 'C:\Users\nick\Desktop\SQL NOTES\Data for final project - IPL\Data for final project - IPL\IPL_Ball.csv' delimiter ',' csv header;


select * from deliveries_v02;

alter table deliveries_v02
 add ball_result char(50);

update  deliveries_v02
set ball_result = 'boundary'
where batsman_runs >=4;

update  deliveries_v02
set ball_result = 'dot'
where batsman_runs = 0;

update  deliveries_v02
set ball_result = 'other'
where batsman_runs in (1,2,3);

/* 12. Write a query to fetch the total number of boundaries and dot balls */
select ball_result ,count(ball_result) from deliveries_v02 group by ball_result;

/* 13. Write a query to fetch the total number of boundaries scored by each team */
select batting_team , count(ball_result) as boundaries_count from deliveries_v02
where ball_result ='boundary'  group by batting_team ;

/* 14. write a query to fetch the total number of dot balls bowled by each team */
select batting_team , count(ball_result) as dot_count from deliveries_v02
where ball_result ='dot'  group by batting_team order by dot_count desc ;

/* 15. Write a query to fetch the total number of dismissals by dismissal kinds */
select * from deliveries_v02;

select dismissal_kind , count(dismissal_kind) as out_types  from  deliveries group by dismissal_kind order by out_types desc  ;



/* 16.Write a query to get the top 5 bowlers who conceded maximum extra runs */
select * from deliveries_v02;

select bowler , sum(extra_runs) as conceded_runs from deliveries group by bowler order by conceded_runs   desc limit 5;

select count (distinct id ), bowler from deliveries where bowler = 'B Kumar' group by bowler;

select bowler, sum(is_wicket) as wickets from deliveries group by bowler order by wickets desc ;

select a.bowler as best_bowler_alltime , sum(a.total_runs) as conceded
from deliveries as a inner join (select team1, id  from matches where team1 ='Kolkata Knight Riders') as b
on a.id = b.id 
group by best_bowler_alltime
order by conceded desc;

select batsman, sum(total_runs) as best_batsman from deliveries group by batsman 
order by best_batsman desc;

/* 17. Write a query to create a table named deliveries_v03 
with all the columns of deliveries_v02 table and two additional column 
(named venue and match_date) of venue and date from table matches */


insert into deliveries_v03 select * from deliveries_v02;
create table deliveries_v03  as table deliveries_v02 ;
select * from deliveries_v03 ;

create table deliveries_v03_1 as
(select x.* , y.venue  , y.date as match_date 
from 
deliveries_v03 as x left join ( select venue , date , id from matches ) as y
on x.id = y.id );


/* 18. Write a query to fetch the total runs scored for each venue and
 order it in the descending order of total runs scored. */

select * from deliveries_v03_1;

select extract(year from match_date) as IPL_year, sum(total_runs) as runs from deliveries_v03_1
where venue = 'Eden Gardens' group by IPL_year order by runs desc;

/* 19.Write a query to fetch the year-wise total runs scored at 
Eden Gardens and order it in the descending order of total runs scored. */

select m.venue,m.date sum(n.total_runs) as venue_wise_runs
from matches as m inner join deliveries  as n
on m.id = n.id  
group by m.venue 
order by venue_wise_runs desc;




/* 20. Get unique team1 names from the matches table, 
you will notice that there are two entries for Rising Pune Supergiant one with Rising Pune Supergiant 
and another one with Rising Pune Supergiants.  
Your task is to create a matches_corrected table with two additional columns team1_corr and
 team2_corr containing team names with replacing Rising Pune Supergiants with Rising Pune Supergiant. 
Now analyse these newly created columns. */

select distinct team1 from matches;

create table matches_corrected as table matches ;

select * from matches_corrected;

alter table matches_corrected 
add column team1_corr char(50) ;

alter table matches_corrected 
add column team2_corr char(50);

update matches_corrected
set team1_corr = team1 , team2_corr = team2;

update matches_corrected 
set team1_corr = 'Rising Pune Supergiant'
where team1 ='Rising Pune Supergiants' ;

update matches_corrected 
set team2_corr = 'Rising Pune Supergiant'
where team2 ='Rising Pune Supergiants' ;

select * from matches_corrected 
where team1_corr = 'Rising Pune Supergiants' or team2_corr ='Rising Pune Supergiants';




/* 21. Create a new table deliveries_v04 with the first column 
as ball_id containing information of match_id, inning, over and 
ball separated by ‘-’ (For ex. 335982-1-0-1 match_id-inning-over-ball)
 and rest of the columns same as deliveries_v03) */

select * from deliveries_v03 ;

create table deliveries_v04 as table deliveries_v03_1;

alter table deliveries_v04 
add column  ball_id varchar(100) ;

select * from deliveries_v03_1;

drop table deliveries_v04;

create table deliveries_v04 as 
(select id||'-'||inning||'-'||over||'-'||ball as ball_id ,  * from deliveries_v03_1 );

select * from deliveries_v04;


/* 22.Compare the total count of rows and total count of distinct ball_id in deliveries_v04; */
select count (id),count (distinct ball_id) from deliveries_v04;

/* 23.Create table deliveries_v05 with all columns of deliveries_v04 and 
an additional column for row number partition over ball_id.
 (HINT :  row_number() over (partition by ball_id) as r_num) */

create table deliveries_v05 as table deliveries_v04;

drop table deliveries_v05;

create table deliveries_v05 as select *, row_number() over (partition by ball_id) as r_num from
deliveries_v04;

/* 24. Use the r_num created in deliveries_v05 to identify instances
 where ball_id is repeating. 
(HINT : select * from deliveries_v05 WHERE r_num=2;) */ 

select * from deliveries_v05 ;

select count(*) from deliveries_v05;
select count (distinct ball_id) from deliveries_v05;
select sum(r_num) from deliveries_v05;
select * from deliveries_v05 order by r_num limit 20;
select * from deliveries_v05 WHERE r_num=2;

/* 25.Use subqueries to fetch data of all the ball_id which are repeating. 
(HINT: SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=2);*/

SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE
r_num=2);








