-- Aula 07/12/2021
-- Continuação de Stored Procedure:
use escola;

create table mediageral(id_media integer auto_increment not null,
                        media real not null default 0, 
                        primary key(id_media));
insert into mediageral(media) values(60);

select * from mediageral;
select media from mediageral where id_media = 1;

select * from avaliacaoturma;

-- função de cálculo de média:
DELIMITER $
create function func_media(notaAluno INTEGER, notaAvaliacao INTEGER)
returns INTEGER
begin
	declare valor_media real;
	declare calculo real;
	
	-- buscar o valor da média na tabela:
	select media into valor_media from mediageral where id_media = 1;	

	-- calculo:
	-- 15 >= (30 * 0.60)
	set calculo = notaAvaliacao * (valor_media / 100);
	if notaAluno >= calculo then
		return 0;
	else
		return 1;
	end if;
end$
DELIMITER ;

drop function func_media;

select func_media(10,30);
select 
	avt.*, av.descricao, av.valor,
	(
		case func_media(avt.nota, av.valor) 
			when 0 then 'Nota acima da média \\o/!'
			when 1 then 'Nota abaixo da média :\'('
		end
	) se_media
from 
	avaliacaoturma avt
		inner join avaliacao av on avt.id_avaliacao  = av.id_avaliacao;

-- vamos mudar a média de 60% para 70%
update mediageral set media = 70 where id_media = 1;
select * from mediageral m ;

select 
	avt.*, av.descricao, av.valor,
	(
		case func_media(avt.nota, av.valor) 
			when 0 then 'Nota acima da média \\o/!'
			when 1 then 'Nota abaixo da média :\'('
		end
	) se_media
from 
	avaliacaoturma avt
		inner join avaliacao av on avt.id_avaliacao  = av.id_avaliacao;

-- procedures:
-- Procedimento para retornar uma lista de pessoas pelo parametro de sexo:
DELIMITER $
create procedure proc_listaPessoasSexo(sexoParam VARCHAR(1))
begin
	if sexoParam = 'M' then
		select * from pessoa where sexo = 1;
	elseif sexoParam = 'F' then
		select * from pessoa where sexo = 0;
	else
		select * from pessoa where sexo not in (0,1);
	end if;
end$
DELIMITER ;
		
call proc_listaPessoasSexo('X');

-- criar um procedimento para inserir com um único comando os dados
--  de aluno e pessoa
DELIMITER $
create procedure proc_novoAluno(var_nome varchar(100),
                                var_cpf varchar(14) ,
                                var_dt_nascimento datetime,
                                var_sexo integer,
                                var_estado_civil integer,
                                var_nome_mae varchar(100),
                                var_nome_pai varchar(100),
                                var_dt_cadastro datetime
)
begin
	declare var_idPessoa integer;
	insert into pessoa(nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
	     values(var_nome, var_cpf, var_dt_nascimento, var_sexo, var_estado_civil, var_nome_mae,var_nome_pai);
	
	select last_insert_id() into var_idPessoa;
	
	insert into aluno(id_pessoa, dt_cadastro) values(var_idPessoa, var_dt_cadastro);	
	
end$
DELIMITER ;

call proc_novoAluno('Nome Aluno Procedimento',
					'111.111.111-11',
					'2000-01-20',
					1,
					0,
					'Mae Aluno Procedimento',
					'Pai Aluno Procedimento',
					now());

drop procedure proc_novoAluno;

select * from pessoa order by id_pessoa desc limit 5;
select * from aluno; -- 48530

-- criar um procedimento para inserir com um único comando os dados
--  de professor e pessoa
DELIMITER $
create procedure proc_novoProfessor(var_nome varchar(100),
                                var_cpf varchar(14) ,
                                var_dt_nascimento datetime,
                                var_sexo integer,
                                var_estado_civil integer,
                                var_nome_mae varchar(100),
                                var_nome_pai varchar(100),
                                var_formacao varchar(45)
)
begin
	declare var_idPessoa integer;
	insert into pessoa(nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
	     values(var_nome, var_cpf, var_dt_nascimento, var_sexo, var_estado_civil, var_nome_mae,var_nome_pai);
	
	select last_insert_id() into var_idPessoa;
	
	insert into professor(id_pessoa, formacao) values(var_idPessoa, var_formacao);	
	
end$
DELIMITER ;

call proc_novoProfessor('Nome Professor Procedimento',
					    '222.111.222-11',
  					    '1980-01-20',
					    0,
					    3,
					    'Mae Professor Procedimento',
					    'Pai Professor Procedimento',
					    'Doutor');
				
select * from pessoa order by id_pessoa desc limit 5;
select * from professor p ; -- 48531			
				
drop procedure proc_novoProfessor;

DELIMITER $
create procedure proc_novoProfessor(var_nome varchar(100),
                                var_cpf varchar(14) ,
                                var_dt_nascimento datetime,
                                var_sexo integer,
                                var_estado_civil integer,
                                var_nome_mae varchar(100),
                                var_nome_pai varchar(100),
                                var_formacao varchar(45)
)
begin
	declare var_idPessoa integer;
	insert into pessoa(nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
	     values(var_nome, var_cpf, var_dt_nascimento, var_sexo, var_estado_civil, var_nome_mae,var_nome_pai);
	
	select last_insert_id() into var_idPessoa;
	
	insert into professor(id_pessoa, formacao) values(var_idPessoa, UPPER(var_formacao));	
	
end$
DELIMITER ;

call proc_novoProfessor('Nome Professor 2 Procedimento',
					    '333.333.222-11',
  					    '1990-01-20',
					    0,
					    1,
					    'Mae Professor 2 Procedimento',
					    'Pai Professor 2 Procedimento',
					    'mestre');
				
select * from pessoa order by id_pessoa desc limit 5;-- 48532
select * from professor p ;
				
	
