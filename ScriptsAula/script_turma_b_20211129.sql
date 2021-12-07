-- Aula 29/11/2021
-- Triggers:

use escola;

CREATE TABLE mensagens ( 
	idmensagens  INTEGER  UNSIGNED NOT NULL AUTO_INCREMENT, 
	id_aluno     INTEGER  UNSIGNED NOT NULL DEFAULT 0, 
	id_professor INTEGER  UNSIGNED NOT NULL DEFAULT 0, 
	dt_mensagem  DATETIME NOT NULL, 
	mensagem     VARCHAR(100) NOT NULL, 
	situacao     INTEGER  UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 Nao lida; 1 Lida; 2 arquivada', 
	dt_leitura   DATETIME DEFAULT '1900-01-01' NOT NULL, 
	PRIMARY KEY (idmensagens)	
) ENGINE = InnoDB;

select * from mensagens;

-- CONCAT
-- 'Parabéns pelo seu dia ' + nomePessoa + '!!!'
-- select concat('Hoje é dia ','de aula de BD2 ','Fulano!!! ', '\o/') as mensagem;
select 
	p.nome,
	concat('Hoje é dia ','de aula de BD2, ',p.nome,'!!! ', '\\o/') mensagem
from 
	aluno a 
		inner join pessoa p on a.id_pessoa = p.id_pessoa;

-- -----------------
select * from mensagens;

insert into mensagens(id_aluno, dt_mensagem, mensagem)
select 
	a.id_aluno,
	now(),
	concat('Hoje é dia ','de aula de BD2, ',p.nome,'!!! ', '\\o/')
from 
	aluno a 
		inner join pessoa p on a.id_pessoa = p.id_pessoa;

insert into mensagens(id_professor, dt_mensagem, mensagem)	
select 
	pr.id_professor,
	now(),
	concat('Professor ',(select p.nome from pessoa p where p.id_pessoa = pr.id_professor), 
	       ' sua turma terá início em fevereiro de 2022')
from
	professor pr;
	
select * from mensagens;	

-- -----------------
-- criar mensagem à alunos no lançamento e atualização de notas:

DELIMITER $
create trigger msg_avaliacao_aluno_ins
after insert on avaliacaoturma
for each row
begin 
	insert into mensagens(id_aluno, dt_mensagem, mensagem)
		select
			avt.id_aluno,
			now(),
			concat('Nota da avaliação ',av.descricao, ' lançada! Nota: ',
					new.nota, ' de ', av.valor,'.') mensagem
		from 
			avaliacaoturma avt
				inner join avaliacao av on avt.id_avaliacao = av.id_avaliacao
		where 
			avt.id_avaliacao = new.id_avaliacao and 
			avt.id_aluno     = new.id_aluno;
end$
DELIMITER ;

select * from mensagens;

select * from avaliacaoturma a;

insert into avaliacaoturma(id_avaliacao, id_aluno, id_turma, id_disciplina,
			dt_avaliacao , nota)
			values(1,6,1,1,now(),17);

-- correção da trigger sem where:
delete from avaliacaoturma where id_avaliacao = 1 and id_aluno = 6 and 
	id_turma  = 1 and id_disciplina  = 1;
delete from mensagens where idmensagens > 9;
drop trigger msg_avaliacao_aluno_ins;

-- testar a trigger:
insert into avaliacaoturma(id_avaliacao, id_aluno, id_turma, id_disciplina,
			dt_avaliacao , nota)
			values(2,6,1,1,now(),27),
			      (2,7,1,1,now(),25),
			      (1,7,1,1,now(),13);

select * from mensagens;

-- update:
DELIMITER $
create trigger msg_avaliacao_aluno_upd
after update on avaliacaoturma 
for each row
begin 
	insert into mensagens(id_aluno, dt_mensagem, mensagem)
		select 
			new.id_aluno,
			now(),
			concat('Nota da avalição ', av.descricao, ' foi alterada!',
			       ' Nota antiga: ',old.nota, ' | Nota nova: ', new.nota,'.')
		from
			avaliacaoturma avt
				inner join avaliacao av on avt.id_avaliacao = av.id_avaliacao 
		where 
			avt.id_avaliacao = new.id_avaliacao and 
			avt.id_aluno     = new.id_aluno;
end$
DELIMITER ;

select * from avaliacaoturma;
update avaliacaoturma 
	set nota = 17
where 
	id_avaliacao = 2 and 
	id_aluno = 6 and 
	id_turma = 1 and 
	id_disciplina = 1;

select * from mensagens;

-- continuação 06/12/2021:
use escola;
DELIMITER $
create trigger msg_avaliacao_aluno_del
after delete on avaliacaoturma 
for each row
begin 
	insert into mensagens(id_aluno, dt_mensagem, mensagem)
		select 
			old.id_aluno,
			now(),
			concat('Nota da avalição ', av.descricao, ' foi excluída!',
			       ' Nota antiga: ',old.nota)
		from
			avaliacaoturma avt
				inner join avaliacao av on avt.id_avaliacao = av.id_avaliacao 
		where 
			avt.id_avaliacao = old.id_avaliacao and 
			avt.id_aluno     = old.id_aluno;
end$
DELIMITER ;

select * from avaliacaoturma;
select * from mensagens;

delete from avaliacaoturma 
where 
	id_avaliacao  = 1 and 
	id_aluno      = 7 and 
	id_turma      = 1 and 
	id_disciplina = 1;

select * from mensagens;

insert into avaliacaoturma (id_avaliacao, id_aluno, id_turma, id_disciplina,
                            dt_avaliacao, nota)
values(1,7,1,1,now(),15);
drop trigger msg_avaliacao_aluno_del;

DELIMITER $
create trigger msg_avaliacao_aluno_del
after delete on avaliacaoturma 
for each row
begin 
	insert into mensagens(id_aluno, dt_mensagem, mensagem)
		select 
			old.id_aluno,
			now(),
			concat('Nota da avalição ', av.descricao, ' foi excluída!')
		from
			avaliacao av 
		where 
			av.id_avaliacao = old.id_avaliacao;
end$
DELIMITER ;

delete from avaliacaoturma 
where 
	id_avaliacao  = 1 and 
	id_aluno      = 7 and 
	id_turma      = 1 and 
	id_disciplina = 1;

select * from mensagens;






	

