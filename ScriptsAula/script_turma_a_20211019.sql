-- Aula dia 19/10/2021
-- Arquitetura de BD
use escola;

-- comando para localizar arquivo físico das tabelas do banco de dados:
select @@datadir;

-- vizualizando as tabelas:
select * from pessoa;

select * from aluno;

-- Alterando a parte 'conceitual' do BD
-- adicionar um campo na tabela:
alter table aluno add id_teste int;
select * from aluno;

-- alterar o schema de int para varchar
alter table aluno modify id_teste varchar(500);
select * from aluno;

-- alterar o título do campo (tupla)
alter table aluno change column id_teste id_testes varchar(50);
select * from aluno;

alter table aluno drop id_testes;
select * from aluno;

-- ---------------------------------------------------------
-- inserir dados na tabela de pessoa e aluno:
select * from pessoa;
insert into pessoa(nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
values('Pessoa 1', '999.999.999-99', '1990-10-19', 0, 0, 'Mãe Pessoa 1', 'Pai Pessoa 1');

insert into pessoa(nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
values('Pessoa 2', '899.999.999-99', '1991-10-19', 1, 3, 'Mãe Pessoa 2', 'Pai Pessoa 2');

insert into pessoa(nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
values('Pessoa 3', '799.999.999-99', '1992-10-19', 3, 2, 'Mãe Pessoa 3', 'Pai Pessoa 3');

insert into pessoa(nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
values
	('Pessoa 4', '794.999.999-99', '1989-10-19', 0, 1, 'Mãe Pessoa 4', 'Pai Pessoa 4'),
	('Pessoa 5', '795.999.999-99', '1988-10-19', 1, 2, 'Mãe Pessoa 5', 'Pai Pessoa 5'),
	('Pessoa 6', '796.999.999-99', '1994-10-19', 0, 1, 'Mãe Pessoa 6', 'Pai Pessoa 6'),
	('Pessoa 7', '797.999.999-99', '2000-10-19', 1, 2, 'Mãe Pessoa 7', 'Pai Pessoa 7');
select * from pessoa;

-- comando para retornar a data/hora atual do pc
select now();
-- inserir alunos:
insert into aluno (dt_cadastro, id_pessoa)
values
	(now(), 1),
	(now(), 2),
	(now(), 3),
	(now(), 4),
	('2021-10-15 15:00', 7),
	('2021-10-15 15:15', 6),
	('2021-10-13 14:00', 5);
select * from aluno a ;

-- modelo conceitual:
desc pessoa;
desc aluno;

-- qual o nome do aluno 5:
-- encontrar em dois passos:
select * from aluno where id_aluno  = 5;
select * from pessoa where id_pessoa  = 7;

-- encontrar em um passo:
select 
	*
from 
	aluno as a,
	pessoa as p
where 
	a.id_pessoa = p.id_pessoa AND
	a.id_aluno = 5;

-- Nível de visualização/esquema externo:
select 
	a.id_aluno , a.dt_cadastro , p.nome 
from 
	aluno as a,
	pessoa as p
where 
	a.id_pessoa = p.id_pessoa AND
	a.id_aluno = 5;

alter table pessoa add id_teste int;
desc pessoa;
alter table pessoa drop id_teste;

-- Visualização // view:
create view vw_aluno_pessoa as
	select 
		a.id_aluno , a.dt_cadastro , p.nome 
	from 
		aluno as a,
		pessoa as p
	where 
		a.id_pessoa = p.id_pessoa;

select * from vw_aluno_pessoa ;




