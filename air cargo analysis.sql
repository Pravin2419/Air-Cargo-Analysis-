create database air_cargo_analysis;
use air_cargo_analysis;
-------------------------------------------------------------------------
SELECT * FROM air_cargo_analysis.customer;
SELECT * FROM air_cargo_analysis.passengers_on_flights;
SELECT * FROM air_cargo_analysis.routes;
SELECT * FROM air_cargo_analysis.ticket_details;
--------------------------------------------------------------------------------------
# 1Create a route_details table
create table route_detail(
 route_id int unique, 
 flight_num varchar(55), 
 origin_airport varchar(50),
destination_airpor varchar(56),
aircraft_id int,
 distance_miles decimal  check (distance_miles>0));
 
------------------------------------------------------------------------------------
#2: Display passengers on routes 01 to 25
select * from passengers_on_flights 
where route_id between 1 and 25;

----- ------------------------------------------------------------------------------
#3Number of passengers and total revenue in business class
select  count(*) from  ticket_details;
SELECT  SUM(price_per_ticket) AS total_revenue
FROM ticket_details;
 #select count(*) ,sum(price_per_ticket) as total_revenue from ticket_details 
# WHERE class_id = 'Business';
 -------------------------------------------------------------------------------------------------------------------------
 #4Display full name of customers
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customer;
--------------------------------------------------------------------------------------------------------------------------
#5 Extract registered and booked customers
SELECT DISTINCT c.*
FROM customer c
JOIN ticket_details t ON c.customer_id = t.customer_id;

--------------------------------------------------------------------------------------------------------
#6Customer names based on ID and brand (Emirates)
SELECT c.first_name, c.last_name
FROM ticket_details t
JOIN customer c ON t.customer_id = c.customer_id
WHERE t.brand = 'Emirates';
----------------------------------------------------------------------------------------------------
#7Customers who traveled by Economy Plus using Group By and Having
SELECT customer_id
FROM passengers_on_flights
WHERE class_id = 'Economy Plus'
GROUP BY customer_id
HAVING COUNT(*) > 1;
------------------------------------------------------------------------------------------
#9Check if revenue has crossed 10000 using IF clause
SELECT IF(SUM(price_per_ticket) > 10000, 'Yes', 'No') AS revenue_status
FROM ticket_details;
------------------------------------------------------------------------------------------
#10Create and grant access to a new user
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON your_database.* TO 'new_user'@'localhost';
-------------------------------------------------------------------------------------------------
#11Maximum ticket price for each class using window functions

SELECT MAX(price_per_ticket) OVER (PARTITION BY class_id) AS max_ticket_price
FROM ticket_details;

-------------------------------------------------------------------------------------------
# 14View execution plan for route ID 4
EXPLAIN SELECT * FROM passengers_on_flights WHERE route_id = 4;
------------------------------------------------------------------------------------------------
#15Calculate total price using ROLLUP function
SELECT customer_id, aircraft_id, SUM(price_per_ticket) AS total_price
FROM ticket_details
GROUP BY ROLLUP(customer_id, aircraft_id);
-------------------------------------------------------------------------------------------------------
#16Create a view with business class customers and airline brand
CREATE VIEW business_class_view AS
SELECT c.*, t.brand
FROM customer c
JOIN ticket_details t ON c.customer_id = t.customer_id
WHERE t.class_id = 'Business';
-------------------------------------------------------------------------------------------
#17 Create a stored procedure to get details of passengers
DELIMITER //
CREATE PROCEDURE GetPassengerDetails(IN route_start INT, IN route_end INT)
BEGIN
    SELECT *
    FROM passengers_on_flights
    WHERE route_id BETWEEN route_start AND route_end;
END //
DELIMITER ;
----------------------------------------------------------------------------------------
#18Create a stored procedure for routes with distance more than 2000 miles
DELIMITER //
CREATE PROCEDURE GetLongDistanceRoutes()
BEGIN
    SELECT *
    FROM routes
    WHERE distance_miles > 2000;
END //
DELIMITER ;
--------------------------------------------------------------------------------------
#19 Create a stored procedure to categorize distances
DELIMITER //
CREATE PROCEDURE CategorizeDistances()
BEGIN
    SELECT *,
           CASE
               WHEN distance_miles <= 2000 THEN 'SDT'
               WHEN distance_miles <= 6500 THEN 'IDT'
               ELSE 'LDT'
           END AS distance_category
    FROM routes;
END //
DELIMITER ;
------------------------------------------------------------------------------------
#20 Create a stored function for complimentary services

DELIMITER //
CREATE FUNCTION ComplimentaryServices(class_id VARCHAR(20))
RETURNS VARCHAR(3)
BEGIN
    IF class_id IN ('Business', 'Economy Plus') THEN
        RETURN 'Yes';
    ELSE
        RETURN 'No';
    END IF;
END //
DELIMITER ;

--------------------------------------------------------------------------------


