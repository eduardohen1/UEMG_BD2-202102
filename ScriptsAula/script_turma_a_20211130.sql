-- Aula dia 30/11/2021
use escola;

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
drop table mensagens;
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

insert into mensagens(id_aluno, dt_mensagem, mensagem)
values(1,now(),'oi!'),(1,now(),'oi2!'),(1,now(),'oi3!');

select * from mensagens;

delete from mensagens;
truncate table mensagens;

-- ----------------------------
-- CASE WHEN THEN ELSE

-- utilizar como IF THEN ELSE
select (
	case when 2 = 1 then
		'Verdadeiro'
	else 
		'Falso'
	end
);

select (
	case when (10*2) >= 30 then
		concat('Sim, ', (10*2),' é menor que 30')
	else
		concat('Não, ', (10*2),' é menor que 30')
	end
);

select (
	case when (select count(*) from aluno) > 10 then
		'Temos menos que 10 alunos :\'('
	else
		'Temos mais de 10 alunos! \\o/'
	end
);

-- utilizar como SWITCH CASE!
select distinct estado_civil from pessoa;

select * from pessoa where estado_civil in (0,1,2,3) limit 10;
-- --------------------
select 
	*,
	(
		case estado_civil 
			when 0 then 'SOLTEIRO(A)'
			when 1 then 'CASADO(A)'
			when 2 then 'DISQUITADO(A)'
			when 3 then 'DIVORCIADO(A)'
		else 
			'-'
		end
	) estadoCivil,
	(
		case sexo 
			when 0 then 'F'
			when 1 then 'M'
		end
	) sexoTxt
from 
	pessoa
where 
	estado_civil in (0,1,2,3) limit 10;

-- --------------------
select 
	*,
	(
		case estado_civil 
			when 0 then 
				(case when sexo = 0 then 'SOLTEIRA'   else 'SOLTEIRO'   end)
			when 1 then 
				(case when sexo = 0 then 'CASADA'     else 'CASADO'     end)				
			when 2 then 
				(case when sexo = 0 then 'DISQUITADA' else 'DISQUITADO'	end)
			when 3 then 
				(case when sexo = 0 then 'DIVORCIADA' else 'DIVORCIADO'	end)
		else 
			'-'
		end
	) estadoCivil,
	(
		case sexo 
			when 0 then 'F'
			when 1 then 'M'
		end
	) sexoTxt
from 
	pessoa
where 
	estado_civil in (0,1,2,3) limit 10;

select * from pessoa where sexo is null;
update pessoa set sexo = 0 where sexo is null;
update pessoa set sexo = 0 where id_pessoa  =3;

-- --------------------------------
drop trigger msg_avaliacao_aluno_ins;

DELIMITER $
create trigger msg_avaliacao_aluno_ins
after insert on avaliacaoturma
for each row 
begin 
	insert into mensagens(id_aluno, dt_mensagem, mensagem)
		select id_aluno, now(),
			concat('Nota da avaliação ', av.descricao,' lançada! Nota: ',new.nota, ' de ', av.valor,'. ',
				(
					case when new.nota >= (av.valor * 0.6) then
						'Sua nota está acima da média desta avaliação.'
					else 
						'Sua nota está abaixo da média desta avaliação.'
					end
				)
			)
		from
			avaliacaoturma avt
				inner join avaliacao av on avt.id_avaliacao = av.id_avaliacao 
		where 
			avt.id_avaliacao = new.id_avaliacao and 
			avt.id_aluno     = new.id_aluno;
end$
DELIMITER ;

select * from mensagens;
select * from avaliacaoturma;
select * from avaliacao;

delete from avaliacaoturma where id_aluno in (6,7);
insert into avaliacaoturma (id_avaliacao, id_aluno, id_turma, id_disciplina, dt_avaliacao, nota)
	values(1,6,1,1,now(),17), (1,7,1,1,now(),20);
select * from avaliacaoturma;
select * from mensagens;
truncate table mensagens;

-- ---------------------------------------------
-- STORED PROCEDURES:

set global log_bin_trust_function_creators =1;

use escola;
DELIMITER $
create function func_idade(dtNascimento DATETIME)
returns INTEGER
begin	
	return timestampdiff(year, dtNascimento, now());	
end$
DELIMITER ;

select func_idade('1990-08-20');
select func_idade('2000-12-01');

select * from pessoa limit 5;
select *, func_idade(dt_nascimento) idade from pessoa limit 5;












