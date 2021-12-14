-- Aula BD2 14/12/2021
-- Continuação de Stored Procedures:

use escola;
SET GLOBAL log_bin_trust_function_creators = 1;

-- criando o validador de CPF: 012.345.678-90 // 00000000000
drop function func_validacpf; 
DELIMITER $
create function func_validacpf(vrcpf varchar(14))
returns real
begin
	declare contador  int default  1;
	declare contador2 int default 10;
	declare verifica  int default  2;
	declare soma      int default  0;
	declare n1        int default  0;
	declare n2        int default  0;
	declare vrcpf2    varchar(14);
	
	select replace(replace(vrcpf,".",""),"-","") into vrcpf2;
	set vrcpf = vrcpf2;

	while verifica = 2 do
		set contador = contador + 1;
		if substring(vrcpf, 1, 1) != substring(vrcpf, contador, 1) then
			set verifica = 1;
		end if;
		if contador = 11 then
			set verifica = 0;
		end if;
	end while;

	set contador = 0;
	if verifica = 1 then
		while contador < 9 do
			set contador = contador + 1;
			set soma = soma + (substring(vrcpf, contador, 1) * contador2);
			set contador2 = contador2 - 1;
		end while;
		set n1 = 11 - (soma % 11);
		if n1 > 9 then
			set n1 = 0;
		end if;
		set contador  =  1;
		set contador2 = 11;
		set soma      =  0;
		
		while contador < 11 do
			set soma = soma + (substring(vrcpf, contador, 1) * contador2);
			set contador  =  contador + 1;
			set contador2 = contador2 - 1;
		end while;
	
		set n2 = 11 - (soma % 11);
		if n2 > 9 then
			set n2 = 0;
		end if;
		-- 012.345.678-90 
		if n1 = substring(vrcpf, 10, 1) and n2 = substring(vrcpf, 11, 1) then
			set verifica = 1;
		else 
			set verifica = 0;
		end if;
	end if;
	if verifica = 1 then
		return 1;
	else
		return 0;
	end if;
end$
DELIMITER ;

select
	(case when func_validacpf("47002372602") = 1 then
		'CPF Válido'
		else 
		'CPF Inválido!'
	end) validarCpf;

select * from pessoa;
-- -----------------
select 
	count(*) 
from 
	pessoa
where 
	func_validacpf(cpf) = 0;

select * from pessoa 
where cpf in ('   .   .   -11', 
              '_47.924.144-11',
              '_02.628.656-11',
              '_02.278.048-11',
              '_00.049.830-11');

update pessoa set cpf = '777.777.777-88' 
where cpf in ('   .   .   -11', 
              '_47.924.144-11',
              '_02.628.656-11',
              '_02.278.048-11',
              '_00.049.830-11');             
-- -------------
select distinct cpf from pessoa order by cpf desc;


-- replace
select upper("loren");
select upper(replace("São Paulo","ã","a")) cidades;
select "SAO PAULO" cidades;
-- 012.345.678-90

select replace(replace("012.345.678-90",".",""),"-","") cpf;

 -- cnpj: 22.222.333/0001-88
select replace(replace(replace("22.222.333/0001-88",".",""),"-",""),"/","") cnpj;

-- ---------------------------

drop procedure aumentoValor; 
DELIMITER $
create procedure aumentoValor(porcentagem double, inout valor double)
begin
	set valor = valor + (valor * (porcentagem/100));
end$
DELIMITER ;

set @valor = 12;
select @valor;
call aumentoValor(20, @valor); 
select @valor;

set @porcentagem = 22.9;
select @porcentagem;
call aumentoValor(@porcentagem, @valor);
select @valor;
















