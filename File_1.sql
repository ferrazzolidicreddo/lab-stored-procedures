USE sakila;

select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email;

# Adapting the code
DELIMITER //
CREATE PROCEDURE name_email_proc(in cat_name varchar(25))
BEGIN
	SELECT first_name, last_name, email, category.name
	FROM customer
	JOIN rental ON customer.customer_id = rental.customer_id
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON film.film_id = inventory.film_id
	JOIN film_category ON film_category.film_id = film.film_id
	JOIN category ON category.category_id = film_category.category_id
	WHERE category.name = cat_name
	GROUP BY first_name, last_name, email;
END
//
DELIMITER ;

# Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in
# a such manner that it can take a string argument for the category name and return the results for all
# customers that rented movie of that category/genre. For eg., it could be action, animation, children,
# classics, etc.

# Testing the code
SELECT first_name, last_name, email, category.name
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON film.film_id = inventory.film_id
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.name = 'Horror'
GROUP BY first_name, last_name, email;

# Trying with 'cat_name'
DELIMITER //
CREATE PROCEDURE name_email_proc(in cat_name varchar(25))
BEGIN
	SELECT first_name, last_name, email, category.name
	FROM customer
	JOIN rental ON customer.customer_id = rental.customer_id
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON film.film_id = inventory.film_id
	JOIN film_category ON film_category.film_id = film.film_id
	JOIN category ON category.category_id = film_category.category_id
	WHERE category.name = cat_name
	GROUP BY first_name, last_name, email;
END
//
DELIMITER ;

CALL name_email_proc('Horror');


# Trying with 'param1'
DELIMITER //
CREATE PROCEDURE name_email_proc(in param1 varchar(25))
BEGIN
	SELECT first_name, last_name, email, category.name
	FROM customer
	JOIN rental ON customer.customer_id = rental.customer_id
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON film.film_id = inventory.film_id
	JOIN film_category ON film_category.film_id = film.film_id
	JOIN category ON category.category_id = film_category.category_id
	WHERE category.name COLLATE utf8mb4_general_ci = param1
	GROUP BY first_name, last_name, email;
END
//
DELIMITER ;

CALL name_email_proc('Drama');

# Write a query to check the number of movies released in each movie category. Convert the query in
# to a stored procedure to filter only those categories that have movies released greater than a certain
# number. Pass that number as an argument in the stored procedure.

SELECT * FROM film_category;
SELECT * FROM film;
SELECT * FROM category;

# Testing the code
	SELECT count(f.release_year) AS Counter,
			f.release_year AS Release_Year,
            fc.category_id AS Film_Category,
            c.name AS Category_name
	FROM sakila.film_category AS fc
	JOIN sakila.film AS f
	ON f.film_id = fc.film_id
	JOIN sakila.category AS c
    ON c.category_id = fc.category_id    
    WHERE release_year > 2005
    GROUP BY release_year;
    
# Building the procedure
DROP PROCEDURE check_release_year;

DELIMITER //
CREATE PROCEDURE check_release_year (in param1 int)
BEGIN
	SELECT count(f.release_year) AS Counter, f.release_year AS Release_Year, fc.category_id AS Film_Category
	FROM sakila.film_category AS fc
	JOIN sakila.film AS f
	ON f.film_id = fc.film_id
	WHERE release_year >= param1
    GROUP BY release_year;
END
//
DELIMITER ;

CALL check_release_year (2006);