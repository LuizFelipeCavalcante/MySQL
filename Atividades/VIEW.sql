USE CLASSICMODELS;
CREATE OR REPLACE VIEW DADOS_PAGAMENTO AS 
	SELECT 
    CUSTOMERNUMBER CODIGO,
		CUSTOMERNAME CLIENTE,
        SUM(AMOUNT) TOTAL
        FROM
        CUSTOMERS JOIN PAYMENTS
			USING(CUSTOMERNUMBER)
		GROUP BY 
			CLIENTE;
            
	SELECT * FROM DADOS_PAGAMENTO;
    DELETE FROM CLIENTE_PAGAMENTO WHERE CODIGO = 114;
	UPDATE CLIENTE_PAGAMENTO SET TOTAL = 100000 WHERE CODIGO = 114;
    
    CREATE TABLE CLIENTE_PAGAMENTO SELECT* FROM DADOS_PAGAMENTO;
    
    
    CREATE OR REPLACE VIEW DADOS_CLIENTE(CLIENTE, ESTADO, CIDADE, CODIGO) AS 
    SELECT CUSTOMERNAME, STATE, CITY, CUSTOMERNUMBER FROM CUSTOMERS;
    
    UPDATE DADOS_CLIENTE SET CIDADE = 'SANTA LUZIA' WHERE CODIGO = 114;
    DELETE FROM DADOS_CLIENTE WHERE CODIGO = 114;
    DELETE FROM PAYMENTS WHERE CUSTOMERNUMBER = 114;
    
    DELETE FROM ORDERDETAILS WHERE ORDERNUMBER IN(SELECT ORDERNUMBER FROM ORDERS WHERE CUSTOMERNUMBER = 114);
	DELETE FROM ORDERS WHERE CUSTOMERNUMBER = 114;