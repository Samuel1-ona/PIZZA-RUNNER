# PIZZA-RUNNER
8 WEEK SQL CHALLANGE


                                                                           Introduction
                                                                           
Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers

                                                                         Table 1: runners
The (runners) table shows the (registration_date) for each new runner  

                                                                         Table 2: customer_orders
                                                                         
Customer pizza orders are captured in the (customer_orders) table with 1 row for each individual pizza that is part of the order.

The (pizza_id) relates to the type of pizza which was ordered whilst the (exclusions) are the (ingredient_id) values which should be removed from the pizza and the (extras) are the (ingredient_id) values which need to be added to the pizza.

Note that customers can order multiple pizzas in a single order with varying (exclusions) and (extras) values even if the pizza is the same type!

The (exclusions) and (extras) columns will need to be cleaned up before using them in your queries.    

                                                                        Table 3: runner_orders
                                                                      
After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The (pickup_time) is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The (distance) and (duration) fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

There are some known data issues with this table so be careful when using this in your queries - make sure to check the data types for each column in the schema SQL!

                                                                      Table 4: pizza_names
 At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!
 
                                                                      Table 5: pizza_recipes
  Each (pizza_id) has a standard set of (toppings) which are used as part of the pizza recipe.
  
                                                                      Table 6: pizza_toppings
  This table contains all of the (topping_name) values with their corresponding (topping_id) value
  
                                                                      
                                                                      
                                                                      
                                                                      Case Study Questions
                                                                      
                                                                      
                                                                      A. Pizza Metrics
                                                                      
 #. How many pizzas were ordered?
 
 ![total order](https://user-images.githubusercontent.com/68438893/193607305-c550e199-2f72-468e-ab48-fbef7bed4180.png)

#.How many unique customer orders were made?

![unique customer](https://user-images.githubusercontent.com/68438893/193607973-d32f03fc-512f-45e1-b9da-63f133cd1e89.png)

#.How many successful orders were delivered by each runner?

![successful orders](https://user-images.githubusercontent.com/68438893/193608785-c2b48647-f1b0-4af9-a299-df809940e4be.png)


#.How many Vegetarian and Meatlovers were ordered by each customer?

![total order for each pizza](https://user-images.githubusercontent.com/68438893/193610827-6524f78c-0ab6-4f3c-b276-35c4c9bc2cc0.png)


#.What was the maximum number of pizzas delivered in a single order?

![max pizza order](https://user-images.githubusercontent.com/68438893/193612486-c1cc1715-4248-4d7f-aa27-5cb14729780d.png)


#.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

![no change](https://user-images.githubusercontent.com/68438893/193613394-699ad207-64ec-4456-9b81-2e055682e928.png)
![with change](https://user-images.githubusercontent.com/68438893/193613511-7dbc1c13-2f6c-42c6-af09-732b08f43625.png)


#.How many pizzas were delivered that had both exclusions and extras?

![both extras and exclusion](https://user-images.githubusercontent.com/68438893/193614780-490167a1-8850-4544-9f1f-0975bff9ee97.png)


#.What was the total volume of pizzas ordered for each hour of the day?

![order sum](https://user-images.githubusercontent.com/68438893/193616842-f2383f84-fa68-45bf-9f78-7896379c9d70.png)


#.What was the volume of orders for each day of the week?  

![order days](https://user-images.githubusercontent.com/68438893/193617457-ab123190-1265-4095-a0e9-afcf2f3cfab9.png)



                                                                   B. Runner and Customer Experience
                                                                   
#.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

![signed 1 week period](https://user-images.githubusercontent.com/68438893/193620402-1d960719-dffc-4828-8142-63eb11153be4.png)


#.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

![avg time](https://user-images.githubusercontent.com/68438893/193621045-0e69b3be-f096-4e16-a060-e0e61034bc0d.png)


#.What was the average distance travelled for each customer?

![avg  distance](https://user-images.githubusercontent.com/68438893/193621818-d434fe70-1d55-45f0-9a73-de577cbbbf42.png)



#.What was the average speed for each runner for each delivery and do you notice any trend for these values?

![avg speed](https://user-images.githubusercontent.com/68438893/193622489-a74f55cd-e0da-4795-a9c1-7f19384eab53.png)



                                                                                                                           


