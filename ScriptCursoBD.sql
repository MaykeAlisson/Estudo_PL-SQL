create database estudo;
use estudo;

/* FOREIGN KEY - CHAVE ESTRANGEIRA - FK */

/* E A CHAVE PRIMARIA DE UMA TABELA, QUE VAI ATE
OUTRA TABELA FAZER REFERENCIA */

/* EM RELACIONAMENTOS 1 X 1 A CHAVE ESTRAMGEIRA 
FICA NA TABELA MAIS FRACA */

create table cliente(
idCliente int primary key auto_increment,
nome varchar(30) not null,
sexo enum('M','F') not null,
email varchar(50) unique,
cpf varchar(15) unique
);


create table telefone(
idTelefone int primary key auto_increment,
tipo enum('Com','Res','Cel'),
numero varchar(15),
id_cliente int,
foreign key(id_cliente)
references cliente(idCliente)
);


create table endereco(
idEndereco int primary key auto_increment,
rua varchar(50),
bairro varchar(30),
cidade varchar(50),
estado varchar(2),
id_cliente int unique,
foreign key(id_cliente)
references cliente(idCliente)
);

insert into cliente values(null, 'Joao','M','joao@ig.com','98547-6');
insert into cliente values(null, 'Clara','F',null,'75486-6');

insert into endereco values(null,'Rua A','Centro','B. Horizonte','MG',4);

insert into telefone values(null,'CEL','992434845',1);


/* SELECAO, PROJECAO E JUNCAO */

/* PROJECAO = TUDO AQUILO QUE QUEREMOS PROJETAR NA TELA */

select now() as data;

select nome, now() as data /* PROJECAO */
from cliente;

/* SELECAO = TEORIA DOS CONJUNTOS - WHERE E A CLAUSULA DE SELECAO */

select nome, sexo from cliente;

select nome, sexo
from cliente
where sexo = 'M';

/* JUNCAO */
/* NOME, SEXO, BAIRRO, CIDADE E DATA */

select nome, sexo, bairro, cidade, now() as date
from cliente, endereco
where idCliente = id_cliente;

select nome, sexo, bairro, cidade, now() as date
from cliente, endereco
where idCliente = id_cliente
and bairro = 'Centro';

/* JOIN - JUNCAO */

select nome, sexo, bairro, cidade
from cliente 
inner join endereco
on idCliente = id_cliente
where bairro = 'Centro';

/* ESPECIFICA DE QUAL TABELA E CADA CAMPO */
select cliente.nome, cliente.sexo, endereco.bairro, endereco.cidade, telefone.tipo, telefone.numero
from cliente
inner join endereco 
on cliente.idCliente = endereco.id_cliente
inner join telefone 
on cliente.idCliente = telefone.id_cliente;

/* DEFINI APELIDO PARA CADA TABELAS (A PALAVRA AS E OPSIONAL) */
select c.nome, c.sexo, e.bairro, e.cidade, t.tipo, t.numero
from cliente as c
inner join endereco as e
on c.idCliente = e.id_cliente
inner join telefone as t
on c.idCliente = t.id_cliente;

select c.nome, c.sexo, e.bairro, e.cidade, t.tipo, t.numero
from cliente as c
inner join endereco as e
on c.idCliente = e.id_cliente
inner join telefone as t
on c.idCliente = t.id_cliente
where sexo = 'M' order by nome;

/* IFNULL */
select c.nome, 
	   c.sexo, 
       ifnull(c.email, 'Sem email') as email,
       e.bairro,
       e.cidade
from cliente c
inner join endereco e
on c.idCliente = e.id_cliente
where sexo = 'F';

/* VIEW E VISOES */
CREATE VIEW v_relatorio AS
SELECT c.nome,c.sexo,
	   IFNULL(c.email,'SEM EMAIL') AS "E-MAIL",
       t.tipo,
       t.numero,
       e.bairro,
       e.cidade,
       e.estado
FROM cliente c
INNER JOIN telefone t
ON c.idcliente = t.id_cliente
INNER JOIN endereco e
ON c.idcliente = e.id_cliente;

SELECT * FROM v_relatorio;

/* APAGANDO UMA VIEW */
DROP VIEW v_relatorio;


/* Orde By */
SELECT nome, sexo, email
FROM cliente
ORDER BY nome;


/* PROCEDURE */
DELIMITER $

CREATE PROCEDURE NOME()
BEGIN
	AÇÃO;
END
$

CREATE PROCEDURE CONTA()
BEGIN 
	SELECT 10 + 10 AS "CONTA";
END
$

/* CHAMA PROCEDURE */
CALL CONTA()$

/* PROCEDURE COM PARAMETRO */
DELIMITER $

CREATE PROCEDURE CONTA(NUMERO1 INT, NUMERO2 INT)
BEGIN
	SELECT NUMERO1 + NUMERO2 AS "CONTA";
END
$


/* FUNÇÕES DE AGREGAÇÕES NUMERICAS */

/* MAX - TRAZ O VALOR MAXIMO DE UMA COLUNA */

SELECT MAX(COLUNA) FROM TABELA;

