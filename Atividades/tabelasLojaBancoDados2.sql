-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema lojabancodados2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema lojabancodados2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lojabancodados2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `lojabancodados2` ;

-- -----------------------------------------------------
-- Table `lojabancodados2`.`auditoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`auditoria` (
  `DataModificacao` DATETIME NOT NULL,
  `nomeTabela` VARCHAR(100) NOT NULL,
  `historico` TEXT NOT NULL,
  PRIMARY KEY (`DataModificacao`, `nomeTabela`))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `lojabancodados2`.`funcao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`funcao` (
  `CodigoFuncao` INT NOT NULL,
  `nome` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`CodigoFuncao`))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `lojabancodados2`.`vendedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`vendedor` (
  `CodigoVendedor` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `funcao` VARCHAR(50) NOT NULL,
  `cidade` VARCHAR(100) NOT NULL,
  `CodigoFuncao` INT NULL DEFAULT NULL,
  `funcao_CodigoFuncao` INT NOT NULL,
  PRIMARY KEY (`CodigoVendedor`),
  INDEX `CodigoFuncao` (`CodigoFuncao` ASC) VISIBLE,
  INDEX `fk_vendedor_funcao_idx` (`funcao_CodigoFuncao` ASC) VISIBLE)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `lojabancodados2`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`cliente` (
  `CodigoCliente` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `cpf` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`CodigoCliente`))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `lojabancodados2`.`carrinho`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`carrinho` (
  `CodigoCarrinho` INT NOT NULL AUTO_INCREMENT,
  `CodigoCliente` INT NULL DEFAULT NULL,
  `CodigoVendedor` INT NULL DEFAULT NULL,
  `Qtde` INT NOT NULL,
  `DataAdicao` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `vendedor_CodigoVendedor` INT NOT NULL,
  `cliente_CodigoCliente` INT NOT NULL,
  PRIMARY KEY (`CodigoCarrinho`),
  INDEX `CodigoCliente` (`CodigoCliente` ASC) VISIBLE,
  INDEX `CodigoVendedor` (`CodigoVendedor` ASC) VISIBLE,
  INDEX `fk_carrinho_vendedor1_idx` (`vendedor_CodigoVendedor` ASC) VISIBLE,
  INDEX `fk_carrinho_cliente1_idx` (`cliente_CodigoCliente` ASC) VISIBLE)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `lojabancodados2`.`produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`produto` (
  `CodigoProduto` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `descriacao` TEXT NULL DEFAULT NULL,
  `qtde_estoque` INT NOT NULL,
  PRIMARY KEY (`CodigoProduto`))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `lojabancodados2`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`pedido` (
  `CodigoPedido` INT NOT NULL,
  `dataPedido` DATE NOT NULL,
  `cliente_CodigoCliente` INT NOT NULL,
  `vendedor_CodigoVendedor` INT NOT NULL,
  PRIMARY KEY (`CodigoPedido`),
  INDEX `fk_pedido_cliente1_idx` (`cliente_CodigoCliente` ASC) VISIBLE,
  INDEX `fk_pedido_vendedor1_idx` (`vendedor_CodigoVendedor` ASC) VISIBLE)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `lojabancodados2`.`itempedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`itempedido` (
  `CodigoPedido` INT NOT NULL,
  `CodigoProduto` INT NOT NULL,
  `PrecoVenda` DECIMAL(10,2) NOT NULL,
  `Qtde` INT NOT NULL,
  `produto_CodigoProduto` INT NOT NULL,
  `pedido_CodigoPedido` INT NOT NULL,
  PRIMARY KEY (`CodigoPedido`, `CodigoProduto`),
  INDEX `CodigoProduto` (`CodigoProduto` ASC) VISIBLE,
  INDEX `fk_itempedido_produto1_idx` (`produto_CodigoProduto` ASC) VISIBLE,
  INDEX `fk_itempedido_pedido1_idx` (`pedido_CodigoPedido` ASC) VISIBLE)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `lojabancodados2`.`status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`status` (
  `CodigoStatus` INT NOT NULL,
  `descricao` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`CodigoStatus`))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `lojabancodados2`.`carrinho_produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`carrinho_produto` (
  `CodigoCarrinho` INT NOT NULL,
  `CodigoProduto` INT NOT NULL,
  `Qntde` INT NULL,
  PRIMARY KEY (`CodigoCarrinho`, `CodigoProduto`),
  INDEX `fk_carrinho_has_produto_produto1_idx` (`CodigoProduto` ASC) VISIBLE,
  INDEX `fk_carrinho_has_produto_carrinho1_idx` (`CodigoCarrinho` ASC) VISIBLE)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `lojabancodados2`.`pedidostatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lojabancodados2`.`pedidostatus` (
  `CodigoPedido` INT NOT NULL,
  `CodigoStatus` INT NOT NULL,
  `DataAtualizacao` DATETIME NOT NULL,
  PRIMARY KEY (`CodigoPedido`, `CodigoStatus`),
  INDEX `fk_pedido_has_status_status1_idx` (`CodigoStatus` ASC) VISIBLE,
  INDEX `fk_pedido_has_status_pedido1_idx` (`CodigoPedido` ASC) VISIBLE)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
