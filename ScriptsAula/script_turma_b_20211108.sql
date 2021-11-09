-- Aula 08/11/2021
-- Correção Indices:
show index from avaliacao;
show index from professor;

-- índice tabela Avaliação:
create index idx01 on avaliacao(descricacao);
-- índice tabela Professor:
create index idx01 on professor(formacao);

-- Consultas avançadas:
-- IS
update pessoa set nome_pai = null where id_pessoa in (9427,9428,9429);
select * from pessoa order by nome_pai asc;
select * from pessoa where nome_pai = 'Pai Fulano 1003';
select * from pessoa where nome_pai is null;     -- simula o sinal de igual
select * from pessoa where not nome_pai is null; -- nega a simulação do sinal de igual

-- IN:
select * from aluno;
-- retorna as pessoas que são alunos:
select * from pessoa where id_pessoa in (select id_pessoa from aluno);
-- retorna as pessoas que NÃO são alunos:
select * from pessoa where not id_pessoa in (select id_pessoa from aluno);

select * from pessoa where (nome, nome_mae) in 
	(select nome, nome_mae from pessoa where cpf like '093.%');

-- ALL:
select * from avaliacao;
insert into avaliacao (id_avaliacao, descricacao, valor, observacao) 
values (1,'Prova BD2', 10 ,'');

select * from turma;

select * from alunoturma;
insert into alunoturma values
	(1,2,now(),'1800-01-01'),
	(2,2,now(),'1800-01-01'),
	(3,2,now(),'1800-01-01'),
	(4,2,now(),'1800-01-01'),
	(5,2,now(),'1800-01-01'),
	(6,2,now(),'1800-01-01'),
	(7,2,now(),'1800-01-01');

select * from disciplina;
insert into disciplina(id_disciplina, nome, numero, creditos)
values
	(1,'BD2',123,72);

select * from avaliacaoturma a ;
insert into avaliacaoturma
    (id_avaliacao, id_aluno, id_turma, id_disciplina, dt_avalicacao, nota)
values
	(1,1,2,1,now(),1),
	(2,2,2,1,now(),1),
	(3,3,2,1,now(),1),
	(4,4,2,1,now(),1),
	(5,5,2,1,now(),10),
	(6,6,2,1,now(),1),
	(7,7,2,1,now(),1);
show index from avaliacaoturma;
--
select * from avaliacaoturma where nota > all 
	(select nota from avaliacaoturma where id_avaliacao = 1);

-- ------------------
-- ALIAS:
select p1.* from pessoa as p1 where p1.id_pessoa in 
	(select p2.id_pessoa from pessoa as p2 where p2.sexo = 1);

select p.nome, p.nome_mae, a.dt_cadastro 
	from pessoa p, aluno a where p.id_pessoa = a.id_pessoa;

-- EXISTS:
-- seleciona todas as pessoas que são alunos (pessoa.id_pessoa == aluno.id_pessoa)
select p.* from pessoa p where exists 
	(select a.* from aluno a where p.id_pessoa = a.id_pessoa);

-- seleciona todas as pessoas que NÃO são alunos (pessoa.id_pessoa != aluno.id_pessoa)
select p.* from pessoa p where not exists 
	(select a.* from aluno a where p.id_pessoa = a.id_pessoa);

-- --------------------------------
-- JOINS:
-- Pessoa = a; aluno = b;
select 
	a.*
from pessoa a
	left join aluno b on a.id_pessoa = b.id_pessoa; -- 48528


select 
	a.*
from pessoa a
	left join aluno b on a.id_pessoa  = b.id_pessoa 
where 
	b.id_pessoa is null;

select
	a.nome, a.nome_mae, b.dt_cadastro 
from pessoa a
	inner join aluno b on a.id_pessoa  = b.id_pessoa;
-- select p.* from pessoa p, aluno a where p.id_pessoa = a.id_pessoa

select b.*
from pessoa a
	right join aluno b on a.id_pessoa = b.id_pessoa 
where a.id_pessoa is null; -- result somente alunos q não tenham cadastro como pessoa.
	
	
-- -------------------------
-- COUNT, SUM, MAX, MIN, AVG
select count(*) from pessoa; -- contar
select max(id_pessoa) from pessoa; -- máximo item
select min(id_pessoa) from pessoa; -- menor item
select avg(id_pessoa) from pessoa;

select * from pessoa;

create table valoresagregacao(id int not null auto_increment, valor int not null, id_avaliacao int not null, primary key(id));
select * from valoresagregacao;
insert into valoresagregacao(valor, id_avaliacao)
	values
		(20,1),
		(25,1),
		(21,1),
		(10,1),
		(00,1),
		(28,2),
		(22,2),
		(05,2),
		(10,2),
		(00,2);

-- somar todas os valores da avaliação 1:
select sum(valor) from valoresagregacao where id_avaliacao = 1;
-- média:
select avg(valor) from valoresagregacao where id_avaliacao = 1;
-- maior valor:
select min(valor) from valoresagregacao where id_avaliacao = 1;
-- selecione todos os valores > que a média da avaliação 2
select v1.* from valoresagregacao v1 where v1.valor > 
	(select avg(v2.valor) from valoresagregacao v2 where v2.id_avaliacao = 2 and v1.id_avaliacao = v2.id_avaliacao);


-- GROUP BY | HAVING
select * from avaliacao a ;
select * from valoresagregacao;
-- agrupar a média de valores por avaliação:
select id_avaliacao, avg(valor) from valoresagregacao group by id_avaliacao;
select id_avaliacao, sum(valor) from valoresagregacao group by id_avaliacao;

-- buscar a qte maior que 2 (incidências) de avaliacao que tiveram notas entre 20 e 30pts
select 
	a.id_avaliacao ,
	a.descricacao ,
	count(*)
from
	avaliacao a inner join valoresagregacao v on a.id_avaliacao = v.id_avaliacao
where 
	v.valor between 20 and 30 
group by a.id_avaliacao , a.descricacao 
having count(*) > 1;


