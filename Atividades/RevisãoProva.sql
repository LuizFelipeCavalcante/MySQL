-- Questão 1
USE SAKILA;

CREATE OR REPLACE VIEW TOTAL_CLIENTES AS 
	SELECT 
    COUNT(CUSTOMER_ID) CLIENTES,
    COUNTRY PAIS
        FROM
        CUSTOMER JOIN 
        ADDRESS USING(ADDRESS_ID) JOIN
        CITY USING(CITY_ID) JOIN
        COUNTRY USING(COUNTRY_ID)
		GROUP BY PAIS;
        
        SELECT * FROM TOTAL_CLIENTES;
        
        
-- Questão 2
WITH CLIENTE_WITH (PAGAMENTO, PAIS, LOJA)
AS 
(
 SELECT 
  SUM(AMOUNT), COUNTRY, STORE_ID
  
FROM 
	CITY JOIN ADDRESS USING(CITY_ID)
    JOIN STORE USING(ADDRESS_ID)
    JOIN STAFF USING(STORE_ID)
    JOIN PAYMENT USING(STAFF_ID)
    JOIN COUNTRY USING(COUNTRY_ID)
	WHERE STORE_ID = 2

)

SELECT CLIENTES, TOTAL_CLIENTES.PAIS, PAGAMENTO
FROM CLIENTE_WITH 
  JOIN TOTAL_CLIENTES ON(TOTAL_CLIENTES.PAIS = CLIENTE_WITH.PAIS)
GROUP BY LOJA;



-- Questão 3

	USE CLASSICMODELS;

DELIMITER $
CREATE PROCEDURE ANO_PRODUTO (IN ANO INT)
BEGIN
    SELECT PRODUCTNAME PRODUTO, SUM(QUANTITYORDERED * PRICEEACH) TOTAL, SUM(QUANTITYORDERED) QUANTIDADE
    FROM PRODUCTS JOIN ORDERDETAILS USING (PRODUCTCODE) JOIN ORDERS USING (ORDERNUMBER) 
    WHERE YEAR(ORDERDATE) = ANO
    GROUP BY PRODUTO;
END $
DELIMITER ;

CALL INFO_PRODUTO(2005);


-- Questão 4
CREATE OR REPLACE VIEW FILMES_CATEGORIA AS
SELECT COUNT(TITLE) FILME, NAME CATEGORIA
FROM FILM JOIN FILM_CATEGORY USING(FILM_ID)
JOIN CATEGORY USING(CATEGORY_ID)
GROUP BY NAME;

SELECT*FROM FILMES_CATEGORIA;

DELIMITER $
CREATE PROCEDURE PRO_FILME()
BEGIN
DECLARE TOTAL_FILMES INT DEFAULT 0;
DECLARE VAR_CATEGORIA VARCHAR(220) DEFAULT NULL;
DECLARE VAR_FILME VARCHAR(225) DEFAULT NULL;
DECLARE CONTA INT DEFAULT NULL;

    SELECT COUNT(CATEGORIA) INTO TOTAL_FILMES FROM FILMES_CATEGORIA;
        
	WHILE CONTA < TOTAL_FILMES DO
		SELECT FILME INTO VAR_FILME 
			FROM FILMES_CATEGORIA
            LIMIT 1
            OFFSET CONTA;
            
            SELECT CATEGORIA INTO VAR_CATEGORIA
			FROM FILMES_CATEGORIA
            LIMIT 1
            OFFSET CONTA;

	INSERT INTO RESULTADO_FILME (FILME, CATEGORIA)
		VALUES (VAR_FILME, VAR_CATEGORIA);
        
	SET CONTA = CONTA + 1;
    END WHILE;
  
END$
DELIMITER ;
CALL PRO_FILME();

CREATE TABLE RESULTADO_FILME(
FILME VARCHAR(225),
CATEGORIA VARCHAR(220)
)ENGINE=InnoDB;

SELECT * FROM RESULTADO_FILME;


        
            