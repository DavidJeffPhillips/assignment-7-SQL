USE sakila;
SELECT * FROM actor
WHERE last_name = 'WILLIAMS';
-- 1a
SELECT first_name FROM actor;
-- 1b
ALTER TABLE actor
ADD actor_name varchar(50);
UPDATE actor
SET actor_name = concat(first_name, ' ', last_name);
-- 2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "JOE";
-- 2b
SELECT *
FROM actor
WHERE last_name LIKE "%GEN%";
-- 2c
SELECT *
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;
-- 2d
SELECT country_id, country
FROM country
WHERE country IN('Afghanistan', 'Bangladesh', 'China');
-- 3a
ALTER TABLE actor
ADD description BLOB;
-- 3b
ALTER TABLE actor
DROP COLUMN description;
-- 4a
SELECT last_name, Count(*) AS `occurrences`
FROM actor
GROUP BY last_name;
-- 4b
SELECT last_name, Count(*) AS `occurrences`
FROM actor
GROUP BY last_name
HAVING `occurrences` > 1;
-- 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS';
-- 4d
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
AND last_name = 'WILLIAMS';
-- 5a
SHOW CREATE TABLE address;
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
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id = address.address_id;
-- 6b
SELECT * FROM payment;
DROP TABLE aug2005;

SELECT staff.first_name, staff.last_name, payment.amount, payment.payment_date
FROM staff
JOIN payment ON
staff.staff_id = payment.staff_id
WHERE payment_date LIKE "2005-08%";
SELECT aug2005.first_name, aug2005.last_name, sum(aug2005.amount)
FROM aug2005
GROUP BY first_name
;

-- 6c
SELECT film.title, Count(film_actor.actor_id) AS `number of actors`
FROM film
INNER JOIN film_actor ON
film_actor.film_id = film.film_id
GROUP BY film.title;
-- 6d
SELECT film.title, Count(inventory.inventory_id) AS `total in inventory`
FROM film
JOIN inventory ON
film.film_id = inventory.film_id
GROUP BY film.title;
-- 6e
SELECT customer.first_name, customer.last_name, sum(payment.amount) AS `total amount paid`
FROM customer
JOIN payment ON
customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;
-- 7a
SELECT * FROM film;
SELECT * FROM language;
SELECT film.title
FROM film
WHERE language_id IN
	(SELECT language_id
	FROM language
	WHERE name = "English")
AND film.title LIKE "K%"
OR film.title LIKE "Q%";
-- 7b
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id
    FROM film_actor
    WHERE film_id IN
		(SELECT film_id
        FROM film
        WHERE title = "Alone Trip"
));
-- 7c
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
WHERE address_id IN
	(SELECT address_id
    FROM address
    WHERE city_id IN
		(SELECT city_id
        FROM city
        WHERE country_id IN
			(SELECT country_id
            FROM country
            WHERE country = "Canada"
)));
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN table3
ON t1 = t3
INNER JOIN table2
ON t3 = t2
AND t3 = t2;
-- 7d
SELECT title 
FROM film
WHERE  film_id IN(
	SELECT film_id
    FROM film_category
    WHERE category_id IN(
		SELECT category_id
        FROM category
        WHERE name = "Family"
));
-- 7e
SELECT film.title, Count(rental_id) AS `times rented`
FROM rental
INNER JOIN inventory
ON rental.inventory_id = inventory.inventory_id
	INNER JOIN film
    ON inventory.film_id = film.film_id
GROUP BY inventory.film_id
ORDER BY `times rented` Desc;
-- 7f
SELECT staff_id AS `store number`, sum(amount) AS `revenue`
FROM payment
GROUP BY staff_id;
-- 7g
SELECT store_id, address, city, country
FROM store
INNER JOIN address
ON store.address_id = address.address_id
	INNER JOIN city
    ON address.city_id = city.city_id
	INNER JOIN country
	ON city.country_id = country.country_id;
-- 7h
SELECT category.name, sum(payment.amount) AS `revenue`
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
	INNER JOIN inventory
    ON inventory.film_id = film_category.film_id
		INNER JOIN rental
        ON rental.inventory_id = inventory.inventory_id
			INNER JOIN payment
            ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY `revenue` desc
LIMIT 5;
-- 8a
CREATE VIEW top_earning_genres AS
SELECT category.name, sum(payment.amount) AS `revenue`
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
	INNER JOIN inventory
    ON inventory.film_id = film_category.film_id
		INNER JOIN rental
        ON rental.inventory_id = inventory.inventory_id
			INNER JOIN payment
            ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY `revenue` desc
LIMIT 5;
-- 8b
SELECT * FROM top_earning_genres;
-- 8c
DROP VIEW top_earning_genres;







