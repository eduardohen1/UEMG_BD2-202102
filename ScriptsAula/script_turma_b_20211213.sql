-- Aula 13/12/2021
-- Continuação de Stored Procedures:

use escola;
SET GLOBAL log_bin_trust_function_creators = 1;

create table mediageral(id_media integer auto_increment not null,
					    media real not null default 0,
					    primary key(id_media)
);

select * from mediageral m ;
insert into mediageral (media) values(60);
drop function func_media; -- excluir função
select media from mediageral where id_media = 1;

DELIMITER $
create function func_media(notaAluno INTEGER, notaAvaliacao INTEGER)
returns INTEGER
begin
	declare vrmedia real;
	declare calculo real;
	
	-- buscar o valor da média na tabela mediageral:
	select media into vrmedia from mediageral where id_media = 1;

	set calculo = notaAvaliacao * (vrmedia / 100);	
	if notaAluno > calculo then
		return 0;
	else
		return 1;
	end if;
end$
DELIMITER ;

select func_media(20,30);

select 
	avt.*, av.valor, av.descricao,
	(
		case func_media(avt.nota, av.valor)
			when 0 then 'Nota acima da média!'
			when 1 then 'Nota abaixo da média!'
		end
	) media
from 
	avaliacaoturma avt 
		inner join avaliacao av on avt.id_avaliacao  = av.id_avaliacao;

-- modificamos de 60% para 70%
update mediageral set media = 70 where id_media = 1;

select 
	avt.*, av.valor, av.descricao,
	(
		case func_media(avt.nota, av.valor)
			when 0 then 'Nota acima da média!'
			when 1 then 'Nota abaixo da média!'
		end
	) media
from 
	avaliacaoturma avt 
		inner join avaliacao av on avt.id_avaliacao  = av.id_avaliacao;

-- ----------------------------
-- Procedures:
-- Procedimento para retornar uma lista de pessoas pelo parametro de sexo:
select * from pessoa;
DELIMITER $
create procedure proc_listaPessoasSexo(sexoParam VARCHAR(1))
begin
	if sexoParam = "M" then
		select * from pessoa where sexo = 1;
	elseif sexoParam = "F" then
		select * from pessoa where sexo = 0;
	else
		select * from pessoa where sexo not in (0,1);
	end if;
end$
DELIMITER ;

call proc_listaPessoasSexo("F");
call proc_listaPessoasSexo("M");
call proc_listaPessoasSexo("X");
	
-- Criar um procedimento para inserir com um único comando
--  os dados de pessoa e aluno:
DELIMITER $
create procedure proc_novoaluno(
					vrnome varchar(100),
					vrcpf varchar(14),
					vrdt_nascimento datetime,
					vrsexo integer,
					vrestado_civil integer,
					vrnome_mae varchar(100),
					vrnome_pai varchar(100),
					vrdt_cadastro datetime
)
begin
	declare vridpessoa integer;
	
	insert into pessoa(nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
	   values(vrnome, vrcpf, vrdt_nascimento, vrsexo, vrestado_civil, vrnome_mae, vrnome_pai);
	
	select last_insert_id() into vridpessoa;
	
	insert into aluno(dt_cadastro, id_pessoa) values(vrdt_cadastro, vridpessoa);

end$
DELIMITER ;

select * from aluno;

call proc_novoaluno(
				'Nome Aluno Procedure',
				'222.222.222-22',
				'1998-10-11',
				1,
				0,
				'Nome Mae Procedure',
				'Nome Pai Procedure',
				now());
select * from pessoa where id_pessoa  = 48529;

call proc_novoaluno(
				'Nome Aluno 2 Procedure',
				'222.222.222-22',
				'1995-10-11',
				0,
				3,
				'Nome Mae 2 Procedure',
				'Nome Pai 2 Procedure',
				'2021-12-02');
select * from aluno;


-- Criar um procedimento para inserir com um único comando
--  os dados de pessoa e professor:
DELIMITER $
create procedure proc_novoprofessor(
					vrnome varchar(100),
					vrcpf varchar(14),
					vrdt_nascimento datetime,
					vrsexo integer,
					vrestado_civil integer,
					vrnome_mae varchar(100),
					vrnome_pai varchar(100),
					vrformacao varchar(45)
)
begin
	declare vridpessoa integer;
	
	insert into pessoa(nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
	   values(vrnome, vrcpf, vrdt_nascimento, vrsexo, vrestado_civil, vrnome_mae, vrnome_pai);
	
	select last_insert_id() into vridpessoa;
	
	insert into professor(formacao, id_pessoa) values(vrformacao, vridpessoa);

end$
DELIMITER ;
		
call proc_novoprofessor(
				'Nome do Professor',
				'222.222.223-23',
				'1980-10-11',
				0,
				3,
				'Nome Mae Prof',
				'Nome Pai Prof',
				'Mestre');
select * from professor;

drop procedure proc_novoprofessor;

DELIMITER $
create procedure proc_novoprofessor(
					vrnome varchar(100),
					vrcpf varchar(14),
					vrdt_nascimento datetime,
					vrsexo integer,
					vrestado_civil integer,
					vrnome_mae varchar(100),
					vrnome_pai varchar(100),
					vrformacao varchar(45)
)
begin
	declare vridpessoa integer;
	
	insert into pessoa(nome, cpf, dt_nascimento, sexo, estado_civil, nome_mae, nome_pai)
	   values(vrnome, vrcpf, vrdt_nascimento, vrsexo, vrestado_civil, vrnome_mae, vrnome_pai);
	
	select last_insert_id() into vridpessoa;
	
	insert into professor(formacao, id_pessoa) values(UPPER(vrformacao), vridpessoa);

end$
DELIMITER ;

call proc_novoprofessor(
				'Nome do Professor 2',
				'222.222.223-23',
				'1985-10-11',
				1,
				2,
				'Nome Mae 2 Prof',
				'Nome Pai 2 Prof',
				'doutor');
select * from professor;
				
			
			