-- Aula 14/02/2022:
-- Seguran�a em BD:

use escola;

-- Criar o usu�rio 'novouser' para acessar via 'localhost' com a senha '123456'
create user 'novouser'@'localhost' identified by '123456';

-- Dar permiss�o 'completa' para o banco de dados 'escola' com todas as tabelas
--  para o usu�rio 'novouser':
grant all privileges on escola.* to 'novouser'@'localhost';
-- comando que recarrega as permiss�es no SGBD:
flush privileges;

-- remover os privil�gios:
revoke all privileges on escola.* from 'novouser'@'localhost';
flush privileges;

select * from vw_pessoa_aluno_turma;

-- dando privil�gios de acesso � vw_pessoa_aluno_turma para o usu�rio 'novouser':
grant all privileges on escola.vw_pessoa_aluno_turma to 'novouser'@'localhost';
flush privileges;
-- exibe as permiss�es do usu�rio 'novouser':
show grants for 'novouser'@'localhost';

revoke all privileges on escola.vw_pessoa_aluno_turma from 'novouser'@'localhost';
flush privileges;
show grants for 'novouser'@'localhost';

-- conceder acesso SELECT para a tabela 'mensagens':
grant select on escola.mensagens to 'novouser'@'localhost';
flush privileges;

revoke all privileges on escola.mensagens  from 'novouser'@'localhost';
flush privileges;
show grants for 'novouser'@'localhost';

-- liberar acesso � SELECT e INSERT na tabela mensagens e SELECT na tabela aluno:
grant select on escola.mensagens to 'novouser'@'localhost';
grant insert on escola.mensagens to 'novouser'@'localhost';
grant select on escola.aluno     to 'novouser'@'localhost';
flush privileges;

revoke select on escola.mensagens from 'novouser'@'localhost';
revoke insert on escola.mensagens from 'novouser'@'localhost';
revoke select on escola.aluno     from 'novouser'@'localhost';
flush privileges;

-- permiss�o de leitura e atualiza��o da tabela mensagens para o usu�rio
--  'novouser' e dar permiss�o de leitura para a tabela pessoa:
grant select, update on escola.mensagens to 'novouser'@'localhost';
grant select         on escola.pessoa    to 'novouser'@'localhost';
flush privileges;
show grants for 'novouser'@'localhost';

-- revogar permiss�o de update da tabela mensagens para o usu�rio 'novouser':
revoke update on escola.mensagens from 'novouser'@'localhost';
flush privileges;
show grants for 'novouser'@'localhost';

-- liberar geral o BD escola para acesso local e Remoto!
create user 'novouser2'@'%' identified by '123456';
grant select on escola.aluno               to 'novouser2'@'%';
grant select on escola.vw_media_avaliacoes to 'novouser2'@'%';
flush privileges;
show grants for 'novouser2'@'%';


-- --------------------------
txt_id = "123"
txt_senha = "1' or '1' = '1"
select * from usuario where id = 'txt_id' and senha = 'txt_senha';

select * from usuario where id = 1 and senha = '1' or '1' = '1';
