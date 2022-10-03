create database pizza_runner;

create table Runners
(
runner_id int,
registration_date date
);

insert into runners
( runner_id, registration_date)
values
(1, "2021-01-01"),
(2, "2021-01-03"),
(3, "2021-01-08"),
(4, "2021-01-15");

create table customer_orders
(
order_id int,
customer_id int,
pizza_id int,
exclusion varchar(4),
extras varchar(4),
order_date timestamp
);


insert into customer_orders
(order_id,customer_id,pizza_id,exclusion,extras,order_date)
values
(1,101,1,0,0,"2021-01-01 18:05:02"),
(2,101,1,0,0,"2021-01-01 19:00:52"),
(3,102,1,0,0,"2021-01-02 23:51:23"),
(3,102,2,0,null,"2021-01-02 23:51:23"),
(4,103,1,4,0,"2021-01-04 13:23:46"),
(4,103,1,4,0,"2021-01-04 13:23:46"),
(4,103,1,4,0,"2021-01-04 13:23:46"),
(5, 104,1,null,1,"2021-01-08 21:00:29"),
(6,101,2,null,null,"2021-01-08 21:03:13"),
(7,105,2,null,1,"2021-01-08 21:20:29"),
(8,102,1,null,null,"2021-01-09 23:54:33"),
(9,103,1,4,"1,5","2021-01-10 11:22:59"),
(10,104,1,null,null,"2021-01-11 18:34:49"),
(10,104,1,"2,6","1,4","2021-01-11 18:34:49");


create table runner_orders
(
order_id int,
runner_id int,
pickup_time varchar(19),
distance varchar(7),
duration varchar(10),
cancellation varchar(23)
);

insert into runner_orders
(order_id,runner_id,pickup_time,distance,duration,cancellation)
values
(1,1,"2021-01-01 18:15:34","20km","32minutes",""),
(2,1,"2021-01-01 19:10:54","20km","27minutes",""),
(3,1,"2021-01-03 00:12:37","13.4km","20 mins","NAN"),
(4,2,"2021-01-04 13:53:03","23.4km","40 mins","NAN"),
(5,3,"2021-01-08 21:10:57","10km","15 mins","NAN"),
(6,3,null,null,null,"Restaurant Cancellation"),
(7,2,"2020-01-08 21:30:45","25km","25 mins",null),
(8,2,"2020-01-10 00:15:02","23.4km","15 mins",null),
(9,2,null,null,null,"customer cancellation"),
(10,1, "2020-01-11 18:50:20","10km","10 mins",null);


create table pizza_names
(
pizza_id int,
pizza_name text
);

insert into pizza_names
(pizza_id, pizza_name)
values
(1,"meat lovers"),
(2,"vegetarian");

create table pizza_recipes
(
pizza_id int,
toppings text);

insert into pizza_recipes
(pizza_id, toppings)
values
(1, "1,2,3,4,5,6,8,10"),
(2, "4,6,7,9,11,12");



create table pizza_toppings
(
topping_id int,
topping_name text
);

insert into pizza_toppings
(topping_id, topping_name)
values
(1,"Bacon"),
(2,"BBQ Sauce"),
(3,"Beef"),
(4,"Cheese"),
(5,"Chicken"),
(6,"Mushrooms"),
(7, "Onions"),
(8, "Pepperoni"),
(9, "Pepppers"),
(10,"Salami"),
(11,"Tomatoes"),
(12,"Tomato Sauce");

select * from runner_orders;
select * from runners;
select * from customer_orders;
select * from pizza_names;
select * from pizza_recipes;
select * from pizza_toppings;

---------------------------------------------------------------------------------------------
--                                         PIZZA METRICS
-- QUESTION 1
-- HOW MANY PIZZAS WERE ORDERED ?
select  COUNT(pizza_id) as "Total pizzas ordered"
from customer_orders;
-----------------------------------------------------------------------------------------------
-- QUESTION 2
-- HOW MANY VEGETARIAN AND MEATLOVERS WERE ORDERED BY EACH CUSTOMER?
select c.pizza_id, p.pizza_name,count(order_id) as "for each  pizza ordered"
from customer_orders as c
join pizza_names as p
on c.pizza_id=p.pizza_id
group by c.pizza_id
order by c.pizza_id;
------------------------------------------------------------------------------------------------
-- QUESTION 3
-- HOW MANY UNIQUE CUSTOMER ORDERS WERE MADE
select  customer_id,count( distinct (order_id)) as "unique customer orders"
from customer_orders
GROUP BY customer_id;
--------------------------------------------------------------------------------------------------
-- QUESTION 4
-- HOW MANY SUCCESSFUL ORDERS WERE DELIVERED BY EACH RUNNER?

