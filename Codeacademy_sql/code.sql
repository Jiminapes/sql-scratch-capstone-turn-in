Queries for the slide deck questions - 

How many months has the company been operating?
Which months do you have enough information to calculate a churn rate? 

select min(subscription_start),
 max(subscription_start) 
 from subscriptions;

What segments of users exist?

select * 
 from subscriptions
 group by segment;

What is the overall churn trend since the company started?

with months as
(select 
'2017-01-01' as first_day,
'2017-01-31' as last_day
 union
 select
'2017-02-01' as first_day,
'2017-02-28' as last_day
union
select
 '2017-03-01' as first_day,
'2017-03-31' as last_day
 ),
 cross_join as
 (select subscriptions.*, months.*
  from subscriptions
  cross join months
  ),
  status as
  (select 
   id, 
   first_day as month,
   case
   when (subscription_start < first_day)
   and
   (subscription_end > first_day or subscription_end is null)
   then 1
   else 0
   end as is_active,
   case
   when (subscription_end between first_day and last_day)
   then 1
   else 0
   end as is_canceled 
   from cross_join
  ),
   status_aggregate as
  (select month,
   sum (is_active) as sum_active,
   sum (is_canceled) as sum_canceled
   from status
   group by month
  )
  select month, 1.0 *
  sum_canceled/sum_active
  as churn_rate_total
  from status_aggregate;

Compare the churn rates between user segments.

with months as
(select 
'2017-01-01' as first_day,
'2017-01-31' as last_day
 union
 select
'2017-02-01' as first_day,
'2017-02-28' as last_day
union
select
 '2017-03-01' as first_day,
'2017-03-31' as last_day
 ),
 cross_join as
 (select subscriptions.*, months.*
  from subscriptions
  cross join months
  ),
  status as
  (select 
   id, 
   first_day as month,
   case
   when (subscription_start < first_day)
   and
   (subscription_end > first_day or subscription_end is null)
   and (segment = 87) 
   then 1
   else 0
   end as is_active_87,
   case
   when (subscription_start < first_day)
   and
   (subscription_end > first_day or subscription_end is null)
   and (segment = 30) 
   then 1
   else 0
   end as is_active_30,
   case
   when (subscription_end between first_day and last_day)
   and (segment = 87) 
   then 1
   else 0
   end as is_canceled_87,
   case
   when (subscription_end between first_day and last_day)
   and (segment = 30) 
   then 1
   else 0
   end as is_canceled_30   
   from cross_join
  ),
  status_aggregate as
  (select month,
 	sum (is_active_87) as sum_active_87,
   sum (is_active_30) as sum_active_30,
   sum (is_canceled_87) as sum_canceled_87,
   sum (is_canceled_30) as sum_canceled_30
   from status
   group by month
  )
  select month, 1.0 *
  sum_canceled_87/sum_active_87
  as churn_rate_87,
  1.0 *
  sum_canceled_30/sum_active_30
  as churn_rate_30
  from status_aggregate;

--------------------------------------------

Queries for project questions 1-9

1.
 select * 
 from subscriptions
 limit 100;

2 segments, 87 and 30 

2.
 select min(subscription_start),
 max(subscription_start) 
 from subscriptions;

min(subscription_start) 	max(subscription_start)
2016-12-01 	2017-03-30

Can calculate churcn for 3 months, Jan-March 2017

3.
with months as
(select 
'2017-01-01' as first_day,
'2017-01-31' as last_day
 union
 select
'2017-02-01' as first_day,
'2017-02-28' as last_day
union
select
 '2017-03-01' as first_day,
'2017-03-31' as last_day
 ),


4.
with months as
(select 
'2017-01-01' as first_day,
'2017-01-31' as last_day
 union
 select
'2017-02-01' as first_day,
'2017-02-28' as last_day
union
select
 '2017-03-01' as first_day,
'2017-03-31' as last_day
 ),
 cross_join as
 (select * from subscriptions
  cross join months
 ),

5.
status as
  (select 
   id, 
   first_day as month,
   case
   	when (subscription_start < first_day)
   and
   (subscription_end > first_day or subscription_end is null)
   and (segment = 87) 
   then 1
   else 0
   end as is_active_87,
    case
   	when (subscription_start < first_day)
   and
   (subscription_end > first_day or subscription_end is null)
   and (segment = 30) 
   then 1
   else 0
   end as is_active_30
   from cross_join
  ),

6.
case
   	when (subscription_end between first_day and last_day)
   and (segment = 87) 
   then 1
   else 0
   end as is_canceled_87,
   case
   	when (subscription_end between first_day and last_day)
   and (segment = 30) 
   then 1
   else 0
   end as is_calnceled_30   
   from cross_join
  ),


7.
  status_aggregate as
  (select month,
 	sum (is_active_87) as sum_active_87,
   sum (is_active_30) as sum_active_30,
   sum (is_canceled_87) as sum_active_87,
   sum (is_canceled_30) as sum_active_30
   from status
   group by month
  ),




8.

  select month, 1.0 *
  sum_canceled_87/sum_active_87
  as churn_rate_87,
  1.0 *
  sum_canceled_30/sum_active_30
  as churn_rate_30
  from status_aggregate;

9. I would add a group by segments function in near the beginning. 

Put altogether the final query will look like this. 

with months as
(select 
'2017-01-01' as first_day,
'2017-01-31' as last_day
 union
 select
'2017-02-01' as first_day,
'2017-02-28' as last_day
union
select
 '2017-03-01' as first_day,
'2017-03-31' as last_day
 ),
 cross_join as
 (select subscriptions.*, months.*
  from subscriptions
  cross join months
  ),
  status as
  (select 
   id, 
   first_day as month,
   case
   	when (subscription_start < first_day)
   and
   (subscription_end > first_day or subscription_end is null)
   and (segment = 87) 
   then 1
   else 0
   end as is_active_87,
    case
   	when (subscription_start < first_day)
   and
   (subscription_end > first_day or subscription_end is null)
   and (segment = 30) 
   then 1
   else 0
   end as is_active_30,
   case
   	when (subscription_end between first_day and last_day)
   and (segment = 87) 
   then 1
   else 0
   end as is_canceled_87,
   case
   	when (subscription_end between first_day and last_day)
   and (segment = 30) 
   then 1
   else 0
   end as is_canceled_30   
   from cross_join
  ),
  status_aggregate as
  (select month,
 	sum (is_active_87) as sum_active_87,
   sum (is_active_30) as sum_active_30,
   sum (is_canceled_87) as sum_canceled_87,
   sum (is_canceled_30) as sum_canceled_30
   from status
   group by month
  )
  select month, 1.0 *
  sum_canceled_87/sum_active_87
  as churn_rate_87,
  1.0 *
  sum_canceled_30/sum_active_30
  as churn_rate_30
  from status_aggregate;


