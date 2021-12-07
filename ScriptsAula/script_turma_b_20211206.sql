-- Aula dia 06/12/2021
-- CASE WHEN THEN ELSE

-- utilizar o CASE como IF THEN ELSE
select (
	case when 2 = 1 then
		'Verdadeiro'
	else 
		'Falso'
	end
);

select (
	case when (10 * 2) >= 30 then
		concat('Sim! ',(10 * 2), ' é maior que 30')
	else
		concat('Não! ',(10 * 2), ' é menor que 30')
	end
);

select * from aluno;
select (
	case when (select count(*) from aluno) < 10 then
		'Sim, temos menos de 10 alunos :\'(!'
	else
		'Não!!! Temos mais de 10 alunos!!! \\o/'
	end
);

-- utilizar como SWITCH CASE!
select distinct estado_civil from pessoa;

select 
	*,
	(
		case estado_civil 
			when 0 then 'SOLTEIRO'
			when 1 then 'CASADO'
			when 2 then 'DISQUITADO'
			when 3 then 'DIVORCIADO'
			else '-'
		end
	) estadoCivil,
	(
		case sexo
			when 0 then 'F'
			when 1 then 'M'
		end
	) sexoTxt
from pessoa limit 10;

-- ------------------
select 
	*,
	(
		case estado_civil 
			when 0 then 
				(case when sexo = 0 then 'SOLTEIRA'   else 'SOLTEIRO'   end)
			when 1 then 
				(case when sexo = 0 then 'CASADA'     else 'CASADO'     end)
			when 2 then 
				(case when sexo = 0 then 'DISQUITADA' else 'DISQUITADO' end)
			when 3 then 
				(case when sexo = 0 then 'DIVORCIADA' else 'DIVORCIADO' end)
			else '-'
		end
	) estadoCivil,
	(
		case sexo
			when 0 then 'F'
			when 1 then 'M'
		end
	) sexoTxt
from pessoa limit 10;

-- -------------------------------
-- STORED PROCEDURES:

set global log_bin_trust_function_creators = 1;

select * from pessoa;

DELIMITER $
create function func_idade(dtNascimento DATETIME)
returns INTEGER
begin
	return timestampdiff(year, dtNascimento, now());
end$
DELIMITER ;

select func_idade('1990-08-07');
select func_idade('2000-12-06');
select * from pessoa limit 5;
select *, func_idade(dt_nascimento) idade from pessoa limit 5;

-- função de retorno se a nota está acima ou abaixo da média:
DELIMITER $
create function func_media(notaAluno INTEGER, notaAvaliacao INTEGER)
returns INTEGER
begin
	declare media real default 0.6;
	declare calculo real;
	-- 15 > (30 * 0.6)
	set calculo = notaAvaliacao * media;	
	if notaAluno > calculo then
		return 0;
	else
		return 1;
	end if;
end$
DELIMITER ;

select func_media(19,30);

-- ---------------------------
select 
	avt.*, av.valor, av.descricao,
	func_media(avt.nota, av.valor) media
from 
	avaliacaoturma avt 
		inner join avaliacao av on avt.id_avaliacao  = av.id_avaliacao;

-- ----------------
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