select rr.runner_id,r.registration_date,
 count(distinct (rr.order_id)) as "successful orders"
 from runner_orders as rr
 join runners as r
 on rr.runner_id =r.runner_id
 where rr.cancellation is not null
 group by rr.runner_id,r.registration_date;
---------------------------------------------------------------------------------------------------
-- QUESTION 5
-- WHAT WAS THE MAXIMUM NUMBER OF PIZZAS DELIVERED IN A SINGLE ORDER
with max_cte as 
(
select p.pizza_name, max(distinct ( c.order_id)) as "max_pizza_order",
dense_rank() over (partition by c.order_id
order by c.order_id desc) as ranks
from customer_orders as c
join pizza_names as p
on p.pizza_id = c.pizza_id
group by p.pizza_name
)
select pizza_name, max_pizza_order
from max_cte
where ranks = 1;
-------------------------------------------------------------------------------------------------
-- QUESTION 6
-- FOR EACH CUSTOMER, HOW MANY DELIVERED PIZZAS HAD AT LEAST 1 CHANGE AND HOW MANY HAD NO CHANGES?

with changes_cte as
(
select c.customer_id,count(p.pizza_id) as "counts", p.pizza_name,
dense_rank() over(partition by customer_id 
order by count(c.pizza_id) desc) as ranks
from customer_orders as c
join pizza_names as p
on p.pizza_id = c.pizza_id
group by c.customer_id,p.pizza_name
)
select customer_id as " atleast 1 change", counts as "pizza_id", pizza_name
from changes_cte
where ranks =2;

with changes_cte as
(
select c.customer_id,count(p.pizza_id) as "counts", p.pizza_name,
dense_rank() over(partition by customer_id 
order by count(c.pizza_id) desc) as ranks
from customer_orders as c
join pizza_names as p
on p.pizza_id = c.pizza_id
group by c.customer_id,p.pizza_name
)
select customer_id as " no change", counts as "pizza_id", pizza_name
from changes_cte
where ranks =1;
---------------------------------------------------------------------------------------------------------------------
-- QUESTION 7 
-- HOW MANY PIZZAS WERE DELIVERED THAT HAD BOTH EXCLUSIONS AND EXTRAS?

with exclusion_extras_cte as
(
select c.pizza_id,p.pizza_name,count(distinct (c.exclusion)) as "exclusion",count( distinct (c.extras)) as "extras",
dense_rank() over( partition by c.pizza_id
order by p.pizza_name ) as ranks
from customer_orders as c
join pizza_names as p
on c.pizza_id =p.pizza_id
where c.exclusion is not null
order by c.pizza_id
)
select pizza_name,pizza_id,exclusion,extras
from exclusion_extras_cte
where ranks = 1;
--------------------------------------------------------------------------------------------------------------
-- QUESTION 8
-- WHAT WAS THE TOTAL VOLUME OF PIZZAS ORDERED FOR EACH HOUR OF THE DAY?

with total_pizza_per_hour as
(
select customer_id , order_id, hour(order_date) as "order_hours",
dense_rank() over ( partition by customer_id 
order by hour(order_date) desc ) as ranks
from customer_orders
GROUP BY order_id
order by customer_id

)
select customer_id, sum(order_id) as "orders", order_hours
from total_pizza_per_hour
group by customer_id;
----------------------------------------------------------------------------------------------------------------
-- QUESTION 9
-- WHAT WAS THE VOLUMN OF ORDERS FOR EACH DAY OF THE WEEK?
with total_pizza_per_day_of_the_week_cte as
(
select customer_id , order_id, dayofweek(order_date) as "order_days",
dense_rank() over ( partition by customer_id 
order by dayofweek(order_date) desc ) as ranks
from customer_orders
GROUP BY order_id
order by customer_id

)
select customer_id, sum(order_id) as "orders", order_days
from total_pizza_per_day_of_the_week_cte
group by customer_id;
-----------------------------------------------------------------------------------------------------------------
--                                 RUNNER AND CUSTOMER EXPERIENCE
-- QUESTION 1
-- HOW MANY RUNNERS SIGNED UP FOR EACH 1 WEEK PERIOD?

select runner_id , registration_date, week(registration_date) as "signed 1 week period apart"
from runners 
GROUP BY runner_id;
-----------------------------------------------------------------------------------------------------------------
-- QUESTION 2
-- WHAT WAS THE AVERAGE TIME IN MINUTES IT TOOK FOR EACH RUNNER TO ARRIVE AT THR PIZZA RUNNER HQ TO PICKUP THE ORDER?

