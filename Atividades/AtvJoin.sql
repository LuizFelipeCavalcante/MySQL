-- QUESTÃO 1
/*
Ele é importante para traduzir o modelo de negocio de uma empresa para uma estrutura de dados a qual se aplica em um banco de dados. 
Também é essencial que os modelos possibilitem o compreender de maneira clara a estrutura de banco de dados. 
*/

-- QUESTÃO 2
create database farma;
use farma;
create table farmacia(
CNPJ_farmacia numeric(14) not null  primary key,
nome_farmacia varchar(30),
tel_farmacia numeric(13),
end_farmacia varchar(50)
)ENGINE=InnoDB;

create table produto(
cod_produto integer not null auto_increment primary key,
CNPJ_farmacia numeric(14),
valor_produto varchar(30),
qtd_produto numeric(13),
foreign key (CNPJ_farmacia) references farmacia(CNPJ_farmacia) on delete restrict
)ENGINE=InnoDB;

create table farmaceutico(
RG_farmaceutico numeric(7) not null primary key,
nome_farmaceutico varchar(30),
CNPJ_farmacia numeric(14),
foreign key (CNPJ_farmacia) references farmacia(CNPJ_farmacia) on delete restrict
)ENGINE=InnoDB;

-- QUESTÃO 3.A
use sakila;
select film_id as Filme, count(film_id) as Quantidade, (select COUNT(actor_id)
FROM
    film_actor
    where film.film_id = film_actor.film_id)as a
from film 
join inventory using (film_id)
group by film_id
order by quantidade desc
limit 20;

-- QUESTÃO 3.B
select store_id,count(category.name = 'drama' + category.name = 'comedy'+ category.name = 'horror') as quant from store
join inventory using(store_id)
join film using (film_id)
join film_category using (film_id)
join category using(category_id)
where category.name in ('drama','horror','comedy')
group by store_id
order by quant desc;

-- QUESTÃO 4
 /* FATURAMENTO POR PRODUTO DE PRODUTOS QUE COMEÇAM COM 'A' DO ANO 2005 E QUE COMEÇAM COM 'B' DO ANO 2004, TENDO A SOMA DO AMOUNT MAIOR QUE 500*/
use classicmodels;
SELECT productName, SUM(AMOUNT)
	
FROM PRODUCTS 
     JOIN ORDERDETAILS USING (PRODUCTCODE)
     JOIN ORDERS USING (ORDERNUMBER)
     JOIN CUSTOMERS USING (CUSTOMERNUMBER)
     JOIN PAYMENTS USING (CUSTOMERNUMBER)
     WHERE PRODUCTNAME LIKE 'B%'  AND YEAR (PAYMENTDATE) = 2004
    GROUP BY PRODUCTNAME
    HAVING SUM(AMOUNT) > 500
			
 UNION
 
 SELECT productName, SUM(AMOUNT)
 FROM PRODUCTS
     JOIN ORDERDETAILS USING (PRODUCTCODE)
     JOIN ORDERS USING (ORDERNUMBER)
     JOIN CUSTOMERS USING (CUSTOMERNUMBER)
     JOIN PAYMENTS USING (CUSTOMERNUMBER)
     WHERE  PRODUCTNAME LIKE 'A%'  AND YEAR (PAYMENTDATE) = 2005
    GROUP BY PRODUCTNAME
    HAVING SUM(AMOUNT) > 500;
 


