--Data from OurWorldInData.com
--Creating a table for each decade
drop table if exists #AvgTempDecades
create table #AvgTempDecades (Decades varchar(50), AvgTemp decimal(16,2))

--Populating the table
insert into #AvgTempDecades
select '1922-1932', cast(avg("average temperature") as decimal(16,2)) from avgtemp100
where year(year) between 1922 and 1932
insert into #AvgTempDecades
select '1932-1942', cast(avg("average temperature") as decimal(16,2)) from avgtemp100
where year(year) between 1932 and 1942
insert into #AvgTempDecades
select '1942-1952', cast(avg("average temperature") as decimal(16,2)) from avgtemp100
where year(year) between 1942 and 1952
insert into #AvgTempDecades
select '1952-1962', cast(avg("average temperature") as decimal(16,2)) from avgtemp100
where year(year) between 1952 and 1962
insert into #AvgTempDecades
select '1962-1972', cast(avg("average temperature") as decimal(16,2)) from avgtemp100
where year(year) between 1962 and 1972
insert into #AvgTempDecades
select '1972-1982', cast(avg("average temperature") as decimal(16,2)) from avgtemp100
where year(year) between 1972 and 1982
insert into #AvgTempDecades
select '1982-1992', cast(avg("average temperature") as decimal(16,2)) from avgtemp100
where year(year) between 1982 and 1992
insert into #AvgTempDecades
select '1992-2002', cast(avg("average temperature") as decimal(16,2)) from avgtemp100
where year(year) between 1992 and 2002
insert into #AvgTempDecades
select '2002-2012', cast(avg("average temperature") as decimal(16,2)) from avgtemp100
where year(year) between 2002 and 2012
insert into #AvgTempDecades
select '2012-2022', cast(avg("average temperature") as decimal(16,2)) from avgtemp100
where year(year) between 2012 and 2022

select * from  #AvgTempDecades
--Selecting the decades acording to temperature from coldest to hottest
select decades, avgtemp ,rank() over (order by avgtemp) as ColdestDecadesRanking
from AvgTempDecades

--Selecting the decades acording to temperature from hottest to coldest
select decades, avgtemp ,rank() over (order by avgtemp desc ) as HottestDecadesRanking
from AvgTempDecades

--Selecting the years acording to temperature from hottest to coldest
select year(year) as Year , "average Temperature" as AvgTemp ,rank() over (order by "average Temperature" desc ) as HottestDecadesRanking
from AvgTemp100

--Selecting the years acording to temperature from coldest to hottest
select year(year) as Year, "average Temperature" as AvgTemp ,rank() over (order by "average Temperature") as ColdestDecadesRanking
from AvgTemp100