with avg_pickup_time as 
(
select r.runner_id, r.pickup_time, minute(r.pickup_time) as minutes_per_pickup,
dense_rank() over (partition by r.runner_id
order by r.pickup_time desc) as ranks
from runner_orders as r
join runners as rr
on r.runner_id = rr.runner_id
group by runner_id
)
select runner_id, pickup_time, avg(minutes_per_pickup) as "avg minutes per pickup"
from avg_pickup_time
GROUP BY runner_id;
----------------------------------------------------------------------------------------------
-- QUESTION 3 
-- IS THERE ANY RELATIONSHIP BETWEEN THE NUMBER OF PIZZA  AND HOW LONG THE ORDER TAKES TO PREPARE

with relationship_cte as
(
select c.order_id,  c.order_date, r.pickup_time, minute(c.order_date) as "order_date_in_minute",
 minute(r.pickup_time) as "pickup_time_in_minute",
 
 dense_rank() over (partition by order_id
 order by order_id ) as ranks
 from customer_orders as c
 join runner_orders as r
 where order_date < pickup_time
 group by order_id
 )
 select order_id, order_date, pickup_time,  order_date_in_minute,
 pickup_time_in_minute
 from relationship_cte
 ORDER BY order_id;
 ---------------------------------------------------------------------------------------------------
 -- QUESTION 4 
 -- WHAT WAS THE AVERAGE DISTANCE TRAVELLED FOR EACH CUSTOMER?
 
 with average_distance_cte as
 (
 select c.customer_id,r.distance,
 dense_rank () over(partition by c.customer_id
 order by c.customer_id ) as ranks
 from customer_orders as c
 join runner_orders as r
 on c.order_id = r.order_id
 where distance is not null
 group by customer_id
 )
 select customer_id,avg(distance) as "avg distance "
 from average_distance_cte
 GROUP BY customer_id;
 ---------------------------------------------------------------------------------------------------
 -- QUESTION 5 
 -- WHAT WAS THE DIFFERENCE BETWEEN THE LONGEST AND SHORTEST DELIVERY TIMES FOR ALL ORDERS?
 
 with longest_shortest_delivery_cte as
 (
 select order_id, max(duration) as "longest",min(duration) as "shortest",
 dense_rank() over(partition by order_id
 order by order_id ) as ranks
 from runner_orders
 where duration is not null
 group by order_id
 )
 select order_id, longest, shortest 
 from longest_shortest_delivery_cte
 group by order_id;
 
 
--------------------------------------------------------------------------------------------------------------
-- QUESTION 6
--  WHAT WAS THE AVERAGE SPEED FOR EACH RUNNER FOR EACH DELIVERY AND DO YOU NOTICE ANY TREND FOR THESE VALUES?
 
 WITH average_speed_cte as 
 (
 select rr.runner_id,rr.distance,rr.duration,
 dense_rank() over ( partition by rr.runner_id 
 order by rr.runner_id) as ranks,
 round(rr.distance *60/rr.duration) as avg_speed
 from runner_orders as rr
 join runners as r
 on rr.runner_id = r.runner_id
 where rr.duration is not null
 group by rr.runner_id
 )
 select runner_id,avg_speed
 from average_speed_cte
 WHERE distance is not null
 GROUP BY runner_id;
 ----------------------------------------------------------------------------------------
 -- QUESTION 7 
 -- WHAT IS THE SUCCESFUL DELIVERY PERCENTAGE FOR EACH RUNNER?
 
 
 -----------------------------------------------------------------------------------------
 --                            INGREDIENT OPTIMISATION
 --                                  QUESTION 1
 -- WHAT ARE THE STANDARD INGREDIENTS FOR EACH PIZZA
 with pizzas_recipes as
 (
 select 1 as pizza_id , "[1,2,3,4,5,6,8,10]" as toppings union all
 select 2, "[4,6,7,9,11,12]" 
 ),
 topping_names as 
 (
 select 1 as topping_id, "Bacon" as topping_name union all
 select 2, "BBQ Sauce" union all
 select 3, "Beef" union all
 select 4, "Cheese" union all
 select 5, "Chicken" union all
 select 6, "Mushrooms" union all
 select 7, "Onions" union all
 select 8, "Pepperoni" union all
 select 9, "Pepppers" union all
 select 10, "Salami"  union all
 select 11, "Tomatoes" union all
 select 12 "Tomato Sauce"
 )
 select * from pizza_toppings
 join pizza_recipes
 on REGEXP_LIKE ( pizza_recipes. toppings,  toppings)
 order by pizza_id;
 
 -- ALTERNATIVE
 
 CREATE TABLE TABLE_RECIPES
 (
 pizza_id INT, toppings int);

