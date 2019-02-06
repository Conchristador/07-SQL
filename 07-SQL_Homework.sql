#1a. Display the first and last names of all actors from the table actor
USE sakila;
SHOW TABLES;
SELECT * FROM actor;
SELECT first_name, last_name FROM actor;
#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(first_name, " ", last_name) as "Actor Name" FROM actor;
#2a. ID, first and last name of actor named "Joe"
SELECT actor_id, first_name, last_name FROM actor WHERE first_name= "Joe";
#2b. Find all actors whose last name contain the letters GEN: 
SELECT * FROM actor 
WHERE last_name rLIKE "(GEN)(\d+)?";
#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor 
WHERE last_name rLIKE "(LI)(\d+)?" ORDER BY last_name, first_name;
#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country 
WHERE country in ("Afghanistan", "Bangladesh", "China");
#3a. add middle name to the actor table
ALTER TABLE actor
ADD column middle_name VARCHAR(45) NULL AFTER first_name;
ALTER TABLE actor
MODIFY column middle_name blob;
#3b. Delete the description column.
ALTER TABLE actor
DROP column middle_name;
SELECT * FROM actor;
#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) as count_of_actor
FROM actor
GROUP BY last_name;
#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) as count_of_actor
FROM actor
GROUP BY last_name HAVING COUNT(*) >=2;
#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO" 
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";
#4d.  if first name = HARPO, change it to GROUCHO, otherwise change it to MUCHO GROUCHO
UPDATE actor
SET first_name = "GROUCHO" 
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";
-- SELECT * FROM actor WHERE first_name = "GROUCHO";
#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW COLUMNS FROM address;
#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address 
FROM staff 
JOIN address ON staff.address_id = address.address_id;
#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff_id, SUM(payment.amount) AS 'Sum of Payment' 
FROM staff 
JOIN payment USING (staff_id) 
WHERE payment_date between '2005-08-01' AND '2005-08-31' 
GROUP BY staff_id;
#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT title, COUNT(*) AS num_actors
FROM film
JOIN film_actor fa USING (film_id)
GROUP BY film_id
#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(*) 
FROM inventory
JOIN film USING(film_id)
WHERE title = "HUNCHBACK IMPOSSIBLE";
#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount) AS "Total Amount Paid"
FROM customer
JOIN payment USING(customer_id)
GROUP BY customer_id
ORDER BY last_name, first_name;
#7a: display titles of movies beginning with K and Q whose language is English
SELECT title FROM film
JOIN language USING(language_id)
WHERE name = "English"
and (title LIKE "Q%" or title LIKE "K%");
#7 OTHER
SELECT title FROM film
JOIN language USING(language_id)
WHERE name = "English"
and title IN
 (SELECT title FROM film WHERE title LIKE "Q%" or title LIKE "K%");
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name 
FROM film_actor 
JOIN film USING(film_id) 
JOIN actor USING(actor_id) 
WHERE title = "ALONE TRIP";
#7c. names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email 
FROM customer 
JOIN address USING(address_id) 
JOIN city USING(city_id) 
JOIN country USING(country_id) 
WHERE country = "Canada";
#7d List family films
SELECT title, description, rating FROM film_list 
WHERE category = "Family";
#7e Most freqently rented movies in descending order (more than 10 rentals)
SELECT title, COUNT(*) AS rental_count 
FROM film
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
GROUP BY film_id
HAVING rental_count > 10
ORDER BY rental_count DESC;
#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT * FROM sales_by_store;
#7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store
JOIN address USING(address_id)
JOIN city USING(city_id)
JOIN country USING(country_id);
#7h. List the top five genres in gross revenue in descending order.
SELECT * FROM sales_by_film_category
ORDER BY total_sales desc; 
#8a: create a view of the top 5 genres by gross revenue
DROP view if exists top_five_genres;
CREATE view top_five_genres (category, total_sales) AS 
SELECT * FROM sales_by_film_category
ORDER BY total_sales desc
limit 5;
#8b: display the view just created
SELECT * FROM top_five_genres;
#8c: no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;