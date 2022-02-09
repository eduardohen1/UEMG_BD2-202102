-- Aula 08/02/2022
-- Seguran�a em BD:

-- Criar usu�rio 'novo' para acessar via 'localhost' com a senha '123456'
create user 'novo'@'localhost' identified by '123456';

-- Dar permiss�o completa para o banco de dados 'escola' com todas as tabelas
--  para o usu�rio 'novo'
grant all privileges on escola.* to 'novo'@'localhost';
-- comando que recarrega as permiss�es no sgbd
flush privileges;

-- remover os privil�gios:
revoke all privileges on escola.* from 'novo'@'localhost';
flush privileges;

-- dando privil�gios de acesso � vw_pessoa_aluno_turma para o usu�rio 'novo'
grant all privileges on escola.vw_pessoa_aluno_turma to 'novo'@'localhost';
flush privileges;
-- exibe as permiss�es do usu�rio 'novo':
show grants for 'novo'@'localhost';

revoke all privileges on escola.vw_pessoa_aluno_turma from 'novo'@'localhost';
flush privileges;
show grants for 'novo'@'localhost';

-- conceder acesso SELECT para a tabela 'mensagens':
grant select on escola.mensagens to 'novo'@'localhost';
flush privileges;

revoke all privileges on escola.mensagens from 'novo'@'localhost';
flush privileges;

-- liberar select e insert na tabela mensagens e select na tabela aluno:
grant select on escola.mensagens to 'novo'@'localhost';
grant insert on escola.mensagens to 'novo'@'localhost';
grant select on escola.aluno     to 'novo'@'localhost';
flush privileges;

revoke select on escola.mensagens from 'novo'@'localhost';
revoke insert on escola.mensagens from 'novo'@'localhost';
revoke select on escola.aluno     from 'novo'@'localhost';
flush privileges;

-- permiss�o de leitura e atualiza��o da tabela mensagens para o usu�rio 'novo'
--  e dar permiss�o de leitura para a tabela pessoa:
grant select, update on escola.mensagens to 'novo'@'localhost';
grant select         on escola.pessoa    to 'novo'@'localhost';
flush privileges;

-- liberar geral:
grant all privileges on *.* to 'root'@'%';

-- criar um novo usu�rio com permiss�o externa (fora da m�quina do sgbd):
create user 'novo2'@'%' identified by '123456';
grant select on escola.aluno to 'novo2'@'%';
flush privileges;
show grants for 'novo2'@'%';
show grants for 'novo'@'localhost';

