-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: escola
-- ------------------------------------------------------
-- Server version	8.0.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `aluno`
--

DROP TABLE IF EXISTS `aluno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aluno` (
  `id_aluno` int NOT NULL AUTO_INCREMENT,
  `dt_cadastro` datetime NOT NULL,
  `id_pessoa` int NOT NULL,
  PRIMARY KEY (`id_aluno`),
  KEY `fk_aluno_pessoa_idx` (`id_pessoa`),
  CONSTRAINT `fk_aluno_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aluno`
--

LOCK TABLES `aluno` WRITE;
/*!40000 ALTER TABLE `aluno` DISABLE KEYS */;
/*!40000 ALTER TABLE `aluno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alunoturma`
--

DROP TABLE IF EXISTS `alunoturma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alunoturma` (
  `id_aluno` int NOT NULL,
  `id_turma` int NOT NULL,
  `dt_matricula` datetime NOT NULL,
  `dt_cancelamento` datetime NOT NULL,
  PRIMARY KEY (`id_aluno`,`id_turma`),
  KEY `fk_turma_idx` (`id_turma`),
  KEY `fk_aluno_idx` (`id_aluno`),
  CONSTRAINT `fk_aluno` FOREIGN KEY (`id_aluno`) REFERENCES `aluno` (`id_aluno`),
  CONSTRAINT `fk_turma` FOREIGN KEY (`id_turma`) REFERENCES `turma` (`id_turma`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alunoturma`
--

LOCK TABLES `alunoturma` WRITE;
/*!40000 ALTER TABLE `alunoturma` DISABLE KEYS */;
/*!40000 ALTER TABLE `alunoturma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `avaliacao`
--

DROP TABLE IF EXISTS `avaliacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avaliacao` (
  `id_avaliacao` int NOT NULL,
  `descricacao` varchar(45) NOT NULL,
  `valor` double NOT NULL,
  `observacao` text,
  PRIMARY KEY (`id_avaliacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avaliacao`
--

LOCK TABLES `avaliacao` WRITE;
/*!40000 ALTER TABLE `avaliacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `avaliacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `avaliacaoturma`
--

DROP TABLE IF EXISTS `avaliacaoturma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avaliacaoturma` (
  `id_avaliacao` int NOT NULL,
  `id_aluno` int NOT NULL,
  `id_turma` int NOT NULL,
  `id_disciplina` int NOT NULL,
  `dt_avalicacao` datetime NOT NULL,
  `nota` double NOT NULL,
  PRIMARY KEY (`id_avaliacao`),
  KEY `fk_aluno_idx` (`id_aluno`,`id_turma`),
  KEY `fk_disciplina_idx` (`id_disciplina`),
  KEY `fk_avaliacao` (`id_avaliacao`),
  CONSTRAINT `fk_aluno_turma` FOREIGN KEY (`id_aluno`, `id_turma`) REFERENCES `alunoturma` (`id_aluno`, `id_turma`),
  CONSTRAINT `fk_avaliacao` FOREIGN KEY (`id_avaliacao`) REFERENCES `avaliacao` (`id_avaliacao`),
  CONSTRAINT `fk_disciplina` FOREIGN KEY (`id_disciplina`) REFERENCES `disciplina` (`id_disciplina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avaliacaoturma`
--

LOCK TABLES `avaliacaoturma` WRITE;
/*!40000 ALTER TABLE `avaliacaoturma` DISABLE KEYS */;
/*!40000 ALTER TABLE `avaliacaoturma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curso`
--

DROP TABLE IF EXISTS `curso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curso` (
  `id_curso` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_curso`),
  CONSTRAINT `fk_turma_curso` FOREIGN KEY (`id_curso`) REFERENCES `turma` (`id_turma`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curso`
--

LOCK TABLES `curso` WRITE;
/*!40000 ALTER TABLE `curso` DISABLE KEYS */;
/*!40000 ALTER TABLE `curso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disciplina`
--

DROP TABLE IF EXISTS `disciplina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disciplina` (
  `id_disciplina` int NOT NULL,
  `nome` varchar(45) NOT NULL,
  `numero` int NOT NULL,
  `creditos` int NOT NULL,
  PRIMARY KEY (`id_disciplina`),
  KEY `idx_nome` (`nome`),
  KEY `idx_numero` (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disciplina`
--

LOCK TABLES `disciplina` WRITE;
/*!40000 ALTER TABLE `disciplina` DISABLE KEYS */;
/*!40000 ALTER TABLE `disciplina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `frequencia`
--

DROP TABLE IF EXISTS `frequencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `frequencia` (
  `id_aluno` int NOT NULL,
  `id_turma` int NOT NULL,
  `id_disciplina` int NOT NULL,
  `dt_frequencia` datetime NOT NULL,
  `frequencia` int NOT NULL DEFAULT '0' COMMENT '0 - presente\n1 - ausente',
  PRIMARY KEY (`id_aluno`,`id_turma`,`id_disciplina`,`dt_frequencia`),
  KEY `fk_disciplina_idx` (`id_disciplina`),
  KEY `fk_turna_idx` (`id_turma`),
  KEY `fk_aluno_idx` (`id_aluno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `frequencia`
--

LOCK TABLES `frequencia` WRITE;
/*!40000 ALTER TABLE `frequencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `frequencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pessoa`
--

DROP TABLE IF EXISTS `pessoa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pessoa` (
  `id_pessoa` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cpf` varchar(14) NOT NULL COMMENT 'Gravar com m??scara (000.000.000-00)',
  `dt_nascimento` datetime NOT NULL,
  `sexo` int NOT NULL,
  `estado_civil` int NOT NULL,
  `nome_mae` varchar(100) NOT NULL,
  `nome_pai` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_pessoa`),
  KEY `idx_cpf` (`cpf`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pessoa`
--

LOCK TABLES `pessoa` WRITE;
/*!40000 ALTER TABLE `pessoa` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prof_turm_disc`
--

DROP TABLE IF EXISTS `prof_turm_disc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prof_turm_disc` (
  `id_professor` int NOT NULL,
  `id_turma` int NOT NULL,
  `id_disciplina` int NOT NULL,
  PRIMARY KEY (`id_professor`,`id_turma`,`id_disciplina`),
  KEY `fk_turma_PTD_idx` (`id_turma`),
  KEY `fk_disciplina_PTD_idx` (`id_disciplina`),
  KEY `fk_professor_PTD_idx` (`id_professor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prof_turm_disc`
--

LOCK TABLES `prof_turm_disc` WRITE;
/*!40000 ALTER TABLE `prof_turm_disc` DISABLE KEYS */;
/*!40000 ALTER TABLE `prof_turm_disc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `professor`
--

DROP TABLE IF EXISTS `professor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `professor` (
  `id_professor` int NOT NULL AUTO_INCREMENT,
  `formacao` varchar(45) NOT NULL,
  `id_pessoa` int NOT NULL,
  PRIMARY KEY (`id_professor`),
  KEY `fk_professor_pessoa_idx` (`id_pessoa`),
  CONSTRAINT `fk_professor_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `professor`
--

LOCK TABLES `professor` WRITE;
/*!40000 ALTER TABLE `professor` DISABLE KEYS */;
/*!40000 ALTER TABLE `professor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `turma`
--

DROP TABLE IF EXISTS `turma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `turma` (
  `id_turma` int NOT NULL AUTO_INCREMENT,
  `dt_incial` datetime NOT NULL,
  `dt_final` datetime NOT NULL,
  `ano` int NOT NULL,
  `periodo` int NOT NULL,
  `descricao` varchar(50) NOT NULL,
  `id_curso` int NOT NULL,
  PRIMARY KEY (`id_turma`),
  KEY `idx_turma` (`descricao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turma`
--

LOCK TABLES `turma` WRITE;
/*!40000 ALTER TABLE `turma` DISABLE KEYS */;
/*!40000 ALTER TABLE `turma` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-04 22:19:59
