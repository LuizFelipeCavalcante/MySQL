USE CLASSICMODELS;

CALL GERAR_PEDIDO(103, 1166, @RESUL);
select @resul;

select * from carrinho_compra;
select * from products WHERE PRODUCTCODE = 'S10_2016' ;

INSERT INTO CARRINHO_COMPRA (CODIGOPRODUTOC, QUANTIDADEC, PRECOC, CODIGOCLIENTEC) 
VALUES ('S10_2016',100,50.00,103); -- S10_1678

SELECT * FROM CLASSICMODELS.CUSTOMERS WHERE SALESREPEMPLOYEENUMBER IS NOT NULL;
SELECT * FROM CLASSICMODELS.EMPLOYEES WHERE JOBTITLE = 'SALES REP';

DROP PROCEDURE GERAR_PEDIDO;
DROP PROCEDURE GERAR_ITEM_PEDIDO;



CREATE TABLE CARRINHO_COMPRA(
CODIGOPRODUTOC VARCHAR(15) NOT NULL,
QUANTIDADEC INT NOT NULL,
PRECOC DECIMAL(10,2) NOT NULL,
CODIGOCLIENTEC INT NOT NULL,
PRIMARY KEY (CODIGOCLIENTEC, CODIGOPRODUTOC)
)ENGINE = InnoDB;


DELIMITER $
CREATE PROCEDURE GERAR_PEDIDO(IN PARAM_CODIGOCLIENTE INT, IN PARAM_CODIGOVENDEDOR INT, OUT var_RESULTADO VARCHAR(200))
BEGIN
	DECLARE EXISTE INT DEFAULT 0; 
    DECLARE NUMEROPRODUTOS INT DEFAULT 0;
    DECLARE QUANTIDADEPRODUTOS INT DEFAULT 0;
    DECLARE CONTA INT DEFAULT 0;
    DECLARE VAR_NUMEROPEDIDO INT DEFAULT 0;
    DECLARE CODIGOPRODUTO VARCHAR(15) DEFAULT NULL;
    DECLARE PRECO DECIMAL(10,2) DEFAULT 0.00;
    DECLARE RESULTADO VARCHAR(200) DEFAULT NULL;
    
	SELECT IFNULL(COUNT(CUSTOMERNUMBER),0) INTO EXISTE
		FROM customers
        WHERE CUSTOMERNUMBER = PARAM_CODIGOCLIENTE;
        
	IF EXISTE = 0 THEN
		SET RESULTADO = CONCAT('O codigo ', PARAM_CODIGOCLIENTE,' do cliente, é invalido');
        SET EXISTE = 0;
	ELSE 
		SELECT IFNULL((COUNT(EMPLOYEENUMBER)),0) INTO EXISTE 
		FROM EMPLOYEES 
        WHERE EMPLOYEENUMBER = PARAM_CODIGOVENDEDOR;
        
			IF EXISTE = 0 THEN
				SET RESULTADO = CONCAT('O codigo ', PARAM_CODIGOVENDEDOR,' do vendedor, é invalido');
                SET EXISTE = 0;
			ELSE
				SELECT IFNULL(COUNT(CODIGOCLIENTEC),0) INTO EXISTE
				FROM CARRINHO_COMPRA 
				WHERE CODIGOCLIENTEC = PARAM_CODIGOCLIENTE;
				
					IF EXISTE = 0 THEN
						SET RESULTADO = CONCAT('O codigo ', PARAM_CODIGOCLIENTE,' do cliente não está no carrinho');
						SET EXISTE = 0;
					ELSE

						SELECT MAX(ORDERNUMBER) + 1 INTO VAR_NUMEROPEDIDO FROM ORDERS;
                        
						START TRANSACTION;
                         
							INSERT INTO ORDERS 
							(ORDERNUMBER, ORDERDATE, REQUIREDDATE, shippeddate, STATUS, comments, CUSTOMERNUMBER)
							VALUES (VAR_NUMEROPEDIDO, CURDATE() , CURDATE()+7,'', 'processing','', PARAM_CODIGOCLIENTE);
							
                            SELECT IFNULL(COUNT(CODIGOPRODUTOC),0) INTO NUMEROPRODUTOS 
							FROM CARRINHO_COMPRA 
							WHERE CODIGOCLIENTEC = PARAM_CODIGOCLIENTE LIMIT 1;
								IF NUMEROPRODUTOS = 0 THEN
									SET RESULTADO = 'Não tem produtos no carrinho';		
                                    
								ELSE
                                
									WHILE CONTA < NUMEROPRODUTOS DO
										
										SELECT CODIGOPRODUTOC INTO CODIGOPRODUTO FROM CARRINHO_COMPRA WHERE CODIGOCLIENTEC = PARAM_CODIGOCLIENTE LIMIT 1;
                                        SELECT PRECOC INTO PRECO FROM CARRINHO_COMPRA WHERE CODIGOCLIENTEC = PARAM_CODIGOCLIENTE LIMIT 1;
                                        SELECT QUANTIDADEC INTO QUANTIDADEPRODUTOS FROM CARRINHO_COMPRA WHERE CODIGOCLIENTEC = PARAM_CODIGOCLIENTE LIMIT 1;
                                        
										CALL GERAR_ITEM_PEDIDO(CODIGOPRODUTO, QUANTIDADEPRODUTOS, PRECO, VAR_NUMEROPEDIDO, @RESULTAD);
                                        
                                        UPDATE 	CUSTOMERS
										SET salesRepEmployeeNumber = PARAM_CODIGOVENDEDOR
										WHERE CUSTOMERNUMBER = PARAM_CODIGOCLIENTE;
                                        
                                        SET RESULTADO = @RESULTAD;
										COMMIT;
								
                                        SET CONTA = CONTA + 1;
									END WHILE;
                                    
								END IF;
					END IF;
        END IF;
	END IF;
    
    SET var_RESULTADO = RESULTADO;
