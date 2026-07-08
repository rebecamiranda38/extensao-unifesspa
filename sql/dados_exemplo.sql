-- Inserts de exemplo

SET SQL_SAFE_UPDATES = 0;
USE `extensao_unifesspa`;

INSERT INTO modalidade_extensao (nome, descricao) VALUES
('Programa', 'Conjunto articulado de projetos'),
('Projeto', 'Ação processual e contínua'),
('Curso', 'Ação pedagógica de caráter teórico/prático'),
('Oficina', 'Ação prática de curta duração'),
('Evento', 'Ação de curta duração: seminário, congresso, etc.');

INSERT INTO pessoa (nome, cpf, email, telefone) VALUES
('Pedro Henrique Romao',   '11111111111', 'pedro.romao@unifesspa.edu.br',   '94991985643'),
('Rafael Henrique Sena', '22222222222', 'rafael.sena@unifesspa.edu.br',  '94997431624'),
('Rebeca Miranda Reis',  '33333333333', 'rebeca.reis@unifesspa.edu.br', '94990483124'),
('Samilly Emanuelly Rodrigues', '44444444444', 'samilly.rodrigues@unifesspa.edu.br',   '94994230646'),
('Anna Necy', '55555555555', 'anna.necy@unifesspa.edu.br', '94996419012'),
('Hugo Kuribayashi',    '66666666666', 'hugo.kuribayashi@unifesspa.edu.br', '94995412098'),
('Marina de Fatima', '77777777777', 'marina.fatima@unifesspa.edu.br','94996209645'),
('Enzo Gabriel Moura','88888888888', 'enzo.moura@unifesspa.edu.br', '94993728097');

INSERT INTO discente (id_pessoa, matricula, semestre_ingresso, carga_horaria_acumulada) VALUES
((SELECT id_pessoa FROM pessoa WHERE cpf='11111111111'), '2022001234', 1, 0),
((SELECT id_pessoa FROM pessoa WHERE cpf='22222222222'), '2022001235', 1, 0),
((SELECT id_pessoa FROM pessoa WHERE cpf='33333333333'), '2023000111', 1, 0),
((SELECT id_pessoa FROM pessoa WHERE cpf='44444444444'), '2023000112', 2, 0),
((SELECT id_pessoa FROM pessoa WHERE cpf='55555555555'), '2021005566', 1, 0);

INSERT INTO Coordenador (id_pessoa, siape, cargo, departamento) VALUES
((SELECT id_pessoa FROM pessoa WHERE cpf='66666666666'), 'SIAPE1001', 'Professor Adjunto', 'Faculdade de Sistemas de Informação'),
((SELECT id_pessoa FROM pessoa WHERE cpf='77777777777'), 'SIAPE1002', 'Professora Associada', 'Faculdade de Sistemas de Informação'),
((SELECT id_pessoa FROM pessoa WHERE cpf='88888888888'), 'SIAPE1003', 'Técnico em TI', 'Núcleo de Extensão');

INSERT INTO instituicao_parceira (nome, cnpj, tipo, endereco, contato) VALUES
('Prefeitura Municipal de Marabá', '04567890000111', 'Pública', 'Marabá - PA', 'contato@maraba.pa.gov.br'),
('Focinhos Carentes', '09876543000122', 'Privada sem fins lucrativos', 'Marabá - PA', 'contato@focinhoscarentes.org'),
('Intercomm', '12345678000199', 'Privada', 'Marabá - PA', 'contato@intercomm.com.br');

INSERT INTO acao_extensao (id_modalidade, tipo_acao, titulo, descricao, data_inicio, data_fim, carga_horaria_total, interna, status_Aprocacao) VALUES
((SELECT id_modalidade FROM modalidade_extensao WHERE nome='Projeto'), 'Extensão', 'Inclusão Digital na Comunidade', 'Capacitação em informática básica para a comunidade local', '2025-03-01', '2025-12-15', 120, 0, 'ATIVA'),
((SELECT id_modalidade FROM modalidade_extensao WHERE nome='Curso'),   'Extensão', 'Programação para Iniciantes', 'Curso introdutório de lógica de programação', '2025-04-10', '2025-07-10', 60, 1, 'ENCERRADA'),
((SELECT id_modalidade FROM modalidade_extensao WHERE nome='Oficina'), 'Extensão', 'Oficina de Segurança da Informação', 'Boas práticas de segurança digital para gestores públicos', '2025-08-01', '2025-08-30', 20, 0, 'ATIVA'),
((SELECT id_modalidade FROM modalidade_extensao WHERE nome='Evento'),  'Extensão', 'Semana de Tecnologia Unifesspa', 'Evento anual com palestras e minicursos', '2025-09-15', '2025-09-19', 40, 1, 'EM_APROVACAO'),
((SELECT id_modalidade FROM modalidade_extensao WHERE nome='Programa'),'Extensão', 'Programa de Apoio Tecnológico a ONGs', 'Suporte técnico continuado a organizações sociais', '2025-01-15', NULL, 200, 0, 'ATIVA');