insert into TABLE_RECIPES
(pizza_id,toppings)
VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,8),(1,10),
(2,4),(2,6),(2,7),(2,9),(2,11),(2,12);

WITH STANDARD_INGREDIENTS AS 
(
 SELECT p.pizza_name,t.pizza_id,pp.topping_name
 from TABLE_RECIPES as t
 join pizza_toppings as pp
 on t.toppings=pp.topping_id
 join pizza_names as p
 on p.pizza_id = t.pizza_id
 order by p.pizza_name,t.pizza_id
 )
 select pizza_name,
        group_concat(topping_name) as STANDARD_INGREDIENT
        from STANDARD_INGREDIENTS
        GROUP BY pizza_name;
        
 -------------------------------------------------------------------------------------------------------
 --                                         QUESTION 2
 -- WHAT WAS THE MOST COMMONLY ADDED EXTRA?
 
 create table arrayss
 ( num int primary key);
 
 insert into arrayss 
 (num)
 values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14);

with extras_cte as 
(
select a.num,
substring_index(substring_index(all_tags, ',', num), ',', -1) as "one_tag"
from (
     select
        group_concat(extras separator ',') as "all_tags",
			 length(group_concat(extras separator ',')) -
             length(replace(group_concat(extras separator ','), ',', '')) +1 
             as "count_tags"
             from customer_orders 
             ) c
             join arrayss as a
             on a.num <= c.count_tags
             )
       select one_tag as 
        "extras",p.topping_name as "extras_topping",
        count(one_tag) as "most_common"
        from extras_cte as e
        join pizza_toppings as p
        on p.topping_id = e.one_tag
        where one_tag != 0
        group by one_tag
        order by most_common desc;
 
 
 
 
 ---------------------------------------------------------------------------------------------------------
 --                                        QUESTION 3
 -- WHAT WAS THE MOST COMMONLY ADDED EXCLUSION?
 
 create table arrays
 ( num int primary key);
 
 insert into arrays 
 (num)
 values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14);

with exclusion_cte as 
(
select a.num,
substring_index(substring_index(all_tags, ',', num), ',', -1) as "one_tag"
from (
     select
        group_concat(exclusion separator ',') as "all_tags",
			 length(group_concat(exclusion separator ',')) -
             length(replace(group_concat(exclusion separator ','), ',', '')) +1 
             as "count_tags"
             from customer_orders 
             ) c
             join arrays as a
             on a.num <= c.count_tags
             )
       select one_tag as 
        "exclusions",p.topping_name as "exclusion_topping",
        count(one_tag) as "most_common"
        from exclusion_cte as e
        inner join pizza_toppings as p
        on p.topping_id = e.one_tag
        where one_tag != 0
        group by one_tag
        order by most_common desc;
     
 ---------------------------------------------------------------------------------------------------------
 --                                        QUESTION 4
-- The Pizza Runners team now wants to add an additional ratings system that allows customers to rate thier
-- runner, how wounld you design an additional table for this new dataset 
-- Generate a schema for this new table and insert your own data for rating for each successful customer order
-- between 1 to 5

CREATE TABLE RUNNERS_RATING
(order_id int,rating int);

INSERT INTO RUNNERS_RATING
( order_id , rating)
VALUES
(1,4),(2,3),(3,2),(4,5),(5,4),(7,3),(8,1),(10,5);

-------------------------------------------------------------------------------------------------------------
--                                       QUESTION 5
-- Using your newly generated table can you jion all the information together to form a table which has the 
-- following information for successful deliveries

select c.customer_id,c.order_id,r.runner_id,rr.rating,c.order_date,r.pickup_time,
timestampdiff(minute,order_date,pickup_time) as "Time_between_order_and_pickup",
r.duration,round(avg(r.distance * 60/r.duration),1) as "avgspeed",
count(c.pizza_id) as "pizza count"
from customer_orders as c
join runner_orders as r
on c.order_id=r.order_id
join RUNNERS_RATING as rr
on rr.order_id = c.order_id
group by c.customer_id,c.order_id,r.runner_id,rr.rating,
c.order_date,r.pickup_time,Time_between_order_and_pickup,
r.duration
order by customer_id;