END$
DELIMITER ;


DELIMITER $
CREATE PROCEDURE GERAR_ITEM_PEDIDO(IN VAR_CODIGOPRODUTO VARCHAR(15), IN VAR_QUANTIDADEPRODUTOS INT, IN VAR_PRECO INT, IN VAR_NUMEROPEDIDO INT, OUT VAR_RESULTADO VARCHAR(80))
BEGIN
	DECLARE CODIGO_PRODUTO INT DEFAULT 0;
    DECLARE QUANTIDADE_ESTOQUE INT DEFAULT 0;
    DECLARE RESULTADO VARCHAR(80) DEFAULT NULL;
    
	SELECT IFNULL(COUNT(PRODUCTCODE),0) INTO CODIGO_PRODUTO 
				FROM PRODUCTS 
				WHERE PRODUCTCODE = VAR_CODIGOPRODUTO;
				
					IF CODIGO_PRODUTO = 0 THEN
						SET RESULTADO = CONCAT('O codigo ', VAR_CODIGOPRODUTO,' do produto não existe na tabela products');
					
					ELSE
						SELECT QUANTITYINSTOCK INTO QUANTIDADE_ESTOQUE
                        FROM PRODUCTS WHERE PRODUCTCODE = VAR_CODIGOPRODUTO;
                        
                        IF QUANTIDADE_ESTOQUE < VAR_QUANTIDADEPRODUTOS THEN
							SET RESULTADO = CONCAT('Quantidade ',VAR_CODIGOPRODUTO, ' de produto em estoque insuficiente');
							
                        ELSE
							INSERT INTO ORDERDETAILS
							(ORDERNUMBER, PRODUCTCODE, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER)
							VALUES (VAR_NUMEROPEDIDO, CODIGO_PRODUTO, VAR_QUANTIDADEPRODUTOS, VAR_PRECO, 0 );
                            
                            UPDATE 	PRODUCTS
								SET QUANTITYINSTOCK = QUANTITYINSTOCK - VAR_QUANTIDADEPRODUTOS
								WHERE PRODUCTCODE = VAR_CODIGOPRODUTO;
                                SET RESULTADO = CONCAT('Sucesso na transação');
                                
                        END IF;
                    END IF; 
                   SET VAR_RESULTADO = RESULTADO ;
END$
DELIMITER ;


SELECT QUANTITYINSTOCK INTO @QNT
                        FROM PRODUCTS WHERE PRODUCTCODE = 'S10_2016';
                        SELECT @QNT;