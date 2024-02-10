--Data from OurWorldInData.org

/*For this project i wanted to see what influence does expenditure have on enrolment in Tertiary education
*/


--Below I will show an average of Expenditure and Enrolment

SELECT year, avg([Expenditure]) as Expenditure
FROM Government_Expenditure_on_Tertiary_Education
GROUP BY Year
ORDER BY year;

SELECT Year, avg(enrolment_ratio) as Enrolment
FROM Gross_enrolment_ratio_tertiary_education
GROUP BY Year
HAVING Year >= 1998 and year < 2016
ORDER BY year;


--I will now join the results of these 2 queries, so we can see a better picture of expenditure and enrolment ratio side by side

SELECT Exp.Year, round(avg(Expenditure),5) as Expenditure_tertiary, round(avg(Enrolment_ratio),5) as Enrolment_tertiary
FROM Government_Expenditure_on_Tertiary_Education as Exp
inner join Gross_enrolment_ratio_tertiary_education as Enr
on Exp.Year = Enr.Year
GROUP BY Exp.Year;


/*Having seen the year by year Expenditure vs Enrolment average, I want to see the 10 year difference, including the financial crysis
to answer one simple question 'How has the financial crysis affected expenditure and enrolment?'
*/
SELECT Enr.Year, avg(Expenditure) as Expenditure_tertiary, avg(Enrolment_ratio) as Enrolment_tertiary
FROM Government_Expenditure_on_Tertiary_Education as Exp
inner join Gross_enrolment_ratio_tertiary_education as Enr
on Exp.Year = Enr.Year
GROUP BY Enr.Year
HAVING Enr.Year Between 2005 AND 2015;

--I would also like to see the average Expenditure and Enrolment for Every Country

SELECT Exp.Entity AS Country, round(avg(Expenditure),5) as Expenditure_tertiary, cast(avg(Enrolment_ratio) as decimal(16,4)) as Enrolment_tertiary
FROM Government_Expenditure_on_Tertiary_Education AS Exp
inner join Gross_enrolment_ratio_tertiary_education AS Enr
on Exp.Year = Enr.Year
GROUP BY Exp.Entity;


select * from Enrolment_by_year enr
inner join expenditure_by_year exp
on enr.year = exp.year


/*Enrollment % increase from previous year
I was curious to see what the increase for enrolment and expenditure was from the previous year
of course, this is just for demonstration purposes as tableau has a quick table calculation for this */
with cte as (
SELECT year, Enrolment_ratio, row_number() over(order by year) as rn1
FROM Enrolment_by_Year)

select t1.year, coalesce((t1.enrolment_ratio - t2.enrolment_ratio)* 1.0/t2.enrolment_ratio,0) *100 as [Enrolment Increase] from cte t1
left join cte t2
on t1.rn1 = t2.rn1+1

-- Expenditure % increase from previous year
with cte as (
SELECT year, Expenditure, row_number() over(order by year) as rn1
FROM Expenditure_by_year)

select t1.year, coalesce((t1.expenditure - t2.expenditure) *1.0/t1.expenditure,0) *100 as [Expenditure Increase] from cte t1
left join cte t2
on t1.rn1 = t2.rn1+1


--Average Expenditure Increase
with cte as (
SELECT year, Expenditure, row_number() over(order by year) as rn1
FROM Expenditure_by_year)

select avg((t1.expenditure - t2.expenditure) *1.0/t1.expenditure *100) as [Expenditure Increase] from cte t1
left join cte t2
on t1.rn1 = t2.rn1+1

--Average Enrolment Increase
with cte as (
SELECT year, Enrolment_ratio, row_number() over(order by year) as rn1
FROM Enrolment_by_Year)

select avg((t1.enrolment_ratio - t2.enrolment_ratio)* 1.0/t2.enrolment_ratio *100) as [Enrolment Increase] from cte t1
left join cte t2
on t1.rn1 = t2.rn1+1