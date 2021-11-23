-- Aula 22/11/2021
use escola;

-- correção tarefa:
-- a pessoa; b - aluno
select b.*
from pessoa a 
	right join aluno b on a.id_pessoa = b.id_pessoa;
	
select b.*
from pessoa a
	right join aluno b on a.id_pessoa = b.id_pessoa 
where a.id_pessoa is null;

-- full outer join
select *
from pessoa a
	full outer join aluno b on a.id_pessoa = b.id_pessoa;

-- UNION
insert into professor values(1,'MESTRE',8),(2,'ESPEC',9);
select * from professor;
select * from aluno;

select     id_aluno id,              dt_cadastro, '-' formacao, id_pessoa, '0' tabela from aluno     union all
select id_professor id, '1900-01-01' dt_cadastro,     formacao, id_pessoa, '1' tabela from professor union all
select    id_pessoa id, '1900-01-01' dt_cadastro, '-' formacao, id_pessoa, '2' tabela from pessoa;

select id_pessoa,     nome,                  cpf, '0' tabela from pessoa union all
select id_pessoa, '-' nome, '000.000.000-00' cpf, '1' tabela from aluno order by id_pessoa;

-- resolvendo descontinuidade do full outer join no mysql:
select *
from pessoa a 
	left join aluno b on a.id_pessoa = b.id_pessoa union all
select *
from pessoa a
	right join aluno b on a.id_pessoa = b.id_pessoa;

-- -----------------------------------------------------
-- VIEWS:
-- -----------------------------------------------------
-- selecionar uma listagem de alunos q contenha nome, cpf, dt_nascimento, dt_cadastro
select 
	p.nome, p.cpf, p.dt_nascimento, a.dt_cadastro, a.id_aluno
from 
	aluno a, 
	pessoa p
where 
	a.id_pessoa = p.id_pessoa;

-- inner join:
select 
	p.nome, p.cpf, p.dt_nascimento, a.dt_cadastro, a.id_aluno
from 
	aluno a inner join pessoa p on a.id_pessoa = p.id_pessoa;

-- ----------------
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

truncate table alunoturma;

DROP TABLE IF EXISTS alunoturma;
CREATE TABLE alunoturma (
  id_aluno int NOT NULL,
  id_turma int NOT NULL,
  dt_matricula datetime NOT NULL,
  dt_cancelamento datetime NOT NULL,
  PRIMARY KEY (id_aluno,id_turma)  
) ENGINE=InnoDB DEFAULT
-- ----------------

insert into alunoturma(id_aluno, id_turma, dt_matricula,dt_cancelamento) values
	(1,1,now(),'1900-01-01'),
	(2,1,now(),'1900-01-01'),
	(3,1,now(),'1900-01-01'),
	(4,2,now(),'1900-01-01'),
	(5,2,now(),'1900-01-01'),
	(6,2,now(),'1900-01-01');

select * from alunoturma;
select * from turma;

-- select base:
select 
	p.nome, p.cpf, p.dt_nascimento,
	a.dt_cadastro,
	alt.dt_matricula,
	t.dt_incial, t.dt_final, t.ano, t.periodo, t.descricao
from 
	pessoa p
		inner join aluno a        on p.id_pessoa  = a.id_pessoa
		inner join alunoturma alt on a.id_aluno   = alt.id_aluno
		inner join turma t        on alt.id_turma = t.id_turma;

-- criar a view:
create view vw_pessoa_aluno_turma as
select 
	p.nome, p.cpf, p.dt_nascimento,
	a.dt_cadastro,
	alt.dt_matricula,
	t.dt_incial, t.dt_final, t.ano, t.periodo, t.descricao
from 
	pessoa p
		inner join aluno a        on p.id_pessoa  = a.id_pessoa
		inner join alunoturma alt on a.id_aluno   = alt.id_aluno
		inner join turma t        on alt.id_turma = t.id_turma;

-- utilizando a view:
select * from vw_pessoa_aluno_turma;
select * from vw_pessoa_aluno_turma where descricao = 'BD2-A';

select * from pessoa where nome = 'Pessoa 6';
update pessoa set nome = 'Pessoa 6 View da Silva' where id_pessoa  = 6;

-- criar uma view, onde retorna o nome do aluno e sua média de notas:
select
	p.nome, avg(avt.nota) media
from
	avaliacaoturma avt
		inner join alunoturma alt on avt.id_aluno = alt.id_aluno
		inner join aluno a        on alt.id_aluno = a.id_aluno 
		inner join pessoa p       on a.id_pessoa  = p.id_pessoa 
group by p.nome;
-- tracert
select * from pessoa         where id_pessoa = 1;
select * from aluno          where id_pessoa = 1;
select * from alunoturma     where id_aluno  = 1;
select * from avaliacaoturma where id_aluno  = 1;

create view vw_pessoa_media_nota as
select
	p.nome, avg(avt.nota) media
from
	avaliacaoturma avt
		inner join alunoturma alt on avt.id_aluno = alt.id_aluno
		inner join aluno a        on alt.id_aluno = a.id_aluno 
		inner join pessoa p       on a.id_pessoa  = p.id_pessoa 
group by p.nome;

select * from vw_pessoa_media_nota;

-- -----------------------
select 
	av.descricao, avt.dt_avaliacao, av.valor, avg(avt.nota) media
from
	avaliacaoturma avt
		inner join avaliacao av on avt.id_avaliacao = av.id_avaliacao
group by av.descricao, avt.dt_avaliacao;

create view vw_media_avaliacao as
select 
	av.descricao, avt.dt_avaliacao, av.valor, avg(avt.nota) media
from
	avaliacaoturma avt
		inner join avaliacao av on avt.id_avaliacao = av.id_avaliacao
group by av.descricao, avt.dt_avaliacao;

select * from vw_media_avaliacao;

-- -------------------------------
select     
	a.id_aluno id, a.dt_cadastro, '-' formacao, a.id_pessoa, 
	(select p.nome from pessoa p where p.id_pessoa = a.id_pessoa) nome, 
	'0' tabela 
from 
	aluno a union all
select 
	pr.id_professor id, '1900-01-01' dt_cadastro, pr.formacao, pr.id_pessoa, 
	(select p.nome from pessoa p where p.id_pessoa = pr.id_pessoa) nome, 
	'1' tabela 
from professor pr;

create view vw_aluno_professor_relatorio as 
select     
	a.id_aluno id, a.dt_cadastro, '-' formacao, a.id_pessoa, 
	(select p.nome from pessoa p where p.id_pessoa = a.id_pessoa) nome, 
	'0' tabela 
from 
	aluno a union all
select 
	pr.id_professor id, '1900-01-01' dt_cadastro, pr.formacao, pr.id_pessoa, 
	(select p.nome from pessoa p where p.id_pessoa = pr.id_pessoa) nome, 
	'1' tabela 
from professor pr;

select * from vw_aluno_professor_relatorio;


