-- Aula dia 18/10/2021
-- Arquitetura de BD
use escola;

-- comando para localizar o arquivo físico das tabelas do banco de dados.
select @@datadir;

-- visualizando as tabelas:
select * from pessoa;

select * from aluno;

-- adicionar um campo na tabela:
alter table aluno add id_teste int;
select * from aluno;

-- alterar o schema de int para varchar
alter table aluno modify id_teste varchar(500);
select * from aluno;

-- alterar o título do campo (tupla)
alter table aluno change column id_teste id_testes varchar(50);
select * from aluno;

-- exclui o campo
alter table aluno drop id_testes;
select * from aluno;

-- ----------------------------------------
-- inserir dados na tabela de pessoa e aluno
select * from pessoa p ;
insert into pessoa (nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
values('Pessoa 1', '999.999.999-99', '1990-10-18', 0, 0, 'Mãe Pessoa 1', 'Pai Pessoa 1');
insert into pessoa (nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
values('Pessoa 2', '899.999.999-99', '1991-10-18', 1, 0, 'Mãe Pessoa 2', 'Pai Pessoa 2');
insert into pessoa (nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
values('Pessoa 3', '799.999.999-99', '1992-10-18', 0, 1, 'Mãe Pessoa 3', 'Pai Pessoa 3');

insert into pessoa (nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
values
	('Pessoa 4', '993.993.993-93', '1989-10-18', 0, 3, 'Mãe Pessoa 4', 'Pai Pessoa 4'),
	('Pessoa 5', '983.993.993-93', '1979-10-18', 0, 3, 'Mãe Pessoa 5', 'Pai Pessoa 5'),
	('Pessoa 6', '893.993.993-93', '1999-10-18', 0, 3, 'Mãe Pessoa 6', 'Pai Pessoa 6'),
	('Pessoa 7', '973.993.993-93', '1994-07-16', 1, 2, 'Mãe Pessoa 7', 'Pai Pessoa 7');
select * from pessoa p ;

-- comando para retornar a data/hora atual do pc
select now();

insert into aluno (dt_cadastro, id_pessoa)
values
	(now(), 1),
	(now(), 2),
	(now(), 3),
	(now(), 4),
	('2021-10-15 15:00', 5), 
	('2021-10-15 15:15', 6),
	('2021-10-13 14:00', 7);
select * from aluno;

-- qual o nome do aluno 3:
-- encontrar em 2 passos:
select * from pessoa p ;
select * from aluno where id_aluno  = 3;
select * from pessoa where id_pessoa  = 3;
-- encontrar em 1 passo:
select 
	a.*, p.nome 
from 
	aluno  as a,
	pessoa as p
where
	a.id_aluno = 3 and
	a.id_pessoa = p.id_pessoa;

-- modelo conceitual:
desc aluno;
desc pessoa;

-- Situação: o PowerBI vai retornar somente os dados de alunos e seus respectivos nomes: 
-- Esquema externo de visualização dos dados; vamos criar uma "view" para representar
--  o esquema externo.
create view vw_aluno_pessoa as
	select 
		a.*, p.nome 
	from 
		aluno  as a,
		pessoa as p
	where
		a.id_pessoa = p.id_pessoa;

select * from vw_aluno_pessoa;

update pessoa set nome = 'Pessoa 3 da Silva' where id_pessoa  = 3;
select * from pessoa;
select * from vw_aluno_pessoa;

alter table pessoa add id_teste int;
update pessoa set id_teste = (id_pessoa * 5);
-- resultado: modificou o nível conceitual e não modificou o esquema externo.
select * from pessoa;
desc pessoa ;
select * from vw_aluno_pessoa;
alter table pessoa drop id_teste;
desc pessoa ;
select * from vw_aluno_pessoa;