INSERT INTO acao_instituicao (id_acao, id_instituicao, papel) VALUES
((SELECT id_acao FROM acao_extensao WHERE titulo='Inclusão Digital na Comunidade'), (SELECT id_instituicao FROM instituicao_parceira WHERE nome='Prefeitura Municipal de Marabá'), 'Apoio logístico'),
((SELECT id_acao FROM acao_extensao WHERE titulo='Oficina de Segurança da Informação'), (SELECT id_instituicao FROM instituicao_parceira WHERE nome='Prefeitura Municipal de Marabá'), 'Público-alvo'),
((SELECT id_acao FROM acao_extensao WHERE titulo='Programa de Apoio Tecnológico a ONGs'), (SELECT id_instituicao FROM instituicao_parceira WHERE nome='Focinhos Carentes'), 'Parceira beneficiária'),
((SELECT id_acao FROM acao_extensao WHERE titulo='Semana de Tecnologia Unifesspa'), (SELECT id_instituicao FROM instituicao_parceira WHERE nome='Intercomm'), 'Patrocinadora');

INSERT INTO participacao_pessoa (id_acao, id_pessoa, papel, carga_horaria_semanal, data_inicio, data_fim) VALUES
((SELECT id_acao FROM acao_extensao WHERE titulo='Inclusão Digital na Comunidade'), (SELECT id_pessoa FROM pessoa WHERE cpf='66666666666'), 'COORDENADOR', 8.0, '2025-03-01', NULL),
((SELECT id_acao FROM acao_extensao WHERE titulo='Programação para Iniciantes'), (SELECT id_pessoa FROM pessoa WHERE cpf='66666666666'), 'COORDENADOR', 6.0, '2025-04-10', '2025-07-10'),
((SELECT id_acao FROM acao_extensao WHERE titulo='Oficina de Segurança da Informação'), (SELECT id_pessoa FROM pessoa WHERE cpf='77777777777'), 'COORDENADOR', 4.0, '2025-08-01', NULL),
((SELECT id_acao FROM acao_extensao WHERE titulo='Semana de Tecnologia Unifesspa'), (SELECT id_pessoa FROM pessoa WHERE cpf='77777777777'), 'COORDENADOR', 10.0, '2025-09-15', NULL),
((SELECT id_acao FROM acao_extensao WHERE titulo='Programa de Apoio Tecnológico a ONGs'), (SELECT id_pessoa FROM pessoa WHERE cpf='66666666666'), 'VICE_COORDENADOR', 5.0, '2025-01-15', NULL);

INSERT INTO matricula (id_discente, semestre, ano, status) VALUES
((SELECT id_discente FROM discente WHERE matricula='2022001234'), 1, 2025, 'ativa'),
((SELECT id_discente FROM discente WHERE matricula='2022001235'), 1, 2025, 'ativa'),
((SELECT id_discente FROM discente WHERE matricula='2023000111'), 1, 2025, 'ativa'),
((SELECT id_discente FROM discente WHERE matricula='2023000112'), 1, 2025, 'trancada'),
((SELECT id_discente FROM discente WHERE matricula='2021005566'), 1, 2025, 'concluida');

