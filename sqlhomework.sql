-- 1a.
SELECT * FROM sakila.actor;


-- 1b.

SELECT CONCAT(first_name, " ", last_name) As ActorName 
FROM actor;


-- 2a.

SELECT actor_id, first_name, last_name 
FROM sakila.actor WHERE first_name = 'Joe';


-- 2b.

SELECT last_name 
FROM sakila.actor 
Where last_name like '%GEN%'; 

-- 2c.

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. 

SELECT country_id, country 
FROM sakila.country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a.

USE sakila; 
Alter table actor 
ADD description BLOB(50); 

-- 3b. 

Alter table actor 
DROP description; 

-- 4a. 

SELECT count(first_name), last_name
from actor 
GROUP BY (last_name);

-- 4b. 

SELECT count(first_name) as 'Count > 2', last_name
from actor 
GROUP BY (last_name)
HAVING COUNT(first_name) >= 2;

-- 4c 

UPDATE actor 
set first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

SELECT * FROM actor WHERE last_name = 'WILLIAMS';

-- 4d

UPDATE actor 
set first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a 

SELECT * FROM address;

SHOW CREATE TABLE sakila.address;

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- 6a 

SELECT first_name, last_name, address 
FROM staff  
INNER JOIN address ON
staff.address_id = address.address_id; 

-- 6b

SELECT * FROM staff;
SELECT * FROM payment;

SELECT  first_name, last_name, sum(amount) as 'Total Amount'
FROM staff  
INNER JOIN payment ON
staff.staff_id = payment.staff_id 
WHERE payment_date like '2005-08%'
GROUP BY staff.first_name, staff.last_name;

-- 6c

SELECT * FROM film;
SELECT * FROM film_actor;

SELECT  title, count(actor_id)
FROM film_actor  
INNER JOIN film ON
film_actor.film_id = film.film_id
GROUP BY film.title;

-- 6d

SELECT * FROM inventory;
SELECT * FROM film;


SELECT title, count(inventory.film_id)
FROM inventory 
INNER JOIN film ON
inventory.film_id = film.film_id
where title = 'Hunchback Impossible';

-- 6e

SELECT * FROM customer;
SELECT * FROM payment;

SELECT first_name, last_name, sum(amount) as 'Total Amount Paid' 
FROM customer  
JOIN payment ON
payment.customer_id = customer.customer_id 
GROUP BY payment.customer_id
ORDER BY last_name;

-- 7a 

SELECT * FROM film;
SELECT * FROM language;

SELECT title FROM film
WHERE language_id IN 
	(SELECT language_id FROM language 
	WHERE name = 'English')
AND (title LIKE 'K%') OR (title LIKE 'Q%');

-- 7b 
SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM film_actor;

SELECT first_name, last_name 
FROM actor
WHERE actor_id IN 
	(SELECT actor_id 
    FROM film_actor 
    where film_id IN
      (SELECT film_id
      FROM film
      where title = 'Alone Trip'
		)
);

-- 7c 

SELECT * FROM customer;
SELECT * FROM country;
SELECT * FROM city;

SELECT first_name, last_name, email, country
FROM customer  
JOIN address ON address.address_id = customer.address_id 
JOIN city ON city.city_id = address.city_id 
JOIN country ON country.country_id = city.country_id 
WHERE country.country = 'Canada';


-- 7d 

SELECT * FROM film_category;
SELECT * FROM category;
SELECT * FROM film;


SELECT title, name 
FROM film  
JOIN film_category ON film.film_id = film_category.film_id 
JOIN category ON category.category_id = film_category.category_id 
WHERE category.name = 'Family';

-- 7e

SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film;

SELECT title, count(rental.inventory_id) as 'Count'
FROM rental  
JOIN inventory ON rental.inventory_id = inventory.inventory_id 
JOIN film ON inventory.film_id = film.film_id 
GROUP BY title 
ORDER BY count(rental.inventory_id) DESC;

-- 7f

SELECT * FROM store;
SELECT * FROM staff;
SELECT * FROM payment;

SELECT store.store_id, sum(payment.amount) as 'Total Amount'
FROM store  
JOIN staff ON store.store_id = staff.store_id 
JOIN payment ON payment.staff_id = staff.staff_id 
GROUP BY store.store_id ;


-- 7g 

SELECT * FROM store;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

SELECT store.store_id, city, country
FROM store  
JOIN address ON store.address_id = address.address_id 
JOIN city ON city.city_id = address.city_id 
JOIN country ON country.country_id = city.country_id 
GROUP BY store.store_id; 


-- 7h  

SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM payment;
SELECT * FROM rental;

SELECT category.name, sum(amount) as 'Gross Revenue'
FROM category  
JOIN film_category ON category.category_id = film_category.category_id 
JOIN inventory ON film_category.film_id = inventory.inventory_id 
JOIN rental ON inventory.inventory_id = rental.inventory_id 
JOIN payment ON rental.rental_id  = payment.rental_id
GROUP BY category.name
ORDER BY sum(amount) DESC 
LIMIT 5;

-- 8a 

CREATE VIEW Top_five_genres as
SELECT category.name, sum(amount) as 'Gross Revenue'
FROM category  
JOIN film_category ON category.category_id = film_category.category_id 
JOIN inventory ON film_category.film_id = inventory.inventory_id 
JOIN rental ON inventory.inventory_id = rental.inventory_id 
JOIN payment ON rental.rental_id  = payment.rental_id
GROUP BY category.name
ORDER BY sum(amount) DESC 
LIMIT 5;

-- 8b 

SELECT * FROM Top_five_genres;

-- 8C 

DROP VIEW Top_five_genres;






























