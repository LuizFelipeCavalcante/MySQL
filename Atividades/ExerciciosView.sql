use sakila;
#2a
create or replace view cidade_endereco as
	select * from city join address on (city.city_id = address.city_id);
#2b
create or replace view endereco_clientes as
select * from address join customer on (address.address_id = customer.address_id);
#2c
create or replace view cliente_pagamento as
select * from customer join payment on (customer.customer_id = payment.customer_id);
#2d
create or replace view pagamento_cliente as
select * from payment join customer on (customer.customer_id = payment.customer_id);
#2e
create or replace view filme_lingua as
select * from film as f join language as l on (f.language_id = l.language_id)
;


#3a
CREATE OR REPLACE VIEW QuantidadeFilmePorLingua AS
SELECT COUNT(f.film_id) AS quantidade_filmes, l.name
FROM film as f
JOIN language as l ON f.language_id = l.language_id
GROUP BY l.language_id, l.name;
#3b 
create or replace view QuantidadePagamentosPorLoja as
select count(p.payment_id),s.store_id from payment as p join staff as s on p.staff_id = s.staff_id;
#3c
create or replace view QuantidadeClientesPorloja as
select count(c.customer_id),s.store_id from customer as c join store as s on c.store_id = s.store_id
group by s.store_id;

#3d
create or replace view DadosPagamentosPorLoja as
SELECT
    s.store_id,AVG(p.amount),SUM(p.amount),COUNT(p.payment_id),MAX(p.amount),MIN(p.amount) 
FROM staff as s JOIN payment as p ON s.staff_id = p.staff_id
GROUP BY s.store_id;
#3e
create or replace view QuantidadePagamentosPorClientes as
SELECT
    count(p.payment_id),c.customer_id
FROM payment as p JOIN customer as c ON c.customer_id = p.customer_id
GROUP BY c.customer_id;
#3F
create or replace view QuantidadeFilmesPorLingua100ate150 as
SELECT
    count(f.film_id),l.language_id
FROM film as f JOIN language as l ON f.language_id = l.language_id
where f.length between 100 and 150
GROUP BY l.language_id;
#3g
create or replace view QuantidadePagamentosPorLojaAgostoSetembro as
	select count(p.payment_id),s.store_id from payment as p join staff as s on p.staff_id = s.staff_id
    where month(p.payment_date) between 8 and 9
    group by s.store_id;
#3h
create or replace view QuantidadeClientesPorLojaLastNameR as
	select count(c.customer_id),s.store_id from customer as c join store as s on c.store_id = s.store_id
	where c.last_name like "%R"
    group by s.store_id;


#4a
create or replace view CidadeEnderecoCliente as
	select ci.city_id, a.address_id from city as ci join address as a on ci.city_id = a.city_id
	join customer as cu on cu.address_id = a.address_id;
#4b
create or replace view ClientePagamentoRental as
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    p.payment_id,
    p.amount,
    r.rental_id,
    r.rental_date
FROM 
    customer c
JOIN 
    payment p ON c.customer_id = p.customer_id
JOIN 
    rental r ON c.customer_id = r.customer_id;
#4c
create or replace view FilmeFilmeCategoriaCategoria as
	SELECT 
    actor.actor_id,
    actor.first_name,
    actor.last_name,
    film.title
FROM 
    actor
JOIN 
    film_actor ON actor.actor_id = film_actor.actor_id
JOIN 
    film ON film_actor.film_id = film.film_id;
    #4d
    CREATE or replace VIEW AtorFilme AS
SELECT 
    actor.actor_id,
    actor.first_name,
    actor.last_name,
    film.title
FROM 
    actor
JOIN 
    film_actor ON actor.actor_id = film_actor.actor_id
JOIN 
    film ON film_actor.film_id = film.film_id;
#4e
CREATE VIEW FevereiroClientesPorCidade AS
SELECT 
    city.city,
    COUNT(customer.customer_id) AS february_customers
FROM 
    customer
JOIN 
    address ON customer.address_id = address.address_id
JOIN 
    city ON address.city_id = city.city_id
WHERE 
    MONTH(customer.create_date) = 2
GROUP BY 
    city.city;
#4g
CREATE VIEW custoTotalReposicaoPorCategoria AS
SELECT 
    category.name AS categoria,
    SUM(film.replacement_cost) AS custoTotalReposicao
FROM 
    film
JOIN 
    film_category ON film.film_id = film_category.film_id
JOIN 
    category ON film_category.category_id = category.category_id
GROUP BY 
    category.name;