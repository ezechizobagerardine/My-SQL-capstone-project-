--SQL CAPSTONE PROJECT BY EZE CHIZOBA GERARDINE

--1. Display the customer names that share the same address (e.g. husband and wife).
select concat(customer.first_name,' ',customer.last_name) as customer_name, address.address, 
count(address.address_id) as address_count
from customer
inner join address on customer.address_id=address.address_id
group by customer.first_name, customer.last_name, address.address
having count(address.address_id)>1
order by address.address asc;

--2. What is the name of the customer who made the highest total payments?
select concat(customer.first_name,' ',customer.last_name) as customer_name, 
sum(payment.amount) as total_payment
from customer
inner join payment 
on customer.customer_id=payment.customer_id
group by customer.customer_id
order by total_payment desc
limit 1;

--3. What is the movie(s) that was rented the most?
select film.title as movie_title, 
count(rental.rental_id) as no_of_time_rented 
from film
inner join inventory on film.film_id=inventory.film_id
inner join rental on inventory.inventory_id=rental.inventory_id
group by film.title
order by no_of_time_rented desc
limit 1;

--4. Which movies have been rented so far?
select distinct film.title as movie_title
from film
inner join inventory on film.film_id=inventory.film_id
inner join rental on inventory.inventory_id=rental.inventory_id
order by movie_title asc;

--5. Which movies have not been rented so far?
select film.title as movie_title
from film
where film_id not in
    (select distinct film_id
    from inventory
    inner join rental on inventory.inventory_id=rental.inventory_id)
order by movie_title asc;

--6. Which customers have not rented any movies so far?
select concat(first_name,' ',last_name) as customer_name
from customer
where customer_id not in
    (select distinct customer_id
    from rental);

--7. Display each movie and the number of times it got rented.
select film.title as movie_title, 
count(rental_id) as no_of_time_rented
from film
left join inventory on film.film_id=inventory.film_id
left join rental on inventory.inventory_id=rental.inventory_id
group by film.title
order by movie_title asc;

--8. Show the first name and last name and the number of films each actor acted in.
select actor.first_name, actor.last_name, 
count(film_actor.film_id) as no_of_films
from actor
inner join film_actor on actor.actor_id=film_actor.actor_id
group by actor.actor_id
order by actor.first_name, actor.last_name asc;

--9. Display the names of the actors that acted in more than 20 movies.
select concat(actor.first_name,' ',actor.last_name) as actor_name, 
count(film_actor.film_id) as movie_count
from actor
inner join film_actor on actor.actor_id=film_actor.actor_id
group by actor.first_name, actor.last_name
having count(film_actor.film_id)>20
order by actor_name asc;

--10. For all the movies rated "PG" show me the movie and the number of times it got rented.
select film.title as movie_title, film.rating,
count(rental.rental_id) as no_of_time_rented
from film
inner join inventory on film.film_id=inventory.film_id
inner join rental on inventory.inventory_id=rental.inventory_id
where rating='PG'
group by film.title, film.rating
order by movie_title asc;

--11. Display the movies offered for rent in store_id 1 and not offered in store_id 2.
select distinct title as movie_title
from inventory
inner join film on inventory.film_id=film.film_id
where inventory.store_id=1
and film.film_id not in
    (select film_id
    from inventory
    where store_id=2)
order by movie_title asc;
	
--12. Display the movies offered for rent in any of the two stores 1 and 2.
select distinct film.title as movie_title
from film
inner join inventory on film.film_id=inventory.film_id
where store_id in (1,2)
order by movie_title asc;

--13. Display the movie title of those movies offered in both stores at the same time.
select title as movie_title
from film
where film_id in
    (select film_id
    from inventory
    where store_id=1)
and film_id in
    (select film_id
    from inventory
    where store_id=2)
order by movie_title asc;

--14. Display the movie title for the most rented movie in the store with store_id 1.
select film.title as movie_title
from film
inner join inventory on film.film_id=inventory.film_id
inner join rental on inventory.inventory_id=rental.inventory_id
where inventory.store_id=1
group by film.title
order by count(rental_id) desc
limit 1;

--15. How many movies are not offered for rent in the stores yet? There are two stores only 1 and 2.
select count(*) as no_of_movies_not_offered_for_rent
from film
where film_id not in
    (select film_id
    from inventory
    where store_id in (1,2));

--16. Show the number of rented movies under each rating.
select film.rating, 
count(rental_id) as no_of_rented_movies
from film
inner join inventory on film.film_id=inventory.film_id
inner join rental on inventory.inventory_id=rental.inventory_id
group by film.rating;

--17. Show the profit of each of the stores 1 and 2.
select inventory.store_id, 
sum(payment.amount) as profit
from payment
inner join rental on payment.rental_id=rental.rental_id
inner join inventory on rental.inventory_id=inventory.inventory_id
group by inventory.store_id;
