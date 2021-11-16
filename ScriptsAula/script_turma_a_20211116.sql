-- Aula 16/11/2021
use escola;

-- Correção tarefa:
-- a pessoa b - aluno

select b.*
from pessoa a
right join aluno b on a.id_pessoa  = b.id_pessoa;

select b.*
from pessoa a
right join aluno b on a.id_pessoa  = b.id_pessoa 
where a.id_pessoa  is null;

select b.*
from pessoa b
right join aluno a on a.id_pessoa  = b.id_pessoa 
where a.id_pessoa  is null;


-- full outer join
select *
from pessoa a
full outer join aluno b on a.id_pessoa  = b.id_pessoa;

-- UNION
select id_pessoa,     nome,                  cpf, '0' tabela from pessoa union all
select id_pessoa, '-' nome, '000.000.000-00' cpf, '1' tabela from aluno order by id_pessoa;

-- resolvendo descontinuidade do full outer join no mysql:
select *
from pessoa a
left join aluno b on a.id_pessoa = b.id_pessoa union ALL
select *
from pessoa a
right join aluno b on a.id_pessoa  = b.id_pessoa;

-- -------------------------------------------------------
-- VIEWS

select * from alunoturma a ;
select * from turma;

insert into alunoturma(id_aluno, id_turma, dt_matricula,dt_cancelamento) values
	(1,1,now(),'1900-01-01'),
	(2,1,now(),'1900-01-01'),
	(3,1,now(),'1900-01-01'),
	(4,2,now(),'1900-01-01'),
	(5,2,now(),'1900-01-01'),
	(6,2,now(),'1900-01-01');

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
select * from pessoa where id_pessoa  = 4;
update pessoa set nome = 'Pessoa 4 da Silva' where id_pessoa = 4;

select * from vw_pessoa_aluno_turma;
select * from vw_pessoa_aluno_turma where cpf = '799.999.999-99';

-- criar uma view, onde retorna o nome do aluno e sua média de notas:
select
	p.nome, avg(avt.nota) media
from
	avaliacaoturma avt
		inner join alunoturma alt on avt.id_aluno = alt.id_aluno 
		inner join aluno a        on alt.id_aluno = a.id_aluno 
		inner join pessoa p       on a.id_pessoa  = p.id_pessoa
group by p.nome;
-- tracert:
select * from pessoa where id_pessoa  = 1;
select * from aluno where id_pessoa = 1;
select * from alunoturma where id_aluno  = 1;
select * from avaliacaoturma a where id_aluno  = 1;

-- criar a view:
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

-- retornar as médias das avaliações (Descrição da avaliação, dt_avaliacao, média)
select 
	av.descricao, avt.dt_avaliacao, avg(avt.nota) media
from
	avaliacaoturma avt
		inner join avaliacao av on avt.id_avaliacao  = av.id_avaliacao
group by av.descricao, avt.dt_avaliacao;

-- criar view:
create view vw_media_avaliacoes as 
select 
	av.descricao, avt.dt_avaliacao, avg(avt.nota) media
from
	avaliacaoturma avt
		inner join avaliacao av on avt.id_avaliacao  = av.id_avaliacao
group by av.descricao, avt.dt_avaliacao;
select * from vw_media_avaliacoes;

	