/* MIN - TRAZ O VALOR MINIMO DE UMA COLUNA */

SELECT MIN(COLUNA) FROM TABELA;

/* AVG - TRAZ O VALOR MEDIO DE UMA COLUNA */

SELECT AVG(COLUNA) FROM TABELA;

/* SUM() - AGREGANDO VALORES COM A FUNÇÃO SUM() (SOMA VALORES) */

SELECT SUM(COLUNA) FROM TABELA;

SELECT SUM(COLUNA) AS APELIDO_COLUNA,
SUM(OUTRA_COLUNA) AS APELIDO_COLUNA,
SUM(OUTRA_COLUNA) AS APELIDO_COLUNA
FROM TABELA;


/* SUBQUERIES - UMA QUEY DENTRO DE OUTRA */ 

SELECT COLUNA, COLUNA FROM TABELA
WHERE COLUNA = (SELECT MIN(COLUNA) FROM TABELA);


/* SOMANDO LINHAS  */

SELECT COLUNA1, COLUNA2, COLUNA3,
	   (COLUNA1,COLUNA2,COLUNA3) AS "TOTAL",
       TRUNCATE((COLUNA1,COLUNA2,COLUNA3)/3,2) AS "MEDIA",
       FROM TABELA;
       

/* MODIFICANDO UMA TABELA  */

CREATE TABLE TABELA(
COLUNA1 VARCHAR(30),
COLUNA2 VARCHAR(30),
COLUNA3 VARCHAR(30)
);

 -- ADICIONANDO UMA PK
 
 ALTER TABLE TABELA
 ADD PRIMARY KEY (COLUNA1);
 
-- ADICIONANDO UMA COLUNA SEM POSICAO. ULTIMA POSICAO

ALTER TABLE TABELA
ADD COLUNA VARCHAR(30);

-- ADICIONANDO UMA COLUNA COM POSICAO

ALTER TABLE TABELA
ADD COLUNA4 INT NOT NULL UNIQUE
AFTER COLUNA3;

-- MODIFICNDO O TIPO DE UM CAMPO

ALTER TABLE TABELA MODIFY COLUNA2 DATE NOT NULL;

-- RENOMEANDO O UMA TABELA

ALTER TABLE TABELA
RENAME PESSOA;

-- CRIANDO OUTRA TABELA

CREATE TABLE TIME(
IDTIME INT NOT NULL AUTO_INCREMENT,
TIME VARCHAR(30),
ID_PESSOA VARCHAR(30)
);

-- ADICIONANDO CHAVE PRIMARIA

ALTER TABLE TIME ADD PRIMARY KEY (IDTIME);

-- ADICIONANDO CHAVE ESTRANGEIRA

ALTER TABLE TIME 
ADD FOREIGN KEY (ID_PESSOA)
REFERENCES PESSOA(COLUNA1);

-- ADICIONANDO CHAVE PRIMARIA NOMEADA "CONSTRANINT

ALTER TABLE TIME ADD CONSTRAINT PK_TIME PRIMARY KEY (IDTIME);

-- ADICIONANDO CHAVE ESTRANGEIRA

ALTER TABLE TIME ADD CONSTRAINT FK_TIME_PESSOA FOREIGN KEY (ID_PESSOA)
REFERENCES PESSOA(COLUNA1);

SHOW CREATE TABLE PESSOA;


/* DICIONARIO DE DADOS */

SHOW DATABASES;

/* TABELA QUE CONTEM AS INFORMAÇOES SOBRES AS CONTRAINTS */
USE INFORMATION_SCHEMA; 

SHOW TABLES;

DESC TABLE_CONSTRAINTS;

/* VERIVICANDO TODAS AS CONTRAINTS PRESENTES EM TODOS OS BANCOS */
SELECT CONSTRAINT_SCHEMA AS "NOME DO BANCO",
	   TABLE_NAME AS "NOME DA TABELA",
       CONSTRAINT_NAME AS "NOME DA CONSTRANT",
       CONSTRAINT_TYPE AS "TIPO"
       FROM TABLE_CONSTRAINTS; 
       
/* VERIVICANDO TODAS AS CONTRAINTS PRESENTES EM UM BANCO ESPECIFICO */
SELECT CONSTRAINT_SCHEMA AS "NOME DO BANCO",
	   TABLE_NAME AS "NOME DA TABELA",
       CONSTRAINT_NAME AS "NOME DA CONSTRANT",
       CONSTRAINT_TYPE AS "TIPO"
       FROM TABLE_CONSTRAINTS
       WHERE CONSTRAINT_SCHEMA = 'novoanjo'; 
       
/* APAGANDO CONSTRAINTS */
USE NOME_DO_BANCO;

ALTER TABLE NOME_DA_TABELA 
DROP FOREIGN KEY NOME_DA_CONSTRAINT;

/* TRIGGER */
/* ESTRUTURA DA TRIGGER */

CREATE TRIGGER NOME
BEFORE(ANTES)/AFTER(DEPOIS) INSERT/DELETE/UPDATE ON TABELA
FOR EACH ROW 
BEGIN -> INICIO

	QUALQUER COMANDO SQL
    
END -> FIM