-- Aula 23/11/2021
-- Triggers

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

-- Criar mensagem à alunos no lançamento e atualização de notas
insert into mensagens(id_aluno, dt_mensagem, mensagem)
	select 
		a.id_aluno, now() dt_mensagem, 
		concat((select p.nome from pessoa p where p.id_pessoa = a.id_pessoa),', ','Teste na tabela de mensagens') 
		mensagem 
	from aluno a where a.id_aluno in (1,2,3,7);

-- trigger:
DELIMITER $
create trigger msg_avaliacao_aluno_ins
after insert on avaliacaoturma
for each row 
begin 
	insert into mensagens(id_aluno, dt_mensagem, mensagem)
		select id_aluno, now(),
			concat('Nota da avaliação ', av.descricao,' lançada! Nota: ',new.nota, ' de ', av.valor,'.')
		from
			avaliacaoturma avt
				inner join avaliacao av on avt.id_avaliacao = av.id_avaliacao 
		where 
			avt.id_avaliacao = new.id_avaliacao;
end$
DELIMITER ;

select * from mensagens;

-- testando a trigger:
insert into avaliacaoturma(id_avaliacao, id_aluno, id_turma, id_disciplina, dt_avaliacao, nota)
values(1,6,1,1,now(),15);
select * from avaliacao where id_avaliacao  = 1;

select * from avaliacaoturma;
select * from mensagens; -- apresentou erro, pois não filtrou por id_aluno:

-- vamos deletar a trigger e recria-la do jeito certo:
drop trigger escola.msg_avaliacao_aluno_ins;

DELIMITER $
create trigger msg_avaliacao_aluno_ins
after insert on avaliacaoturma
for each row 
begin 
	insert into mensagens(id_aluno, dt_mensagem, mensagem)
		select id_aluno, now(),
			concat('Nota da avaliação ', av.descricao,' lançada! Nota: ',new.nota, ' de ', av.valor,'.')
		from
			avaliacaoturma avt
				inner join avaliacao av on avt.id_avaliacao = av.id_avaliacao 
		where 
			avt.id_avaliacao = new.id_avaliacao and avt.id_aluno = new.id_aluno;
end$
DELIMITER ;

delete from mensagens where idmensagens >= 8;
select * from mensagens m ;
select * from avaliacaoturma a ;
delete from avaliacaoturma where id_avaliacao  = 1 and id_aluno = 6 and id_turma = 1 and id_disciplina =1;

-- testar a trigger:
insert into avaliacaoturma(id_avaliacao, id_aluno, id_turma, id_disciplina, dt_avaliacao, nota)
values(1,6,1,1,now(),15);

insert into avaliacaoturma(id_avaliacao, id_aluno, id_turma, id_disciplina, dt_avaliacao, nota)
values(2,6,1,1,now(),20),(2,7,1,1,now(),25),(1,7,1,1,now(),13);
select * from avaliacaoturma a ;

select * from mensagens m ;

-- --------------------------
DELIMITER $
create trigger msg_avaliacao_aluno_upd
after update on avaliacaoturma 
for each row 
begin 
	insert into mensagens(id_aluno, dt_mensagem, mensagem)
		select
			new.id_aluno,
			now(),
			concat('Nota da avaliação ',av.descricao,' foi alterada! Nota antiga: ',
				   old.nota, ' | Nota nova: ', new.nota,'.') 
		from avaliacaoturma avt
			inner join avaliacao av on avt.id_avaliacao = av.id_avaliacao 
		where 
			avt.id_avaliacao = new.id_avaliacao and avt.id_aluno = new.id_aluno;
end$
DELIMITER ;

-- testar:
select * from mensagens;
select * from avaliacaoturma;

update avaliacaoturma 
	set nota = 23 
where 
	id_avaliacao =1 and 
	id_aluno =7 and 
	id_turma = 1 and 
	id_disciplina =1;
select * from avaliacaoturma;
select * from mensagens;

DELIMITER $
create trigger msg_avaliacao_aluno_del
after delete on avaliacaoturma 
for each row 
begin 
	insert into mensagens(id_aluno, dt_mensagem, mensagem)
		select
			old.id_aluno,
			now(),
			concat('Nota da avaliação ',av.descricao,' foi excluída!') 
		from avaliacao av  
		where 
			av.id_avaliacao = old.id_avaliacao;
end$
DELIMITER ;

-- testar delete 
insert into avaliacaoturma(id_avaliacao, id_aluno, id_turma, id_disciplina, dt_avaliacao, nota)
values(1,7,1,1,now(),23);

delete from avaliacaoturma 
where 
	id_avaliacao =1 and 
	id_aluno =7 and 
	id_turma = 1 and 
	id_disciplina =1;
select * from avaliacaoturma;
select * from mensagens;
