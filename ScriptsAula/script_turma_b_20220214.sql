-- Aula 14/02/2022:
-- Segurança em BD:

use escola;

-- Criar o usuário 'novouser' para acessar via 'localhost' com a senha '123456'
create user 'novouser'@'localhost' identified by '123456';

-- Dar permissão 'completa' para o banco de dados 'escola' com todas as tabelas
--  para o usuário 'novouser':
grant all privileges on escola.* to 'novouser'@'localhost';
-- comando que recarrega as permissões no SGBD:
flush privileges;

-- remover os privilégios:
revoke all privileges on escola.* from 'novouser'@'localhost';
flush privileges;

select * from vw_pessoa_aluno_turma;

-- dando privilégios de acesso à vw_pessoa_aluno_turma para o usuário 'novouser':
grant all privileges on escola.vw_pessoa_aluno_turma to 'novouser'@'localhost';
flush privileges;
-- exibe as permissões do usuário 'novouser':
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

-- liberar acesso à SELECT e INSERT na tabela mensagens e SELECT na tabela aluno:
grant select on escola.mensagens to 'novouser'@'localhost';
grant insert on escola.mensagens to 'novouser'@'localhost';
grant select on escola.aluno     to 'novouser'@'localhost';
flush privileges;

revoke select on escola.mensagens from 'novouser'@'localhost';
revoke insert on escola.mensagens from 'novouser'@'localhost';
revoke select on escola.aluno     from 'novouser'@'localhost';
flush privileges;

-- permissão de leitura e atualização da tabela mensagens para o usuário
--  'novouser' e dar permissão de leitura para a tabela pessoa:
grant select, update on escola.mensagens to 'novouser'@'localhost';
grant select         on escola.pessoa    to 'novouser'@'localhost';
flush privileges;
show grants for 'novouser'@'localhost';

-- revogar permissão de update da tabela mensagens para o usuário 'novouser':
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
