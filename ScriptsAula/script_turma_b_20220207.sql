-- Aula dia 07/02/2022
-- Transações:
use escola;

-- excluir foreign key entre aluno->pessoa
alter table aluno drop foreign key fk_aluno_pessoa;
-- excluir foreign key entre alunoturma->aluno:
alter table alunoturma drop foreign key fk_aluno;

-- reaver nosso dados:
select * from aluno;
start transaction;
	delete from aluno where id_aluno = 7;
	select * from aluno;
rollback;
select * from aluno;

-- iniciar a transação:
start transaction;
	update aluno set dt_cadastro = now() where id_aluno = 7;
	-- delete from aluno where id_aluno = 5;
	select * from aluno;
-- rollback;
commit;
select * from aluno;

-- Transação com pontos de salvamento:
insert into aluno values(9,now(), 97);
select * from aluno;
start transaction;
	update aluno set dt_cadastro = now() where id_aluno = 3;
	update aluno set dt_cadastro = now() where id_aluno = 1;
	update aluno set id_pessoa = 98      where id_aluno = 8;
	select * from aluno;
	savepoint atualizacao01;
	delete from aluno where id_aluno = 9;
	select * from aluno;
	rollback to atualizacao01;
	update aluno set id_pessoa = 99 where id_aluno  = 9;
	select * from aluno;
commit;
-- rollback;
select * from aluno;

-- transação com ISOLATION LEVEL:
select * from aluno;
set session transaction isolation level serializable;
start transaction;
	update aluno set dt_cadastro = now() where id_aluno = 5;
	update aluno set id_pessoa = 101 where id_aluno = 8;
	insert into aluno values(10, '2022-01-01 16:15', 100);
	select * from aluno;
-- rollback;
commit;
select * from aluno;