INSERT INTO participacao (id_discente, id_acao, data_entrada, data_saida, horas_realizadas, funcao, status) VALUES
((SELECT id_discente FROM discente WHERE matricula='2022001234'), (SELECT id_acao FROM acao_extensao WHERE titulo='Inclusão Digital na Comunidade'), '2025-03-05', NULL, 40.0, 'Monitor', 'em_andamento'),
((SELECT id_discente FROM discente WHERE matricula='2022001235'), (SELECT id_acao FROM acao_extensao WHERE titulo='Inclusão Digital na Comunidade'), '2025-03-05', NULL, 35.5, 'Monitor', 'em_andamento'),
((SELECT id_discente FROM discente WHERE matricula='2023000111'), (SELECT id_acao FROM acao_extensao WHERE titulo='Programação para Iniciantes'), '2025-04-12', '2025-07-10', 60.0, 'Bolsista', 'concluida'),
((SELECT id_discente FROM discente WHERE matricula='2023000112'), (SELECT id_acao FROM acao_extensao WHERE titulo='Oficina de Segurança da Informação'), '2025-08-02', NULL, 12.0, 'Voluntário', 'em_andamento'),
((SELECT id_discente FROM discente WHERE matricula='2021005566'), (SELECT id_acao FROM acao_extensao WHERE titulo='Programa de Apoio Tecnológico a ONGs'), '2025-01-20', NULL, 80.0, 'Bolsista', 'em_andamento'),
((SELECT id_discente FROM discente WHERE matricula='2021005566'), (SELECT id_acao FROM acao_extensao WHERE titulo='Inclusão Digital na Comunidade'), '2025-03-10', '2025-06-01', 25.0, 'Voluntário', 'cancelada');

INSERT INTO plano_trabalho (id_participacao, carga_horaria_semanal, descricao_atividades, data_submissao, data_aprovacao, aprovado, observacao) VALUES
((SELECT id_participacao FROM participacao WHERE id_discente=(SELECT id_discente FROM discente WHERE matricula='2022001234') AND id_acao=(SELECT id_acao FROM acao_extensao WHERE titulo='Inclusão Digital na Comunidade')), 5.0, 'Apoio às turmas de informática básica', '2025-02-25', '2025-03-01', 'sim', NULL),
((SELECT id_participacao FROM participacao WHERE id_discente=(SELECT id_discente FROM discente WHERE matricula='2022001235') AND id_acao=(SELECT id_acao FROM acao_extensao WHERE titulo='Inclusão Digital na Comunidade')), 5.0, 'Apoio às turmas de informática básica', '2025-02-26', NULL, 'pendente', 'Aguardando aprovação do coordenador'),
((SELECT id_participacao FROM participacao WHERE id_discente=(SELECT id_discente FROM discente WHERE matricula='2023000112') AND id_acao=(SELECT id_acao FROM acao_extensao WHERE titulo='Oficina de Segurança da Informação')), 3.0, 'Suporte na organização da oficina', '2025-07-28', NULL, 'nao', 'Necessita revisao do escopo');

INSERT INTO validacao (id_participacao, id_validador, data_validacao, horas_validadas, status, observacao) VALUES
((SELECT id_participacao FROM participacao WHERE id_discente=(SELECT id_discente FROM discente WHERE matricula='2023000111') AND id_acao=(SELECT id_acao FROM acao_extensao WHERE titulo='Programação para Iniciantes')), (SELECT id_Coordenador FROM Coordenador WHERE siape='SIAPE1001'), '2025-07-12', 60.0, 'aprovado', 'Carga horária integralmente cumprida'),
((SELECT id_participacao FROM participacao WHERE id_discente=(SELECT id_discente FROM discente WHERE matricula='2022001234') AND id_acao=(SELECT id_acao FROM acao_extensao WHERE titulo='Inclusão Digital na Comunidade')), (SELECT id_Coordenador FROM Coordenador WHERE siape='SIAPE1001'), '2025-06-15', 40.0, 'aprovado', NULL);

INSERT INTO documento (id_participacao, tipo, arquivo_path, data_envio, status_validacao, validacao_id_validacao) VALUES
((SELECT id_participacao FROM participacao WHERE id_discente=(SELECT id_discente FROM discente WHERE matricula='2023000111') AND id_acao=(SELECT id_acao FROM acao_extensao WHERE titulo='Programação para Iniciantes')), 'Certificado', '/docs/cert_2023000111.pdf', '2025-07-11', 'aprovado', (SELECT id_validacao FROM validacao WHERE horas_validadas=60.0)),
((SELECT id_participacao FROM participacao WHERE id_discente=(SELECT id_discente FROM discente WHERE matricula='2022001234') AND id_acao=(SELECT id_acao FROM acao_extensao WHERE titulo='Inclusão Digital na Comunidade')), 'Relatório de Atividades', '/docs/rel_2022001234.pdf', '2025-06-10', 'aprovado', (SELECT id_validacao FROM validacao WHERE horas_validadas=40.0));

UPDATE discente d
SET carga_horaria_acumulada = (
    SELECT COALESCE(SUM(p.horas_realizadas), 0)
    FROM participacao p
    WHERE p.id_discente = d.id_discente AND p.status <> 'cancelada'
);
 