USE SAKILA;

DELIMITER $
CREATE FUNCTION VELOCIDADE(DISTANCIA INT, TEMPO INT) RETURNS FLOAT DETERMINISTIC 
BEGIN
	DECLARE CALCULOVELOCIDADE FLOAT DEFAULT 0;
	
    SET CALCULOVELOCIDADE = DISTANCIA / TEMPO;
    
    RETURN CALCULOVELOCIDADE;
END$
DELIMITER ;
DROP FUNCTION VELOCIDADE;

SELECT VELOCIDADE(200,10);