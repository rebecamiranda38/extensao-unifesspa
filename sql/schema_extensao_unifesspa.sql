DROP DATABASE IF EXISTS `extensao_unifesspa`;
CREATE DATABASE IF NOT EXISTS `extensao_unifesspa`;
USE `extensao_unifesspa`;


CREATE TABLE `modalidade_extensao` (
  `id_modalidade` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(80) NOT NULL,
  `descricao` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`id_modalidade`),
  UNIQUE KEY `uq_modalidade_nome` (`nome`)
) ENGINE=InnoDB;

CREATE TABLE `acao_extensao` (
  `id_acao` INT NOT NULL AUTO_INCREMENT,
  `id_modalidade` INT NOT NULL,
  `tipo_acao` VARCHAR(45) NOT NULL,
  `titulo` VARCHAR(200) NOT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `data_inicio` DATE NOT NULL,
  `data_fim` DATE NULL DEFAULT NULL,
  `carga_horaria_total` INT NOT NULL,
  `interna` INT NOT NULL DEFAULT '1',
  `status_Aprocacao` ENUM('EM_APROVACAO', 'ATIVA', 'ENCERRADA', 'CANCELADA') NOT NULL DEFAULT 'EM_APROVACAO',
  PRIMARY KEY (`id_acao`),
  KEY `fk_acao_modalidade` (`id_modalidade`),
  CONSTRAINT `fk_acao_modalidade` FOREIGN KEY (`id_modalidade`) REFERENCES `modalidade_extensao` (`id_modalidade`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `instituicao_parceira` (
  `id_instituicao` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(200) NOT NULL,
  `cnpj` CHAR(14) NULL DEFAULT NULL,
  `tipo` VARCHAR(80) NULL DEFAULT NULL,
  `endereco` VARCHAR(255) NULL DEFAULT NULL,
  `contato` VARCHAR(150) NULL DEFAULT NULL,
  PRIMARY KEY (`id_instituicao`),
  UNIQUE KEY `uq_inst_cnpj` (`cnpj`)
) ENGINE=InnoDB;

CREATE TABLE `acao_instituicao` (
  `id_acao` INT NOT NULL,
  `id_instituicao` INT NOT NULL,
  `papel` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id_acao`, `id_instituicao`),
  KEY `fk_ai_instituicao` (`id_instituicao`),
  CONSTRAINT `fk_ai_acao` FOREIGN KEY (`id_acao`) REFERENCES `acao_extensao` (`id_acao`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_instituicao` FOREIGN KEY (`id_instituicao`) REFERENCES `instituicao_parceira` (`id_instituicao`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `pessoa` (
  `id_pessoa` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `cpf` CHAR(11) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `telefone` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id_pessoa`),
  UNIQUE KEY `uq_pessoa_cpf` (`cpf`),
  UNIQUE KEY `uq_pessoa_email` (`email`)
) ENGINE=InnoDB;

CREATE TABLE `participacao_pessoa` (
  `id_coordenacao` INT NOT NULL AUTO_INCREMENT,
  `id_acao` INT NOT NULL,
  `id_pessoa` INT NOT NULL,
  `papel` ENUM('COORDENADOR', 'VICE_COORDENADOR') NOT NULL DEFAULT 'COORDENADOR',
  `carga_horaria_semanal` DECIMAL(4,1) NOT NULL,
  `data_inicio` DATE NOT NULL,
  `data_fim` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id_coordenacao`),
  KEY `fk_coord_atividade` (`id_acao`),
  KEY `fk_coord_pessoa` (`id_pessoa`),
  CONSTRAINT `fk_coord_atividade` FOREIGN KEY (`id_acao`) REFERENCES `acao_extensao` (`id_acao`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_coord_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `discente` (
  `id_discente` INT NOT NULL AUTO_INCREMENT,
  `id_pessoa` INT NOT NULL,
  `matricula` VARCHAR(20) NOT NULL,
  `semestre_ingresso` INT NOT NULL,
  `carga_horaria_acumulada` DECIMAL(7,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_discente`),
  UNIQUE KEY `uq_discente_matricula` (`matricula`),
  KEY `fk_discente_pessoa1_idx` (`id_pessoa`),
  CONSTRAINT `fk_discente_pessoa1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `Coordenador` (
  `id_Coordenador` INT NOT NULL AUTO_INCREMENT,
  `id_pessoa` INT NOT NULL,
  `siape` VARCHAR(20) NOT NULL,
  `cargo` VARCHAR(100) NOT NULL,
  `departamento` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id_Coordenador`),
  UNIQUE KEY `uq_docente_siape` (`siape`),
  KEY `fk_Coordenador_pessoa1_idx` (`id_pessoa`),
  CONSTRAINT `fk_Coordenador_pessoa1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `participacao` (
  `id_participacao` INT NOT NULL AUTO_INCREMENT,
  `id_discente` INT NOT NULL,
  `id_acao` INT NOT NULL,
  `data_entrada` DATE NOT NULL,
  `data_saida` DATE NULL DEFAULT NULL,
  `horas_realizadas` DECIMAL(7,2) NOT NULL DEFAULT '0.00',
  `funcao` VARCHAR(100) NULL DEFAULT NULL,
  `status` ENUM('em_andamento', 'concluida', 'cancelada') NOT NULL DEFAULT 'em_andamento',
  PRIMARY KEY (`id_participacao`),
  UNIQUE KEY `uq_participacao` (`id_discente`, `id_acao`),
  KEY `fk_part_acao` (`id_acao`),
  CONSTRAINT `fk_part_acao` FOREIGN KEY (`id_acao`) REFERENCES `acao_extensao` (`id_acao`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_part_discente` FOREIGN KEY (`id_discente`) REFERENCES `discente` (`id_discente`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `validacao` (
  `id_validacao` INT NOT NULL AUTO_INCREMENT,
  `id_participacao` INT NOT NULL,
  `id_validador` INT NOT NULL,
  `data_validacao` DATE NOT NULL,
  `horas_validadas` DECIMAL(6,2) NOT NULL,
  `status` ENUM('aprovado', 'reprovado') NOT NULL,
  `observacao` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`id_validacao`),
  UNIQUE KEY `uq_validacao_participacao` (`id_participacao`),
  KEY `fk_val_validador` (`id_validador`),
  CONSTRAINT `fk_val_participacao` FOREIGN KEY (`id_participacao`) REFERENCES `participacao` (`id_participacao`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_val_validador` FOREIGN KEY (`id_validador`) REFERENCES `Coordenador` (`id_Coordenador`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `documento` (
  `id_documento` INT NOT NULL AUTO_INCREMENT,
  `id_participacao` INT NOT NULL,
  `tipo` VARCHAR(80) NOT NULL,
  `arquivo_path` VARCHAR(300) NULL DEFAULT NULL,
  `data_envio` DATE NOT NULL,
  `status_validacao` ENUM('pendente', 'aprovado', 'reprovado') NOT NULL DEFAULT 'pendente',
  `validacao_id_validacao` INT NOT NULL,
  PRIMARY KEY (`id_documento`),
  KEY `fk_doc_participacao` (`id_participacao`),
  KEY `fk_documento_validacao1_idx` (`validacao_id_validacao`),
  CONSTRAINT `fk_doc_participacao` FOREIGN KEY (`id_participacao`) REFERENCES `participacao` (`id_participacao`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_documento_validacao1` FOREIGN KEY (`validacao_id_validacao`) REFERENCES `validacao` (`id_validacao`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `matricula` (
  `id_matricula` INT NOT NULL AUTO_INCREMENT,
  `id_discente` INT NOT NULL,
  `semestre` INT NOT NULL,
  `ano` INT NOT NULL,
  `status` ENUM('ativa', 'trancada', 'concluida') NOT NULL DEFAULT 'ativa',
  PRIMARY KEY (`id_matricula`),
  UNIQUE KEY `uq_matricula_discente_periodo` (`id_discente`, `ano`, `semestre`),
  CONSTRAINT `fk_matricula_discente` FOREIGN KEY (`id_discente`) REFERENCES `discente` (`id_discente`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE `plano_trabalho` (
  `id_plano` INT NOT NULL AUTO_INCREMENT,
  `id_participacao` INT NOT NULL,
  `carga_horaria_semanal` DECIMAL(4,1) NOT NULL,
  `descricao_atividades` TEXT NOT NULL,
  `data_submissao` DATE NOT NULL,
  `data_aprovacao` DATE NULL DEFAULT NULL,
  `aprovado` ENUM('sim', 'nao', 'pendente') NOT NULL DEFAULT 'pendente',
  `observacao` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`id_plano`),
  UNIQUE KEY `uq_plano_participacao` (`id_participacao`),
  CONSTRAINT `fk_plano_participacao` FOREIGN KEY (`id_participacao`) REFERENCES `participacao` (`id_participacao`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

