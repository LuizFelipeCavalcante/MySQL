CREATE DATABASE LojaBancoDados2;
USE LojaBancoDados2;

CREATE TABLE Produto (
    CodigoProduto INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descriacao TEXT,
    qtde_estoque INT NOT NULL
);

CREATE TABLE Cliente (
    CodigoCliente INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL
);

CREATE TABLE Pedido (
    CodigoPedido INT PRIMARY KEY,
    dataPedido DATE NOT NULL
);

CREATE TABLE Status (
    CodigoStatus INT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE PedidoStatus (
    CodigoPedido INT,
    CodigoStatus INT,
    DataAtualizacao DATETIME NOT NULL,
    PRIMARY KEY (CodigoPedido, CodigoStatus),
    FOREIGN KEY (CodigoPedido) REFERENCES Pedido(CodigoPedido),
    FOREIGN KEY (CodigoStatus) REFERENCES Status(CodigoStatus)
);

CREATE TABLE ItemPedido (
    CodigoPedido INT,
    CodigoProduto INT,
    PrecoVenda DECIMAL(10, 2) NOT NULL,
    Qtde INT NOT NULL,
    PRIMARY KEY (CodigoPedido, CodigoProduto),
    FOREIGN KEY (CodigoPedido) REFERENCES Pedido(CodigoPedido),
    FOREIGN KEY (CodigoProduto) REFERENCES Produto(CodigoProduto)
);

CREATE TABLE Vendedor (
    CodigoVendedor INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    funcao VARCHAR(50) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    CodigoFuncao INT,
	FOREIGN KEY (CodigoFuncao) REFERENCES Funcao(CodigoFuncao)
);

CREATE TABLE Funcao (
    CodigoFuncao INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE Carrinho (
    CodigoCarrinho INT PRIMARY KEY AUTO_INCREMENT,
    CodigoCliente INT,
    CodigoVendedor INT,
    Qtde INT NOT NULL,
    DataAdicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CodigoCliente) REFERENCES Cliente(CodigoCliente),
    FOREIGN KEY (CodigoVendedor) REFERENCES Vendedor(CodigoVendedor)
);

CREATE TABLE Carrinho_Produto (
    CodigoCarrinho INT,
    CodigoProduto INT,
    Qtde INT NOT NULL,
    PRIMARY KEY (CodigoCarrinho, CodigoProduto),
    FOREIGN KEY (CodigoCarrinho) REFERENCES Carrinho(CodigoCarrinho),
    FOREIGN KEY (CodigoProduto) REFERENCES Produto(CodigoProduto)
);


-- Auditoria
CREATE TABLE Auditoria (
    DataModificacao DATETIME NOT NULL,
    nomeTabela VARCHAR(100) NOT NULL,
    historico TEXT NOT NULL,
    PRIMARY KEY (DataModificacao, nomeTabela)
);


-- Triggers

DELIMITER $

-- Triggers de INSERT

CREATE TRIGGER TRG_INSERIR_PRODUTO AFTER INSERT ON PRODUTO
FOR EACH ROW 
BEGIN 
	INSERT INTO AUDITORIA VALUES(NOW(), 'PRODUTO', CONCAT('FOI INCLUIDO NA TABELA O PRODUTO DE NUMERO: ', NEW.CODIGOPRODUTO));
END$

CREATE TRIGGER TRG_INSERIR_CLIENTE AFTER INSERT ON CLIENTE
FOR EACH ROW 
BEGIN 
	INSERT INTO AUDITORIA VALUES(NOW(), 'CLIENTE',CONCAT('FOI INCLUIDO NA TABELA O CLIENTE DE NUMERO: ', NEW.CODIGOCLIENTE));
END$

CREATE TRIGGER TRG_INSERIR_PEDIDO AFTER INSERT ON PEDIDO
FOR EACH ROW 
BEGIN 
	INSERT INTO AUDITORIA VALUES(NOW(), 'PEDIDO',CONCAT('FOI INCLUIDO NA TABELA O PEDIDO DE NUMERO: ', NEW.CODIGOPEDIDO));
END$

CREATE TRIGGER TRG_INSERIR_ITEMPEDIDO AFTER INSERT ON ITEMPEDIDO
FOR EACH ROW 
BEGIN 
	INSERT INTO AUDITORIA VALUES(NOW(),'ITEMPEDIDO', CONCAT('FOI INCLUIDO NA TABELA O ITEMPEDIDO DE NUMERO: ', NEW.CODIGOPEDIDO,', ',NEW.CODIGOPRODUTO));
END$

CREATE TRIGGER TRG_INSERIR_VENDEDOR AFTER INSERT ON VENDEDOR
FOR EACH ROW 
BEGIN 
	INSERT INTO AUDITORIA VALUES(NOW(),'VENDEDOR', CONCAT('FOI INCLUIDO NA TABELA O VENDEDOR DE NUMERO: ', NEW.CODIGOVENDEDOR));
END$



-- Triggers de UPDATE

-- Alterar produto

CREATE TRIGGER TRG_ALTERAR_PRODUTO AFTER UPDATE ON PRODUTO
FOR EACH ROW 
BEGIN 
    DECLARE historico TEXT DEFAULT '';

    -- Concatena as mudanças diretamente
    SET historico = CONCAT(historico,
        IF(OLD.nome != NEW.nome, CONCAT('nome alterado de ', OLD.nome, ' para ', NEW.nome, '. '), ''),
        IF(OLD.descriacao != NEW.descriacao, CONCAT('descrição alterada de ', OLD.descriacao, ' para ', NEW.descriacao, '. '), ''),
        IF(OLD.qtde_estoque != NEW.qtde_estoque, CONCAT('quantidade em estoque alterada de ', OLD.qtde_estoque, ' para ', NEW.qtde_estoque, '. '), '')
    );

    -- Insere o histórico apenas se houve mudanças
    IF historico != '' THEN
        INSERT INTO Auditoria (DataModificacao, nomeTabela, historico)
        VALUES (NOW(), 'Produto', historico);
    END IF;
END$


-- Alterar Vendedor

CREATE TRIGGER TRG_ALTERAR_VENDEDOR AFTER UPDATE ON VENDEDOR
FOR EACH ROW 
BEGIN 
	DECLARE historico TEXT DEFAULT '';

    -- Concatena as mudanças diretamente
    SET historico = CONCAT(historico,
        IF(OLD.nome != NEW.nome, CONCAT('nome alterado de ', OLD.nome, ' para ', NEW.nome, '. '), ''),
        IF(OLD.descriacao != NEW.descriacao, CONCAT('descrição alterada de ', OLD.descriacao, ' para ', NEW.descriacao, '. '), ''),
        IF(OLD.qtde_estoque != NEW.qtde_estoque, CONCAT('quantidade em estoque alterada de ', OLD.qtde_estoque, ' para ', NEW.qtde_estoque, '. '), '')
    );

    -- Insere o histórico apenas se houve mudanças
    IF historico != '' THEN
        INSERT INTO Auditoria (DataModificacao, nomeTabela, historico)
        VALUES (NOW(), 'Produto', historico);
    END IF;
END$


-- Alterar pedido

CREATE TRIGGER TRG_ALTERAR_PEDIDO AFTER UPDATE ON PEDIDO
FOR EACH ROW
BEGIN
    DECLARE historico TEXT DEFAULT '';

    -- Concatena as mudanças diretamente
    SET historico = CONCAT(historico,
        IF(OLD.dataPedido != NEW.dataPedido, CONCAT('dataPedido alterado de ', OLD.dataPedido, ' para ', NEW.dataPedido, '. '), '')
    );

    -- Insere o histórico apenas se houve mudanças
    IF historico != '' THEN
        INSERT INTO Auditoria (DataModificacao, nomeTabela, historico)
        VALUES (NOW(), 'Pedido', historico);
    END IF;
END$


-- Alterar cliente

CREATE TRIGGER TRG_ALTERAR_CLIENTE AFTER UPDATE ON CLIENTE
FOR EACH ROW
BEGIN
    DECLARE historico TEXT DEFAULT '';

    -- Concatena as mudanças diretamente
    SET historico = CONCAT(historico,
        IF(OLD.nome != NEW.nome, CONCAT('nome alterado de ', OLD.nome, ' para ', NEW.nome, '. '), ''),
        IF(OLD.email != NEW.email, CONCAT('email alterado de ', OLD.email, ' para ', NEW.email, '. '), ''),
        IF(OLD.cpf != NEW.cpf, CONCAT('cpf alterado de ', OLD.cpf, ' para ', NEW.cpf, '. '), '')
    );

    -- Insere o histórico apenas se houve mudanças
    IF historico != '' THEN
        INSERT INTO Auditoria (DataModificacao, nomeTabela, historico)
        VALUES (NOW(), 'Cliente', historico);
    END IF;
END$


-- Alterar cliente 

CREATE TRIGGER TRG_ALTERAR_ITEMPEDIDO AFTER UPDATE ON ITEMPEDIDO
FOR EACH ROW
BEGIN
    DECLARE historico TEXT DEFAULT '';

    -- Concatena as mudanças diretamente
    SET historico = CONCAT(historico,
        IF(OLD.PrecoVenda != NEW.PrecoVenda, CONCAT('PrecoVenda alterado de ', OLD.PrecoVenda, ' para ', NEW.PrecoVenda, '. '), ''),
        IF(OLD.Qtde != NEW.Qtde, CONCAT('Qtde alterada de ', OLD.Qtde, ' para ', NEW.Qtde, '. '), '')
    );

    -- Insere o histórico apenas se houve mudanças
    IF historico != '' THEN
        INSERT INTO Auditoria (DataModificacao, nomeTabela, historico)
        VALUES (NOW(), 'ItemPedido', historico);
    END IF;
END$



-- Triggers de EXCLUIR

-- Excluir PEDIDO

CREATE TRIGGER TRG_EXCLUIR_PEDIDO AFTER DELETE ON PEDIDO
FOR EACH ROW 
BEGIN 
    INSERT INTO Auditoria (DataModificacao, nomeTabela, historico)
    VALUES (NOW(), 'Pedido', CONCAT('Foi excluído o pedido de número: ', OLD.CodigoPedido));
END$


-- Excluir CLIENTE

CREATE TRIGGER TRG_EXCLUIR_CLIENTE AFTER DELETE ON CLIENTE
FOR EACH ROW 
BEGIN 
     INSERT INTO Auditoria (DataModificacao, nomeTabela, historico)
    VALUES (NOW(), 'Cliente', CONCAT('Foi excluído o cliente de número: ', OLD.CodigoCliente));
END$


-- Excluir ITEMPEDIDO

CREATE TRIGGER TRG_EXCLUIR_ITEMPEDIDO AFTER DELETE ON ITEMPEDIDO
FOR EACH ROW 
BEGIN 
     INSERT INTO Auditoria (DataModificacao, nomeTabela, historico)
    VALUES (NOW(), 'ItemPedido', CONCAT('Foi excluído o item do pedido de número: ', OLD.CodigoPedido, ' e produto de número: ', OLD.CodigoProduto));
END$


-- Excluir PRODUTO

CREATE TRIGGER TRG_EXCLUIR_PRODUTO AFTER DELETE ON PRODUTO
FOR EACH ROW 
BEGIN 
      INSERT INTO Auditoria (DataModificacao, nomeTabela, historico)
    VALUES (NOW(), 'Produto', CONCAT('Foi excluído o produto de número: ', OLD.CodigoProduto));
END$


-- Excluir VENDEDOR

CREATE TRIGGER TRG_EXCLUIR_VENDEDOR AFTER DELETE ON VENDEDOR
FOR EACH ROW 
BEGIN 
       INSERT INTO Auditoria (DataModificacao, nomeTabela, historico)
    VALUES (NOW(), 'Vendedor', CONCAT('Foi excluído o vendedor de número: ', OLD.CodigoVendedor));
END$


DELIMITER ;


-- 	Agora as procedures

DELIMITER $$

-- Inserir CLIENTE

CREATE PROCEDURE INSERIR_CLIENTE (
    IN p_CodigoCliente INT,
    IN p_NomeCliente VARCHAR(100),
    IN p_EmailCliente VARCHAR(100),
    IN p_CPFCliente VARCHAR(11)
)
BEGIN
    DECLARE cliente_existe INT;

    -- Verificar se o cliente já existe
    SELECT COUNT(*) INTO cliente_existe
    FROM Cliente
    WHERE CodigoCliente = p_CodigoCliente;

    -- Se não existir, insere
    IF cliente_existe = 0 THEN
        -- Validação do CPF (apenas um exemplo de validação)
        IF LENGTH(p_CPFCliente) = 11 THEN
            INSERT INTO Cliente (CodigoCliente, nome, email, cpf)
            VALUES (p_CodigoCliente, p_NomeCliente, p_EmailCliente, p_CPFCliente);
            SELECT CONCAT('Cliente inserido com sucesso: ', p_CodigoCliente) AS Mensagem;
        ELSE
            SELECT 'CPF inválido, deve ter 11 dígitos' AS Mensagem;
        END IF;
    ELSE
        SELECT 'Cliente já existe' AS Mensagem;
    END IF;
END$$


-- Inserir VENDEDOR

CREATE PROCEDURE INSERIR_VENDEDOR (
    IN p_CodigoVendedor INT,
    IN p_NomeVendedor VARCHAR(100),
    IN p_FuncaoVendedor VARCHAR(50),
    IN p_CidadeVendedor VARCHAR(100),
    IN p_CodigoFuncao INT
)
BEGIN
    DECLARE vendedor_existe INT;

    -- Verificar se o vendedor já existe
    SELECT COUNT(*) INTO vendedor_existe
    FROM Vendedor
    WHERE CodigoVendedor = p_CodigoVendedor;

    -- Se não existir, insere
    IF vendedor_existe = 0 THEN
        -- Validação da função
        IF p_CodigoFuncao IS NOT NULL THEN
            INSERT INTO Vendedor (CodigoVendedor, nome, funcao, cidade, CodigoFuncao)
            VALUES (p_CodigoVendedor, p_NomeVendedor, p_FuncaoVendedor, p_CidadeVendedor, p_CodigoFuncao);
            SELECT CONCAT('Vendedor inserido com sucesso: ', p_CodigoVendedor) AS Mensagem;
        ELSE
            SELECT 'Código de Função inválido' AS Mensagem;
        END IF;
    ELSE
        SELECT 'Vendedor já existe' AS Mensagem;
    END IF;
END$$


-- Inserir FUNCAO

CREATE PROCEDURE INSERIR_FUNCAO (
    IN p_CodigoFuncao INT,
    IN p_NomeFuncao VARCHAR(50)
)
BEGIN
    DECLARE funcao_existe INT;

    -- Verificar se a função já existe
    SELECT COUNT(*) INTO funcao_existe
    FROM Funcao
    WHERE CodigoFuncao = p_CodigoFuncao;

    -- Se não existir, insere
    IF funcao_existe = 0 THEN
        INSERT INTO Funcao (CodigoFuncao, nome)
        VALUES (p_CodigoFuncao, p_NomeFuncao);
        SELECT CONCAT('Função inserida com sucesso: ', p_CodigoFuncao) AS Mensagem;
    ELSE
        SELECT 'Função já existe' AS Mensagem;
    END IF;
END$$


-- Inserir STATUS

CREATE PROCEDURE INSERIR_STATUS (
    IN p_CodigoStatus INT,
    IN p_DescricaoStatus VARCHAR(50)
)
BEGIN
    DECLARE status_existe INT;

    -- Verificar se o status já existe
    SELECT COUNT(*) INTO status_existe
    FROM Status
    WHERE CodigoStatus = p_CodigoStatus;

    -- Se não existir, insere
    IF status_existe = 0 THEN
        INSERT INTO Status (CodigoStatus, descricao)
        VALUES (p_CodigoStatus, p_DescricaoStatus);
        SELECT CONCAT('Status inserido com sucesso: ', p_CodigoStatus) AS Mensagem;
    ELSE
        SELECT 'Status já existe' AS Mensagem;
    END IF;
END$$
DELIMITER ;



-- Procedure de PEDIDO e ITEMPEDIDO

DELIMITER $
CREATE PROCEDURE GERAR_PEDIDO(
    IN PARAM_CODIGOCLIENTE INT, 
    IN PARAM_CODIGOVENDEDOR INT, 
    OUT var_RESULTADO VARCHAR(200)
)
BEGIN
    DECLARE EXISTE INT DEFAULT 0;
    DECLARE VAR_NUMEROPEDIDO INT DEFAULT 0;
    DECLARE CODIGOPRODUTO INT DEFAULT 0;
    DECLARE QUANTIDADEPRODUTO INT DEFAULT 0;
    DECLARE PRECO DECIMAL(10,2) DEFAULT 0.00;

    DECLARE CURSOR_LISTA_PRODUTO CURSOR FOR
        SELECT cp.CodigoProduto, p.qtde_estoque, cp.Qtde 
        FROM Carrinho_Produto cp
        JOIN Produto p ON cp.CodigoProduto = p.CodigoProduto
        WHERE cp.CodigoCarrinho = (SELECT CodigoCarrinho FROM Carrinho WHERE CodigoCliente = PARAM_CODIGOCLIENTE);

    DECLARE CONTINUE_LOOP INT DEFAULT 1;
    
    -- Variável para controle do cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET CONTINUE_LOOP = 0;

    -- Abrir transação
    START TRANSACTION;

    -- Validar cliente
    SELECT COUNT(*) INTO EXISTE FROM Cliente WHERE CodigoCliente = PARAM_CODIGOCLIENTE;
    IF EXISTE = 0 THEN
        SET var_RESULTADO = CONCAT('Cliente inválido: ', PARAM_CODIGOCLIENTE);
        ROLLBACK;
        LEAVE PROCEDURE;
    END IF;

    -- Validar vendedor
    SELECT COUNT(*) INTO EXISTE FROM Vendedor WHERE CodigoVendedor = PARAM_CODIGOVENDEDOR;
    IF EXISTE = 0 THEN
        SET var_RESULTADO = CONCAT('Vendedor inválido: ', PARAM_CODIGOVENDEDOR);
        ROLLBACK;
        LEAVE PROCEDURE;
    END IF;

    -- Validar carrinho
    SELECT COUNT(*) INTO EXISTE FROM Carrinho WHERE CodigoCliente = PARAM_CODIGOCLIENTE;
    IF EXISTE = 0 THEN
        SET var_RESULTADO = CONCAT('O cliente ', PARAM_CODIGOCLIENTE, ' não tem produtos no carrinho.');
        ROLLBACK;
        LEAVE PROCEDURE;
    END IF;

    -- Gerar novo número de pedido
    SELECT IFNULL(MAX(CodigoPedido), 0) + 1 INTO VAR_NUMEROPEDIDO FROM Pedido;

    -- Inserir pedido
    INSERT INTO Pedido (CodigoPedido, dataPedido) 
    VALUES (VAR_NUMEROPEDIDO, CURDATE());

    -- Abrir cursor para processar os produtos do carrinho
    OPEN CURSOR_LISTA_PRODUTO;

    read_loop: LOOP
        FETCH CURSOR_LISTA_PRODUTO INTO CODIGOPRODUTO, QUANTIDADEPRODUTO, PRECO;
        
        IF CONTINUE_LOOP = 0 THEN
            LEAVE read_loop;
        END IF;
        
        -- Verificar estoque
        IF QUANTIDADEPRODUTO > PRECO THEN
            SET var_RESULTADO = CONCAT('Estoque insuficiente para o produto: ', CODIGOPRODUTO);
            ROLLBACK;
            LEAVE read_loop;
        END IF;

        -- Inserir item do pedido
        INSERT INTO ItemPedido (CodigoPedido, CodigoProduto, PrecoVenda, Qtde)
        VALUES (VAR_NUMEROPEDIDO, CODIGOPRODUTO, PRECO, QUANTIDADEPRODUTO);

        -- Atualizar estoque
        UPDATE Produto
        SET qtde_estoque = qtde_estoque - QUANTIDADEPRODUTO
        WHERE CodigoProduto = CODIGOPRODUTO;
    END LOOP;
    
    -- Fechar cursor
    CLOSE CURSOR_LISTA_PRODUTO;

    -- Commit da transação
    COMMIT;

    SET var_RESULTADO = CONCAT('Pedido gerado com sucesso: ', VAR_NUMEROPEDIDO);

END$
DELIMITER ;








