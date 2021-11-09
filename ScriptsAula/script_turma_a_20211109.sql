-- Aula 09/11/2021
-- Correção Indices:
show index from avaliacao;
show index from professor;

-- índice tabela avaliacao:
create index idx01 on avaliacao(descricao);
create index idx01 on professor(formacao);

-- -----------------------------------------
update pessoa set nome_pai = null where id_pessoa in (9427,9428,9429);
DROP TABLE IF EXISTS `avaliacaoturma`;
DROP TABLE IF EXISTS `avaliacao`;
CREATE TABLE `avaliacao` (
  `id_avaliacao` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(45) NOT NULL,
  `valor` double NOT NULL,
  `observacao` text,
  PRIMARY KEY  (`id_avaliacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `avaliacaoturma` (
  `id_avaliacao` int(11) NOT NULL,
  `id_aluno` int(11) NOT NULL,
  `id_turma` int(11) NOT NULL,
  `id_disciplina` int(11) NOT NULL,
  `dt_avaliacao` datetime NOT NULL,
  `nota` double NOT NULL,
  PRIMARY KEY  (id_avaliacao, id_aluno, id_turma, id_disciplina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO avaliacao(descricao, valor, observacao) VALUES
	('Trabalho 1', 30, 'Trabalho sobre BD'), 
	('Trabalho 2', 30, 'Trabalho sobre INNER JOIN'), 
	('AVALIAÇÃO' , 40, 'AVALIAÇÃO FINAL');

INSERT INTO avaliacaoturma(id_avaliacao, id_aluno, id_turma, id_disciplina, dt_avaliacao,nota) VALUES
	(1, 1, 1, 1, '2020-12-08',20),
	(1, 2, 1, 1, '2020-12-08',25),
	(1, 3, 1, 1, '2020-12-08',21),
	(1, 4, 1, 1, '2020-12-08',10),
	(1, 5, 1, 1, '2020-12-08',0),
	(2, 1, 1, 1, '2020-12-18',28),
	(2, 2, 1, 1, '2020-12-18',22),
	(2, 3, 1, 1, '2020-12-18',05),
	(2, 4, 1, 1, '2020-12-18',10),
	(2, 5, 1, 1, '2020-12-18',0);

-- ----------------------------------------------
-- NULL
select * from pessoa where nome_pai <> null; -- não retorna nenhum registro. = ou <>

select * from pessoa where     nome_pai is null; -- simula o sinal de =
select * from pessoa where not nome_pai is null; -- simula o sinal de <>

-- IN
-- selecionar pessoas com os ids: 9430,9550,9660
select * from pessoa where id_pessoa = 9430 or id_pessoa = 9550 or id_pessoa = 9660;
select * from pessoa where id_pessoa in (9430,9550,9660);

-- selecionar pessoas que não tem os ids: 9430,9550,9660
select * from pessoa where id_pessoa <> 9430 and id_pessoa <> 9550 and id_pessoa <> 9660;
select * from pessoa where not id_pessoa in (9430,9550,9660);

-- selecionar pessoas que são alunos
select * from aluno;
select pessoa.* from pessoa, aluno where pessoa.id_pessoa = aluno.id_pessoa;
select * from pessoa where id_pessoa in (select id_pessoa from aluno);
select * from pessoa where nome_pai in ('Pai Fulano 1003', 'Pai Fulano 1010', 'Pai Fulano 1111');
select * from pessoa where id_pessoa in (
	select id_pessoa from pessoa where nome_mae in ('Mae Fulano 2000','Mae Fulano 2010', 'Mae Fulano 2011')
);

-- LIKE
select * from pessoa where cpf like '093%'; -- cpf começa com 093
select * from pessoa where cpf like '093.5%';
select * from pessoa where cpf like '%6-11'; -- cpf termina com 6-11
select * from pessoa where cpf like '%586.%'; -- cpf q tenha 581. no meio

SELECT * FROM pessoa WHERE (nome, nome_mae) IN 
 (SELECT nome, nome_mae FROM pessoa WHERE cpf LIKE '093.%');

-- ALL // ALIAS
-- Retorna os dados de qualquer avaliação da turma cujo a nota é maior 
--  que todas as notas da avaliação igual a 1
SELECT at1.* FROM avaliacaoturma as at1 WHERE at1.nota > ALL 
	(SELECT at2.nota 
	 FROM avaliacaoturma as at2 
	 WHERE 
	 	at2.id_avaliacao = 1  
	);

-- EXISTS
-- existe alguma pessoa que é aluno?
select p.* from pessoa p where exists (select a.* from aluno a where p.id_pessoa = a.id_pessoa);
-- existe alguma pessoa que não é aluno?
select p.* from pessoa p where not exists (select a.* from aluno a where p.id_pessoa = a.id_pessoa);

-- JOINS:
-- Pessoa = a; Aluno = b
select pessoa.* from pessoa, aluno where 
	pessoa.id_pessoa  = aluno.id_pessoa;
select a.* from pessoa a where 
	a.id_pessoa in (select b.id_pessoa from aluno b);
select count(*) from pessoa; -- 48528
select count(*) from aluno; -- 7

-- LEFT JOIN
select a.*
from pessoa a
	left join aluno b 
	on a.id_pessoa = b.id_pessoa;

select a.*
from pessoa a
	left join aluno b 
	on a.id_pessoa  = b.id_pessoa 
where b.id_pessoa is null;

-- INNER JOIN
select a.*
from pessoa a
	inner join aluno b 
	on a.id_pessoa  = b.id_pessoa ;

-- COUNT, SUM, MAX, MIN, AVG
select count(*) from pessoa;
select count(*) qtePessoas from pessoa where sexo = 1;
select sum(nota) from avaliacaoturma a  where id_aluno = 2
	and id_avaliacao = 1;
select max(nota) from avaliacaoturma where id_avaliacao =2;
select min(nota) from avaliacaoturma where id_avaliacao =2;

select * from avaliacaoturma where id_avaliacao =2;
select avg(nota) from avaliacaoturma where id_avaliacao =2;

-- GROUP BY e HAVING
-- Quero saber a média das notas das avaliações:
select * from avaliacaoturma;
select id_avaliacao, avg(nota) from avaliacaoturma group by id_avaliacao;

select * from avaliacao;
select * from avaliacaoturma;
select 
	a.descricao,
	max(avt.nota)
from
	avaliacaoturma avt inner join avaliacao a on avt.id_avaliacao = a.id_avaliacao 
group by a.descricao;

select * from avaliacaoturma;

-- Buscando a quantidade (incidência) maior que 2 de avaliações que tiveram notas entre 20 e 30 pts:
select 
	a.descricao,
	count(*)
from avaliacao a inner join avaliacaoturma avt on a.id_avaliacao  = avt.id_avaliacao
where 
	avt.nota between 20 and 30 
group by a.descricao
having count(*) >= 2;





