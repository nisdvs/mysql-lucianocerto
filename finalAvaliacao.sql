create database meubanco;
use meubanco;

 -- drop database meubanco;

create table fabricante (
id bigint not null primary key,
nome varchar(100),
endereco varchar(100),
telefone varchar(100)
);

create table tipoProduto(
idTipo bigint not null auto_increment primary key,
tipo varchar(100) not null
);

create table produto(
codigo_produto bigint not null primary key,
tipo bigint not null,
designacao varchar(100) not null,
composicao varchar(100) not null,
codigo_fabricante bigint not null,
preco_venda decimal(5,2) not null,
foreign key (codigo_fabricante) references fabricante(id),
foreign key (tipo) references tipoProduto(idTipo)
);

create table cliente(
codigo_cliente bigint not null auto_increment primary key,
nome varchar(100) not null,
endereco varchar(100) not null,
telefone varchar(100) not null,
cpf varchar(100) not null,
codigo_postal bigint not null,
localidade varchar(100) not null,
numero_contribuinte bigint not null
);

create table medico (
codigo_medico bigint not null auto_increment primary key,
nome_medico varchar(100) not null
);


create table receita(
id bigint not null auto_increment primary key,
descricao varchar(100) not null,
receita_medico bigint not null,
receita_cliente bigint not null,
foreign key (receita_medico) references medico(codigo_medico),
foreign key (receita_cliente) references cliente(codigo_cliente)
);

create table compra(
numero_compra bigint not null primary key,
codigo_cliente bigint not null,
codigo_medico bigint not null,
total_venda varchar(100) not null,
data_compra date not null,
foreign key (codigo_cliente) references cliente(codigo_cliente),
foreign key (codigo_medico) references medico(codigo_medico)
); 

create table ItemCompra (
id bigint not null auto_increment primary key,
numero_compra bigint not null,
codigo_produto bigint not null,
quantidade bigint not null,
foreign key (numero_compra) references compra(numero_compra),
foreign key (codigo_produto) references produto(codigo_produto)
);

INSERT INTO Fabricante (id, nome, endereco, telefone)
VALUES
(1, 'Fabricante X', 'Rua A, 123', '(33) 1111-3333'),
(2, 'Fabricante Y', 'Av. B, 456', '(11) 2222-1111'),
(3, 'Fabricante Z', 'Rua C, 789', '(22) 3333-2222'),
(4, 'Fabricante W', 'Av. D, 101', '(55) 4444-5555'),
(5,'Fabricante V', 'Rua E, 202', '(66) 5555-6666');

INSERT INTO Medico (nome_medico, codigo_medico)
VALUES ('Dr. Silva', 1),
('Dr. Marcos', 2),
('Dr. Juliana', 3),
('Dr. Cezar', 4); 

INSERT INTO Cliente (codigo_cliente, nome, endereco, telefone, cpf, codigo_postal, localidade, numero_contribuinte)
VALUES (1, 'Alanis', 'Rua Sara Candido', '19996488246', '50529769840', '2472748468273', 'Campinas', '304903403'),
(2, 'Felipe', 'Rua Arroz Doce', '192973438745', '343455656578', '2334343444565', 'Campinas', '343455456');

INSERT INTO receita (descricao, receita_medico, receita_cliente)
VALUES
('Receita para Aspirina', 1, 1),
('Receita para Dipirona', 2, 2),
('Receita para Buscopan', 1, 2),
('Receita para Dramin', 3, 1);

INSERT INTO tipoProduto VALUES 
(1, "COSM"),
(2, "reme");

INSERT INTO Produto (codigo_produto, tipo, designacao, composicao, codigo_fabricante, preco_venda)
VALUES (2, 1, 'Aspirina', 'Ácido Acetilsalicílico', '1', 10.99),
(3, 2, 'Buscopan', 'Ácido Acetilsalicílico', '2', 9.99),
(4, 1, 'Dipirona', 'Ácido Acetilsalicílico', '3', 8.99),
(5, 2, 'Dramin', 'Ácido Acetilsalicílico', '4', 10.99);



INSERT INTO Compra (numero_compra, codigo_cliente, codigo_medico, total_venda, data_compra)
VALUES 
(1, 1, 1, '50.00', '2023-10-09'),
(2, 1, 1, '50.00', '2023-10-09'),
(5, 2, 3, '52.00', '2023-11-07'),
(6, 1, 4, '52.00', '2023-11-07');


INSERT INTO ItemCompra (numero_compra,codigo_produto, quantidade)
VALUES (2, 5, 1),
(2, 2, 1),
(6, 3, 2);



/*
SELECT * FROM Compra; /*Um médico devera ter sido o responsável por pelo menos duas compras de clientes distintos 

SELECT data_compra, COUNT(*) AS compras   /* Pelo menos duas compras deverá ser feita no mesmo dia 
FROM compra
GROUP BY data_compra
HAVING COUNT(*) >= 2;  

SELECT CO.numero_compra, C.codigo_cliente, C.nome AS nome_cliente, COUNT(DISTINCT IC.codigo_produto) AS produtos_comprados  /* Um cliente deverá ter comprado mais de um produto numa compra 
FROM cliente AS C
JOIN compra AS CO ON C.codigo_cliente = CO.codigo_cliente
JOIN ItemCompra AS IC ON CO.numero_compra = IC.numero_compra
GROUP BY CO.numero_compra, C.codigo_cliente, C.nome
HAVING produtos_comprados > 1;
*/

/* CONSULTAS */
/* 1 */
select nome, cpf, telefone from cliente ;
select * from compra;

/* 2 */
select cl.codigo_cliente, cl.nome, co.numero_compra, co.total_venda, co.data_compra from cliente as cl
inner join compra as co ON Cl.codigo_cliente = CO.codigo_cliente
inner join ItemCompra AS IC ON CO.numero_compra = IC.numero_compra;

/* 3 */
select cl.codigo_cliente, cl.nome, ic.codigo_produto, pd.designacao, ic.quantidade, pd.preco_venda, co.total_venda from cliente as cl
inner join compra as co ON Cl.codigo_cliente = CO.codigo_cliente
inner join ItemCompra AS IC ON CO.numero_compra = IC.numero_compra
inner join produto as pd on pd.codigo_produto = ic.codigo_produto;

/* 4 */
select cl.nome, count(co.codigo_cliente) as total_vendas from cliente as cl
inner join compra as co on Cl.codigo_cliente = CO.codigo_cliente
group by co.codigo_cliente 
ORDER BY co.codigo_cliente DESC;

/* 5 */
select me.nome_medico, count(co.codigo_medico) as total_compras from medico as me
inner join compra as co on me.codigo_medico = co.codigo_medico
group by co.codigo_medico 
ORDER BY co.codigo_medico ASC;

/* 6 */
select data_compra, SUM(total_venda) AS faturamento_por_dia from compra
group BY data_compra;

/* 7 */
select  SUM(total_venda) AS faturamento_total from compra;

/* 8 */
UPDATE produto SET preco_venda = 25 WHERE codigo_produto = 3;
INSERT INTO produto VALUES (6,2,"Histamin", "Roxinho", 2, 40);
select * from produto;

/* 9 */
DELETE FROM itemcompra WHERE numero_compra = 6;
DELETE from compra WHERE numero_compra = 6;