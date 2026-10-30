-- ============================================================================
-- GARAGE HAIR ERP | 02 - CARGA DE DADOS VALIDOS
-- Compatível com as 43 tabelas do arquivo 01-estrutura.sql
-- DADOS INTEGRALMENTE FICTICIOS: CPF, CNPJ, emails e URLs ilustrativos.
-- PRÉ-REQUISITO: executar 01_estrutura.sql em banco recém-criado e vazio.
-- ============================================================================

USE garage_hair_erp;

-- ==========================================================================
-- ETAPA 01 | USUARIOS, UNIDADES E RECURSOS HUMANOS
-- Criar cadastros principais antes dos cadastros dependentes (FKs).
-- ==========================================================================
START TRANSACTION;

-- 10 clientes + 12 funcionarios (10 barbeiros e 2 administrativos).
-- TABELA: usuario | 22 registros
INSERT INTO usuario (cpf, nome, email, senha_hash, telefone, tipo, ativo) VALUES
    ('90000000001', 'Ana Oliveira', 'cliente01@example.com', 'HASH_TESTE_CLIENTE_01', '11981000001', 'Cliente', 1),
    ('90000000002', 'Bruno Almeida', 'cliente02@example.com', 'HASH_TESTE_CLIENTE_02', '11981000002', 'Cliente', 1),
    ('90000000003', 'Camila Ferreira', 'cliente03@example.com', 'HASH_TESTE_CLIENTE_03', '11981000003', 'Cliente', 1),
    ('90000000004', 'Daniel Santos', 'cliente04@example.com', 'HASH_TESTE_CLIENTE_04', '11981000004', 'Cliente', 1),
    ('90000000005', 'Elisa Costa', 'cliente05@example.com', 'HASH_TESTE_CLIENTE_05', '11981000005', 'Cliente', 1),
    ('90000000006', 'Felipe Martins', 'cliente06@example.com', 'HASH_TESTE_CLIENTE_06', '11981000006', 'Cliente', 1),
    ('90000000007', 'Gabriela Rocha', 'cliente07@example.com', 'HASH_TESTE_CLIENTE_07', '11981000007', 'Cliente', 1),
    ('90000000008', 'Henrique Lima', 'cliente08@example.com', 'HASH_TESTE_CLIENTE_08', '11981000008', 'Cliente', 1),
    ('90000000009', 'Isabela Souza', 'cliente09@example.com', 'HASH_TESTE_CLIENTE_09', '11981000009', 'Cliente', 1),
    ('90000000010', 'Joao Carvalho', 'cliente10@example.com', 'HASH_TESTE_CLIENTE_10', '11981000010', 'Cliente', 1),
    ('90000000011', 'Lucas Ribeiro', 'funcionario11@example.com', 'HASH_TESTE_FUNC_11', '11982000011', 'Funcionario', 1),
    ('90000000012', 'Mariana Nunes', 'funcionario12@example.com', 'HASH_TESTE_FUNC_12', '11982000012', 'Funcionario', 1),
    ('90000000013', 'Pedro Batista', 'funcionario13@example.com', 'HASH_TESTE_FUNC_13', '11982000013', 'Funcionario', 1),
    ('90000000014', 'Rafaela Gomes', 'funcionario14@example.com', 'HASH_TESTE_FUNC_14', '11982000014', 'Funcionario', 1),
    ('90000000015', 'Thiago Araujo', 'funcionario15@example.com', 'HASH_TESTE_FUNC_15', '11982000015', 'Funcionario', 1),
    ('90000000016', 'Vanessa Silva', 'funcionario16@example.com', 'HASH_TESTE_FUNC_16', '11982000016', 'Funcionario', 1),
    ('90000000017', 'Caio Mendes', 'funcionario17@example.com', 'HASH_TESTE_FUNC_17', '11982000017', 'Funcionario', 1),
    ('90000000018', 'Julia Castro', 'funcionario18@example.com', 'HASH_TESTE_FUNC_18', '11982000018', 'Funcionario', 1),
    ('90000000019', 'Renato Pereira', 'funcionario19@example.com', 'HASH_TESTE_FUNC_19', '11982000019', 'Funcionario', 1),
    ('90000000020', 'Beatriz Lopes', 'funcionario20@example.com', 'HASH_TESTE_FUNC_20', '11982000020', 'Funcionario', 1),
    ('90000000021', 'Carolina Dias', 'gestora@example.com', 'HASH_TESTE_FUNC_21', '11982900021', 'Funcionario', 1),
    ('90000000022', 'Ricardo Vieira', 'recepcao@example.com', 'HASH_TESTE_FUNC_22', '11982900022', 'Funcionario', 1);

-- Quatro unidades ficticias da rede Garage Hair (quantidade menor por serem filiais).
-- TABELA: unidade | 4 registros
INSERT INTO unidade (cnpj, nome, logradouro, numero, complemento, bairro, cidade, estado, cep, telefone, ativo) VALUES
    ('99000000000001', 'Garage Hair Tatuape', 'Rua Serra de Braganca', '520', NULL, 'Tatuape', 'Sao Paulo', 'SP', '03318000', '1130001001', 1),
    ('99000000000002', 'Garage Hair Mooca', 'Rua da Mooca', '1475', 'Loja 2', 'Mooca', 'Sao Paulo', 'SP', '03103001', '1130001002', 1),
    ('99000000000003', 'Garage Hair Penha', 'Avenida Amador Bueno da Veiga', '880', NULL, 'Penha', 'Sao Paulo', 'SP', '03636000', '1130001003', 1),
    ('99000000000004', 'Garage Hair Vila Prudente', 'Rua do Orfanato', '320', NULL, 'Vila Prudente', 'Sao Paulo', 'SP', '03131010', '1130001004', 1);

-- TABELA: cliente | 10 registros
INSERT INTO cliente (cpf, data_nascimento, observacoes_gerais, observacoes_internas) VALUES
    ('90000000001', '1989-05-06', NULL, NULL),
    ('90000000002', '1990-05-07', NULL, NULL),
    ('90000000003', '1991-05-08', NULL, NULL),
    ('90000000004', '1992-05-09', NULL, NULL),
    ('90000000005', '1993-05-10', NULL, NULL),
    ('90000000006', '1994-05-11', NULL, NULL),
    ('90000000007', '1995-05-12', NULL, NULL),
    ('90000000008', '1996-05-13', NULL, NULL),
    ('90000000009', '1997-05-14', NULL, NULL),
    ('90000000010', '1998-05-15', NULL, NULL);

-- TABELA: funcionario | 12 registros
INSERT INTO funcionario (cpf, cnpj, matricula, cargo, data_admissao, salario_bruto) VALUES
    ('90000000011', '99000000000001', 'GH-F011', 'Barbeiro', '2025-01-10', 2800.00),
    ('90000000012', '99000000000002', 'GH-F012', 'Barbeiro', '2025-02-10', 2920.00),
    ('90000000013', '99000000000003', 'GH-F013', 'Barbeiro', '2025-03-10', 3040.00),
    ('90000000014', '99000000000004', 'GH-F014', 'Barbeiro', '2025-04-10', 3160.00),
    ('90000000015', '99000000000001', 'GH-F015', 'Barbeiro', '2025-05-10', 3280.00),
    ('90000000016', '99000000000002', 'GH-F016', 'Barbeiro', '2025-06-10', 3400.00),
    ('90000000017', '99000000000003', 'GH-F017', 'Barbeiro', '2025-07-10', 3520.00),
    ('90000000018', '99000000000004', 'GH-F018', 'Barbeiro', '2025-08-10', 3640.00),
    ('90000000019', '99000000000001', 'GH-F019', 'Barbeiro', '2025-09-10', 3760.00),
    ('90000000020', '99000000000002', 'GH-F020', 'Barbeiro', '2025-01-10', 3880.00),
    ('90000000021', '99000000000001', 'GH-F021', 'Gestor', '2024-01-15', 5400.00),
    ('90000000022', '99000000000002', 'GH-F022', 'Recepcionista', '2025-04-01', 2600.00);

-- TABELA: barbeiro | 10 registros
INSERT INTO barbeiro (cpf) VALUES
    ('90000000011'),
    ('90000000012'),
    ('90000000013'),
    ('90000000014'),
    ('90000000015'),
    ('90000000016'),
    ('90000000017'),
    ('90000000018'),
    ('90000000019'),
    ('90000000020');

-- A restricao CHECK admite exatamente 9 nomes de especialidade; sem duplicatas.
-- TABELA: especialidade | 9 registros
INSERT INTO especialidade (id_especialidade, nome) VALUES
    (1, 'Corte Masculino'),
    (2, 'Corte Feminino'),
    (3, 'Corte Infantil'),
    (4, 'Barba'),
    (5, 'Barboterapia'),
    (6, 'Tingimento'),
    (7, 'Descoloração'),
    (8, 'Tratamento Capilar'),
    (9, 'Penteados');

-- TABELA: especialidade_barbeiro | 10 registros
INSERT INTO especialidade_barbeiro (id_especialidade, cpf, descricao) VALUES
    (1, '90000000011', 'Especialidade cadastrada para Lucas Ribeiro'),
    (2, '90000000012', 'Especialidade cadastrada para Mariana Nunes'),
    (3, '90000000013', 'Especialidade cadastrada para Pedro Batista'),
    (4, '90000000014', 'Especialidade cadastrada para Rafaela Gomes'),
    (5, '90000000015', 'Especialidade cadastrada para Thiago Araujo'),
    (6, '90000000016', 'Especialidade cadastrada para Vanessa Silva'),
    (7, '90000000017', 'Especialidade cadastrada para Caio Mendes'),
    (8, '90000000018', 'Especialidade cadastrada para Julia Castro'),
    (9, '90000000019', 'Especialidade cadastrada para Renato Pereira'),
    (1, '90000000020', 'Especialidade cadastrada para Beatriz Lopes');

-- Dias cadastrados mostram janelas operacionais; outros dias sem registro nesta amostra.
-- TABELA: horario_funcionamento | 10 registros
INSERT INTO horario_funcionamento (cnpj, dia_semana, hora_abertura, hora_fechamento, fechado) VALUES
    ('99000000000001', 'Segunda', '09:00:00', '19:00:00', 0),
    ('99000000000001', 'Terca', '09:00:00', '19:00:00', 0),
    ('99000000000001', 'Quarta', '09:00:00', '19:00:00', 0),
    ('99000000000002', 'Segunda', '09:00:00', '19:00:00', 0),
    ('99000000000002', 'Terca', '09:00:00', '19:00:00', 0),
    ('99000000000002', 'Quarta', '09:00:00', '19:00:00', 0),
    ('99000000000003', 'Segunda', '09:00:00', '19:00:00', 0),
    ('99000000000003', 'Terca', '09:00:00', '19:00:00', 0),
    ('99000000000004', 'Segunda', '09:00:00', '19:00:00', 0),
    ('99000000000004', 'Terca', '09:00:00', '19:00:00', 0);

-- Amostra de jornadas diarias; o horario semanal completo seria ampliado em uso real.
-- TABELA: horario_funcionario | 10 registros
INSERT INTO horario_funcionario (cpf, dia_semana, hora_inicio, hora_fim, hora_inicio_intervalo, hora_fim_intervalo, folga) VALUES
    ('90000000011', 'Segunda', '09:00:00', '18:00:00', '12:00:00', '13:00:00', 0),
    ('90000000012', 'Terca', '09:00:00', '18:00:00', '12:00:00', '13:00:00', 0),
    ('90000000013', 'Quarta', '09:00:00', '18:00:00', '12:00:00', '13:00:00', 0),
    ('90000000014', 'Quinta', '09:00:00', '18:00:00', '12:00:00', '13:00:00', 0),
    ('90000000015', 'Sexta', '09:00:00', '18:00:00', '12:00:00', '13:00:00', 0),
    ('90000000016', 'Sabado', '09:00:00', '18:00:00', '12:00:00', '13:00:00', 0),
    ('90000000017', 'Segunda', '09:00:00', '18:00:00', '12:00:00', '13:00:00', 0),
    ('90000000018', 'Terca', '09:00:00', '18:00:00', '12:00:00', '13:00:00', 0),
    ('90000000019', 'Quarta', '09:00:00', '18:00:00', '12:00:00', '13:00:00', 0),
    ('90000000020', 'Quinta', '09:00:00', '18:00:00', '12:00:00', '13:00:00', 0);

COMMIT;


-- ==========================================================================
-- ETAPA 02 | CATALOGO DE PRODUTOS, SERVICOS E COMBOS
-- ==========================================================================
START TRANSACTION;

-- TABELA: categoria_produto | 10 registros
INSERT INTO categoria_produto (id_categoria_produto, nome, descricao, ativo) VALUES
    (1, 'Shampoos', 'Produtos da categoria shampoos', 1),
    (2, 'Condicionadores', 'Produtos da categoria condicionadores', 1),
    (3, 'Pomadas', 'Produtos da categoria pomadas', 1),
    (4, 'Ceras', 'Produtos da categoria ceras', 1),
    (5, 'Oleos para Barba', 'Produtos da categoria oleos para barba', 1),
    (6, 'Balms', 'Produtos da categoria balms', 1),
    (7, 'Tinturas', 'Produtos da categoria tinturas', 1),
    (8, 'Tratamentos Capilares', 'Produtos da categoria tratamentos capilares', 1),
    (9, 'Acessorios', 'Produtos da categoria acessorios', 1),
    (10, 'Finalizadores', 'Produtos da categoria finalizadores', 1);

-- lucro_unitario VIRTUAL omitido do INSERT (calculado pelo MySQL).
-- TABELA: produto | 10 registros
INSERT INTO produto (id_produto, id_categoria_produto, codigo_interno, nome, data_validade, preco_custo, preco_venda, disponivel) VALUES
    (1, 1, 'GH-P001', 'Shampoo Neutro 300ml', '2028-12-31', 18.00, 35.00, 1),
    (2, 2, 'GH-P002', 'Condicionador Hidratante 250ml', '2028-12-31', 20.00, 42.00, 1),
    (3, 3, 'GH-P003', 'Pomada Modeladora 80g', '2028-12-31', 16.50, 34.90, 1),
    (4, 4, 'GH-P004', 'Cera Matte 90g', '2028-12-31', 17.00, 36.00, 1),
    (5, 5, 'GH-P005', 'Oleo para Barba 30ml', '2028-12-31', 22.00, 49.90, 1),
    (6, 6, 'GH-P006', 'Balm para Barba 100ml', '2028-12-31', 19.00, 44.00, 1),
    (7, 7, 'GH-P007', 'Tintura Castanho 50g', '2028-12-31', 27.00, 59.90, 1),
    (8, 8, 'GH-P008', 'Mascara Capilar 250g', '2028-12-31', 24.00, 52.00, 1),
    (9, 9, 'GH-P009', 'Pente de Madeira', NULL, 8.00, 19.90, 1),
    (10, 10, 'GH-P010', 'Spray Finalizador 150ml', '2028-12-31', 21.00, 45.00, 1);

-- URLs de exemplo: substituir por imagens reais se a aplicacao necessitar.
-- TABELA: foto_produto | 10 registros
INSERT INTO foto_produto (id_foto, id_produto, url_foto, legenda) VALUES
    (1, 1, 'https://example.com/garage-hair/produtos/01.jpg', 'Foto ilustrativa de Shampoo Neutro 300ml'),
    (2, 2, 'https://example.com/garage-hair/produtos/02.jpg', 'Foto ilustrativa de Condicionador Hidratante 250ml'),
    (3, 3, 'https://example.com/garage-hair/produtos/03.jpg', 'Foto ilustrativa de Pomada Modeladora 80g'),
    (4, 4, 'https://example.com/garage-hair/produtos/04.jpg', 'Foto ilustrativa de Cera Matte 90g'),
    (5, 5, 'https://example.com/garage-hair/produtos/05.jpg', 'Foto ilustrativa de Oleo para Barba 30ml'),
    (6, 6, 'https://example.com/garage-hair/produtos/06.jpg', 'Foto ilustrativa de Balm para Barba 100ml'),
    (7, 7, 'https://example.com/garage-hair/produtos/07.jpg', 'Foto ilustrativa de Tintura Castanho 50g'),
    (8, 8, 'https://example.com/garage-hair/produtos/08.jpg', 'Foto ilustrativa de Mascara Capilar 250g'),
    (9, 9, 'https://example.com/garage-hair/produtos/09.jpg', 'Foto ilustrativa de Pente de Madeira'),
    (10, 10, 'https://example.com/garage-hair/produtos/10.jpg', 'Foto ilustrativa de Spray Finalizador 150ml');

-- TABELA: servico | 10 registros
INSERT INTO servico (id_servico, nome, duracao_estimada, preco, descricao, disponivel) VALUES
    (1, 'Corte Masculino', 40, 60.00, 'Atendimento de corte masculino realizado na unidade.', 1),
    (2, 'Corte Feminino', 60, 90.00, 'Atendimento de corte feminino realizado na unidade.', 1),
    (3, 'Corte Infantil', 35, 50.00, 'Atendimento de corte infantil realizado na unidade.', 1),
    (4, 'Barba Tradicional', 30, 45.00, 'Atendimento de barba tradicional realizado na unidade.', 1),
    (5, 'Barboterapia', 45, 75.00, 'Atendimento de barboterapia realizado na unidade.', 1),
    (6, 'Tingimento', 90, 130.00, 'Atendimento de tingimento realizado na unidade.', 1),
    (7, 'Descoloracao', 120, 180.00, 'Atendimento de descoloracao realizado na unidade.', 1),
    (8, 'Hidratacao Capilar', 50, 80.00, 'Atendimento de hidratacao capilar realizado na unidade.', 1),
    (9, 'Penteado', 50, 95.00, 'Atendimento de penteado realizado na unidade.', 1),
    (10, 'Acabamento e Contorno', 20, 30.00, 'Atendimento de acabamento e contorno realizado na unidade.', 1);

-- TABELA: combo | 10 registros
INSERT INTO combo (id_combo, nome, preco, descricao, ativo) VALUES
    (1, 'Corte + Shampoo', 85.00, 'Pacote corte + shampoo de servico com produto.', 1),
    (2, 'Visual Completo', 125.00, 'Pacote visual completo de servico com produto.', 1),
    (3, 'Infantil + Cuidado', 75.00, 'Pacote infantil + cuidado de servico com produto.', 1),
    (4, 'Barba + Oleo', 85.00, 'Pacote barba + oleo de servico com produto.', 1),
    (5, 'Barboterapia + Balm', 110.00, 'Pacote barboterapia + balm de servico com produto.', 1),
    (6, 'Cor e Estilo', 160.00, 'Pacote cor e estilo de servico com produto.', 1),
    (7, 'Descoloracao Premium', 205.00, 'Pacote descoloracao premium de servico com produto.', 1),
    (8, 'Hidratacao Intensiva', 110.00, 'Pacote hidratacao intensiva de servico com produto.', 1),
    (9, 'Penteado Especial', 110.00, 'Pacote penteado especial de servico com produto.', 1),
    (10, 'Acabamento Express', 44.90, 'Pacote acabamento express de servico com produto.', 1);

-- TABELA: combo_servico | 10 registros
INSERT INTO combo_servico (id_combo, id_servico) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10);

-- TABELA: combo_produto | 10 registros
INSERT INTO combo_produto (id_combo, id_produto, quantidade) VALUES
    (1, 1, 1),
    (2, 2, 1),
    (3, 3, 1),
    (4, 4, 1),
    (5, 5, 1),
    (6, 6, 1),
    (7, 7, 1),
    (8, 8, 1),
    (9, 9, 1),
    (10, 10, 1);

COMMIT;


-- ==========================================================================
-- ETAPA 03 | CAMPANHAS E CUPONS
-- ==========================================================================
START TRANSACTION;

-- TABELA: campanha | 10 registros
INSERT INTO campanha (id_campanha, nome, tipo, data_inicio, data_fim, descricao, ativo) VALUES
    (1, 'Mes do Cliente', 'Promocional', '2026-09-01', '2026-12-31', 'Campanha demonstrativa mes do cliente.', 1),
    (2, 'Semana do Autocuidado', 'Promocional', '2026-09-01', '2026-12-31', 'Campanha demonstrativa semana do autocuidado.', 1),
    (3, 'Cuidado com a Barba', 'Promocional', '2026-09-01', '2026-12-31', 'Campanha demonstrativa cuidado com a barba.', 1),
    (4, 'Novos Clientes', 'Promocional', '2026-09-01', '2026-12-31', 'Campanha demonstrativa novos clientes.', 1),
    (5, 'Aniversario Garage Hair', 'Promocional', '2026-09-01', '2026-12-31', 'Campanha demonstrativa aniversario garage hair.', 1),
    (6, 'Dia do Estilo', 'Promocional', '2026-09-01', '2026-12-31', 'Campanha demonstrativa dia do estilo.', 1),
    (7, 'Festival de Cortes', 'Promocional', '2026-09-01', '2026-12-31', 'Campanha demonstrativa festival de cortes.', 1),
    (8, 'Campanha da Familia', 'Promocional', '2026-09-01', '2026-12-31', 'Campanha demonstrativa campanha da familia.', 1),
    (9, 'Semana da Hidratacao', 'Promocional', '2026-09-01', '2026-12-31', 'Campanha demonstrativa semana da hidratacao.', 1),
    (10, 'Primavera Garage Hair', 'Promocional', '2026-09-01', '2026-12-31', 'Campanha demonstrativa primavera garage hair.', 1);

-- quantidade_usada=1, coerente com as 10 utilizacoes registradas na etapa 07.
-- TABELA: cupom | 10 registros
INSERT INTO cupom (id_cupom, id_campanha, codigo_cupom, tipo_desconto, valor_desconto, limite_usos, limite_usos_cliente, quantidade_usada, ativo) VALUES
    (1, 1, 'GH202601', 'Percentual', 10.00, 100, 3, 1, 1),
    (2, 2, 'GH202602', 'Fixo', 5.00, 100, 3, 1, 1),
    (3, 3, 'GH202603', 'Percentual', 10.00, 100, 3, 1, 1),
    (4, 4, 'GH202604', 'Fixo', 5.00, 100, 3, 1, 1),
    (5, 5, 'GH202605', 'Percentual', 10.00, 100, 3, 1, 1),
    (6, 6, 'GH202606', 'Fixo', 5.00, 100, 3, 1, 1),
    (7, 7, 'GH202607', 'Percentual', 10.00, 100, 3, 1, 1),
    (8, 8, 'GH202608', 'Fixo', 5.00, 100, 3, 1, 1),
    (9, 9, 'GH202609', 'Percentual', 10.00, 100, 3, 1, 1),
    (10, 10, 'GH202610', 'Fixo', 5.00, 100, 3, 1, 1);

COMMIT;


-- ==========================================================================
-- ETAPA 04 | AGENDAMENTOS
-- ==========================================================================
START TRANSACTION;

-- TABELA: agendamento | 10 registros
INSERT INTO agendamento (id_agendamento, cpf_cliente, cpf_barbeiro, id_cupom, data_hora, duracao_estimada, status) VALUES
    (1, '90000000001', '90000000011', 1, '2026-10-01 10:00:00', 90, 'Concluido'),
    (2, '90000000002', '90000000012', 2, '2026-10-02 10:00:00', 90, 'Concluido'),
    (3, '90000000003', '90000000013', 3, '2026-10-03 10:00:00', 90, 'Concluido'),
    (4, '90000000004', '90000000014', 4, '2026-10-04 10:00:00', 90, 'Concluido'),
    (5, '90000000005', '90000000015', 5, '2026-10-05 10:00:00', 90, 'Concluido'),
    (6, '90000000006', '90000000016', 6, '2026-10-06 10:00:00', 90, 'Concluido'),
    (7, '90000000007', '90000000017', 7, '2026-10-07 10:00:00', 90, 'Concluido'),
    (8, '90000000008', '90000000018', 8, '2026-10-08 10:00:00', 90, 'Concluido'),
    (9, '90000000009', '90000000019', 9, '2026-10-09 10:00:00', 90, 'Concluido'),
    (10, '90000000010', '90000000020', 10, '2026-10-10 10:00:00', 90, 'Concluido');

-- TABELA: agendamento_combo | 10 registros
INSERT INTO agendamento_combo (id_agendamento, id_combo, observacao) VALUES
    (1, 1, 'Cliente agendou combo promocional.'),
    (2, 2, 'Cliente agendou combo promocional.'),
    (3, 3, 'Cliente agendou combo promocional.'),
    (4, 4, 'Cliente agendou combo promocional.'),
    (5, 5, 'Cliente agendou combo promocional.'),
    (6, 6, 'Cliente agendou combo promocional.'),
    (7, 7, 'Cliente agendou combo promocional.'),
    (8, 8, 'Cliente agendou combo promocional.'),
    (9, 9, 'Cliente agendou combo promocional.'),
    (10, 10, 'Cliente agendou combo promocional.');

-- TABELA: agendamento_servico | 10 registros
INSERT INTO agendamento_servico (id_agendamento, id_servico, observacao) VALUES
    (1, 1, 'Servico complementar combinado no atendimento.'),
    (2, 2, 'Servico complementar combinado no atendimento.'),
    (3, 3, 'Servico complementar combinado no atendimento.'),
    (4, 4, 'Servico complementar combinado no atendimento.'),
    (5, 5, 'Servico complementar combinado no atendimento.'),
    (6, 6, 'Servico complementar combinado no atendimento.'),
    (7, 7, 'Servico complementar combinado no atendimento.'),
    (8, 8, 'Servico complementar combinado no atendimento.'),
    (9, 9, 'Servico complementar combinado no atendimento.'),
    (10, 10, 'Servico complementar combinado no atendimento.');

COMMIT;


-- ==========================================================================
-- ETAPA 05 | TRATAMENTOS E ACOMPANHAMENTO
-- ==========================================================================
START TRANSACTION;

-- TABELA: tipo_tratamento | 10 registros
INSERT INTO tipo_tratamento (id_tipo_tratamento, nome, descricao, ativo) VALUES
    (1, 'Hidratacao Profunda', 'Protocolo de hidratacao profunda.', 1),
    (2, 'Reconstrucao Capilar', 'Protocolo de reconstrucao capilar.', 1),
    (3, 'Controle de Oleosidade', 'Protocolo de controle de oleosidade.', 1),
    (4, 'Fortalecimento', 'Protocolo de fortalecimento.', 1),
    (5, 'Cuidados com a Barba', 'Protocolo de cuidados com a barba.', 1),
    (6, 'Tratamento Antiqueda', 'Protocolo de tratamento antiqueda.', 1),
    (7, 'Nutrição Capilar', 'Protocolo de nutrição capilar.', 1),
    (8, 'Revitalizacao', 'Protocolo de revitalizacao.', 1),
    (9, 'Cuidados com o Couro Cabeludo', 'Protocolo de cuidados com o couro cabeludo.', 1),
    (10, 'Pos-Coloracao', 'Protocolo de pos-coloracao.', 1);

-- TABELA: tratamento | 10 registros
INSERT INTO tratamento (id_tratamento, cpf_cliente, cpf_barbeiro, id_tipo_tratamento, data_inicio, data_fim, status, motivo_cancelamento, objetivo) VALUES
    (1, '90000000001', '90000000011', 1, '2026-10-01', NULL, 'Ativo', NULL, 'Promover cuidados capilares personalizados.'),
    (2, '90000000002', '90000000012', 2, '2026-10-02', '2026-10-12', 'Concluido', NULL, 'Promover cuidados capilares personalizados.'),
    (3, '90000000003', '90000000013', 3, '2026-10-03', NULL, 'Ativo', NULL, 'Promover cuidados capilares personalizados.'),
    (4, '90000000004', '90000000014', 4, '2026-10-04', '2026-10-14', 'Concluido', NULL, 'Promover cuidados capilares personalizados.'),
    (5, '90000000005', '90000000015', 5, '2026-10-05', NULL, 'Cancelado', 'Solicitacao do cliente.', 'Promover cuidados capilares personalizados.'),
    (6, '90000000006', '90000000016', 6, '2026-10-06', NULL, 'Ativo', NULL, 'Promover cuidados capilares personalizados.'),
    (7, '90000000007', '90000000017', 7, '2026-10-07', '2026-10-17', 'Concluido', NULL, 'Promover cuidados capilares personalizados.'),
    (8, '90000000008', '90000000018', 8, '2026-10-08', NULL, 'Ativo', NULL, 'Promover cuidados capilares personalizados.'),
    (9, '90000000009', '90000000019', 9, '2026-10-09', '2026-10-19', 'Concluido', NULL, 'Promover cuidados capilares personalizados.'),
    (10, '90000000010', '90000000020', 10, '2026-10-10', NULL, 'Cancelado', 'Solicitacao do cliente.', 'Promover cuidados capilares personalizados.');

-- TABELA: fase_tratamento | 10 registros
INSERT INTO fase_tratamento (id_fase, id_tratamento, titulo, data, numero_fase, descricao, observacoes_barbeiro, observacoes_cliente) VALUES
    (1, 1, 'Avaliacao inicial', '2026-10-01', 1, 'Diagnostico e orientacoes de cuidado.', 'Atendimento registrado.', 'Cliente orientado.'),
    (2, 2, 'Avaliacao inicial', '2026-10-02', 1, 'Diagnostico e orientacoes de cuidado.', 'Atendimento registrado.', 'Cliente orientado.'),
    (3, 3, 'Avaliacao inicial', '2026-10-03', 1, 'Diagnostico e orientacoes de cuidado.', 'Atendimento registrado.', 'Cliente orientado.'),
    (4, 4, 'Avaliacao inicial', '2026-10-04', 1, 'Diagnostico e orientacoes de cuidado.', 'Atendimento registrado.', 'Cliente orientado.'),
    (5, 5, 'Avaliacao inicial', '2026-10-05', 1, 'Diagnostico e orientacoes de cuidado.', 'Atendimento registrado.', 'Cliente orientado.'),
    (6, 6, 'Avaliacao inicial', '2026-10-06', 1, 'Diagnostico e orientacoes de cuidado.', 'Atendimento registrado.', 'Cliente orientado.'),
    (7, 7, 'Avaliacao inicial', '2026-10-07', 1, 'Diagnostico e orientacoes de cuidado.', 'Atendimento registrado.', 'Cliente orientado.'),
    (8, 8, 'Avaliacao inicial', '2026-10-08', 1, 'Diagnostico e orientacoes de cuidado.', 'Atendimento registrado.', 'Cliente orientado.'),
    (9, 9, 'Avaliacao inicial', '2026-10-09', 1, 'Diagnostico e orientacoes de cuidado.', 'Atendimento registrado.', 'Cliente orientado.'),
    (10, 10, 'Avaliacao inicial', '2026-10-10', 1, 'Diagnostico e orientacoes de cuidado.', 'Atendimento registrado.', 'Cliente orientado.');

-- TABELA: foto_fase | 10 registros
INSERT INTO foto_fase (id_foto, id_fase, url_foto, legenda, data_foto) VALUES
    (1, 1, 'https://example.com/garage-hair/tratamentos/fase-01.jpg', 'Registro ficticio da etapa.', '2026-10-01'),
    (2, 2, 'https://example.com/garage-hair/tratamentos/fase-02.jpg', 'Registro ficticio da etapa.', '2026-10-02'),
    (3, 3, 'https://example.com/garage-hair/tratamentos/fase-03.jpg', 'Registro ficticio da etapa.', '2026-10-03'),
    (4, 4, 'https://example.com/garage-hair/tratamentos/fase-04.jpg', 'Registro ficticio da etapa.', '2026-10-04'),
    (5, 5, 'https://example.com/garage-hair/tratamentos/fase-05.jpg', 'Registro ficticio da etapa.', '2026-10-05'),
    (6, 6, 'https://example.com/garage-hair/tratamentos/fase-06.jpg', 'Registro ficticio da etapa.', '2026-10-06'),
    (7, 7, 'https://example.com/garage-hair/tratamentos/fase-07.jpg', 'Registro ficticio da etapa.', '2026-10-07'),
    (8, 8, 'https://example.com/garage-hair/tratamentos/fase-08.jpg', 'Registro ficticio da etapa.', '2026-10-08'),
    (9, 9, 'https://example.com/garage-hair/tratamentos/fase-09.jpg', 'Registro ficticio da etapa.', '2026-10-09'),
    (10, 10, 'https://example.com/garage-hair/tratamentos/fase-10.jpg', 'Registro ficticio da etapa.', '2026-10-10');

COMMIT;


-- ==========================================================================
-- ETAPA 06 | FORNECEDORES, COMPRAS E ESTOQUE
-- ==========================================================================
START TRANSACTION;

-- TABELA: fornecedor | 10 registros
INSERT INTO fornecedor (cnpj, nome, logradouro, numero, complemento, bairro, cidade, estado, cep, tipo, ativo) VALUES
    ('88000000000001', 'Cosmeticos Aurora', 'Rua dos Fornecedores 1', '101', NULL, 'Centro', 'Sao Paulo', 'SP', '01000001', 'Distribuidor', 1),
    ('88000000000002', 'Distribuidora Bela Forma', 'Rua dos Fornecedores 2', '102', NULL, 'Centro', 'Sao Paulo', 'SP', '01000002', 'Distribuidor', 1),
    ('88000000000003', 'Hair Pro Suprimentos', 'Rua dos Fornecedores 3', '103', NULL, 'Centro', 'Sao Paulo', 'SP', '01000003', 'Distribuidor', 1),
    ('88000000000004', 'Essencia Capilar', 'Rua dos Fornecedores 4', '104', NULL, 'Centro', 'Sao Paulo', 'SP', '01000004', 'Distribuidor', 1),
    ('88000000000005', 'Distribuidora Horizonte', 'Rua dos Fornecedores 5', '105', NULL, 'Centro', 'Sao Paulo', 'SP', '01000005', 'Distribuidor', 1),
    ('88000000000006', 'Cuidado Natural', 'Rua dos Fornecedores 6', '106', NULL, 'Centro', 'Sao Paulo', 'SP', '01000006', 'Distribuidor', 1),
    ('88000000000007', 'Linha Profissional', 'Rua dos Fornecedores 7', '107', NULL, 'Centro', 'Sao Paulo', 'SP', '01000007', 'Distribuidor', 1),
    ('88000000000008', 'Estilo Produtos', 'Rua dos Fornecedores 8', '108', NULL, 'Centro', 'Sao Paulo', 'SP', '01000008', 'Distribuidor', 1),
    ('88000000000009', 'Acessorios Ideal', 'Rua dos Fornecedores 9', '109', NULL, 'Centro', 'Sao Paulo', 'SP', '01000009', 'Distribuidor', 1),
    ('88000000000010', 'Beauty Supply Brasil', 'Rua dos Fornecedores 10', '110', NULL, 'Centro', 'Sao Paulo', 'SP', '01000010', 'Distribuidor', 1);

-- TABELA: contato_fornecedor | 10 registros
INSERT INTO contato_fornecedor (id_contato_fornecedor, cnpj, nome, telefone, email, cargo) VALUES
    (1, '88000000000001', 'Contato Comercial 1', '1132000001', 'contato01@example.com', 'Representante'),
    (2, '88000000000002', 'Contato Comercial 2', '1132000002', 'contato02@example.com', 'Representante'),
    (3, '88000000000003', 'Contato Comercial 3', '1132000003', 'contato03@example.com', 'Representante'),
    (4, '88000000000004', 'Contato Comercial 4', '1132000004', 'contato04@example.com', 'Representante'),
    (5, '88000000000005', 'Contato Comercial 5', '1132000005', 'contato05@example.com', 'Representante'),
    (6, '88000000000006', 'Contato Comercial 6', '1132000006', 'contato06@example.com', 'Representante'),
    (7, '88000000000007', 'Contato Comercial 7', '1132000007', 'contato07@example.com', 'Representante'),
    (8, '88000000000008', 'Contato Comercial 8', '1132000008', 'contato08@example.com', 'Representante'),
    (9, '88000000000009', 'Contato Comercial 9', '1132000009', 'contato09@example.com', 'Representante'),
    (10, '88000000000010', 'Contato Comercial 10', '1132000010', 'contato10@example.com', 'Representante');

-- Cada fornecedor oferece o produto principal e o produto seguinte, como nas compras.
-- TABELA: produto_fornecedor | 20 registros
INSERT INTO produto_fornecedor (id_produto, cnpj) VALUES
    (1, '88000000000001'),
    (2, '88000000000001'),
    (2, '88000000000002'),
    (3, '88000000000002'),
    (3, '88000000000003'),
    (4, '88000000000003'),
    (4, '88000000000004'),
    (5, '88000000000004'),
    (5, '88000000000005'),
    (6, '88000000000005'),
    (6, '88000000000006'),
    (7, '88000000000006'),
    (7, '88000000000007'),
    (8, '88000000000007'),
    (8, '88000000000008'),
    (9, '88000000000008'),
    (9, '88000000000009'),
    (10, '88000000000009'),
    (10, '88000000000010'),
    (1, '88000000000010');

-- TABELA: compra | 10 registros
INSERT INTO compra (id_compra, cnpj_fornecedor, cnpj_unidade, data_compra, data_recebimento, status) VALUES
    (1, '88000000000001', '99000000000001', '2026-09-01 09:00:00', '2026-09-03 15:00:00', 'Recebido'),
    (2, '88000000000002', '99000000000002', '2026-09-02 09:00:00', '2026-09-04 15:00:00', 'Recebido'),
    (3, '88000000000003', '99000000000003', '2026-09-03 09:00:00', '2026-09-05 15:00:00', 'Recebido'),
    (4, '88000000000004', '99000000000004', '2026-09-04 09:00:00', '2026-09-06 15:00:00', 'Recebido'),
    (5, '88000000000005', '99000000000001', '2026-09-05 09:00:00', '2026-09-07 15:00:00', 'Recebido'),
    (6, '88000000000006', '99000000000002', '2026-09-06 09:00:00', '2026-09-08 15:00:00', 'Recebido'),
    (7, '88000000000007', '99000000000003', '2026-09-07 09:00:00', '2026-09-09 15:00:00', 'Recebido'),
    (8, '88000000000008', '99000000000004', '2026-09-08 09:00:00', '2026-09-10 15:00:00', 'Recebido'),
    (9, '88000000000009', '99000000000001', '2026-09-09 09:00:00', NULL, 'Pendente'),
    (10, '88000000000010', '99000000000002', '2026-09-10 09:00:00', NULL, 'Pendente');

-- Dois itens por compra; valores unitarios historicos de custo.
-- TABELA: compra_item | 20 registros
INSERT INTO compra_item (id_compra, id_produto, quantidade, valor_unitario) VALUES
    (1, 1, 5, 18.00),
    (1, 2, 3, 20.00),
    (2, 2, 6, 20.00),
    (2, 3, 4, 16.50),
    (3, 3, 7, 16.50),
    (3, 4, 5, 17.00),
    (4, 4, 8, 17.00),
    (4, 5, 6, 22.00),
    (5, 5, 9, 22.00),
    (5, 6, 7, 19.00),
    (6, 6, 10, 19.00),
    (6, 7, 8, 27.00),
    (7, 7, 11, 27.00),
    (7, 8, 9, 24.00),
    (8, 8, 12, 24.00),
    (8, 9, 10, 8.00),
    (9, 9, 13, 8.00),
    (9, 10, 11, 21.00),
    (10, 10, 14, 21.00),
    (10, 1, 12, 18.00);

-- Saldos iniciais de exemplo, sem baixa automatica pela carga.
-- TABELA: estoque_unidade | 10 registros
INSERT INTO estoque_unidade (cnpj, id_produto, quantidade_atual, quantidade_minima) VALUES
    ('99000000000001', 1, 17, 5),
    ('99000000000002', 2, 19, 5),
    ('99000000000003', 3, 21, 5),
    ('99000000000004', 4, 23, 5),
    ('99000000000001', 5, 25, 5),
    ('99000000000002', 6, 27, 5),
    ('99000000000003', 7, 29, 5),
    ('99000000000004', 8, 31, 5),
    ('99000000000001', 9, 33, 5),
    ('99000000000002', 10, 35, 5);

COMMIT;


-- ==========================================================================
-- ETAPA 07 | ATENDIMENTOS, VENDAS, CUPONS UTILIZADOS E AVALIACOES
-- ==========================================================================
START TRANSACTION;

-- TABELA: comanda | 10 registros
INSERT INTO comanda (id_comanda, id_agendamento, cnpj, cpf_funcionario, cpf_cliente, data_fechamento, forma_pagamento, status) VALUES
    (1, 1, '99000000000001', '90000000011', '90000000001', '2026-10-01 12:00:00', 'Pix', 'Fechada'),
    (2, 2, '99000000000002', '90000000012', '90000000002', '2026-10-02 12:00:00', 'Cartao', 'Fechada'),
    (3, 3, '99000000000003', '90000000013', '90000000003', '2026-10-03 12:00:00', 'Pix', 'Fechada'),
    (4, 4, '99000000000004', '90000000014', '90000000004', '2026-10-04 12:00:00', 'Cartao', 'Fechada'),
    (5, 5, '99000000000001', '90000000015', '90000000005', '2026-10-05 12:00:00', 'Pix', 'Fechada'),
    (6, 6, '99000000000002', '90000000016', '90000000006', '2026-10-06 12:00:00', 'Cartao', 'Fechada'),
    (7, 7, '99000000000003', '90000000017', '90000000007', '2026-10-07 12:00:00', 'Pix', 'Fechada'),
    (8, 8, '99000000000004', '90000000018', '90000000008', '2026-10-08 12:00:00', 'Cartao', 'Fechada'),
    (9, 9, '99000000000001', '90000000019', '90000000009', '2026-10-09 12:00:00', 'Pix', 'Fechada'),
    (10, 10, '99000000000002', '90000000020', '90000000010', '2026-10-10 12:00:00', 'Cartao', 'Fechada');

-- TABELA: comanda_item | 20 registros
INSERT INTO comanda_item (id_item, id_comanda, id_servico, id_produto, id_combo, id_tratamento, descricao_item, quantidade, valor_unitario) VALUES
    (1, 1, NULL, NULL, 1, NULL, 'Combo Corte + Shampoo', 1, 85.00),
    (2, 2, NULL, NULL, 2, NULL, 'Combo Visual Completo', 1, 125.00),
    (3, 3, NULL, NULL, 3, NULL, 'Combo Infantil + Cuidado', 1, 75.00),
    (4, 4, NULL, NULL, 4, NULL, 'Combo Barba + Oleo', 1, 85.00),
    (5, 5, NULL, NULL, 5, NULL, 'Combo Barboterapia + Balm', 1, 110.00),
    (6, 6, NULL, NULL, 6, NULL, 'Combo Cor e Estilo', 1, 160.00),
    (7, 7, NULL, NULL, 7, NULL, 'Combo Descoloracao Premium', 1, 205.00),
    (8, 8, NULL, NULL, 8, NULL, 'Combo Hidratacao Intensiva', 1, 110.00),
    (9, 9, NULL, NULL, 9, NULL, 'Combo Penteado Especial', 1, 110.00),
    (10, 10, NULL, NULL, 10, NULL, 'Combo Acabamento Express', 1, 44.90),
    (11, 1, NULL, 1, NULL, NULL, 'Produto Shampoo Neutro 300ml', 1, 35.00),
    (12, 2, NULL, 2, NULL, NULL, 'Produto Condicionador Hidratante 250ml', 1, 42.00),
    (13, 3, NULL, 3, NULL, NULL, 'Produto Pomada Modeladora 80g', 1, 34.90),
    (14, 4, NULL, 4, NULL, NULL, 'Produto Cera Matte 90g', 1, 36.00),
    (15, 5, NULL, 5, NULL, NULL, 'Produto Oleo para Barba 30ml', 1, 49.90),
    (16, 6, NULL, 6, NULL, NULL, 'Produto Balm para Barba 100ml', 1, 44.00),
    (17, 7, NULL, 7, NULL, NULL, 'Produto Tintura Castanho 50g', 1, 59.90),
    (18, 8, NULL, 8, NULL, NULL, 'Produto Mascara Capilar 250g', 1, 52.00),
    (19, 9, NULL, 9, NULL, NULL, 'Produto Pente de Madeira', 1, 19.90),
    (20, 10, NULL, 10, NULL, NULL, 'Produto Spray Finalizador 150ml', 1, 45.00);

-- Historico do combo: uma composicao de servico e outra de produto para cada combo vendido.
-- TABELA: comanda_combo_composicao | 20 registros
INSERT INTO comanda_combo_composicao (id_composicao, id_item, id_produto, id_servico, nome_item, quantidade, valor_referencia) VALUES
    (1, 1, NULL, 1, 'Corte Masculino', 1, 60.00),
    (2, 1, 1, NULL, 'Shampoo Neutro 300ml', 1, 35.00),
    (3, 2, NULL, 2, 'Corte Feminino', 1, 90.00),
    (4, 2, 2, NULL, 'Condicionador Hidratante 250ml', 1, 42.00),
    (5, 3, NULL, 3, 'Corte Infantil', 1, 50.00),
    (6, 3, 3, NULL, 'Pomada Modeladora 80g', 1, 34.90),
    (7, 4, NULL, 4, 'Barba Tradicional', 1, 45.00),
    (8, 4, 4, NULL, 'Cera Matte 90g', 1, 36.00),
    (9, 5, NULL, 5, 'Barboterapia', 1, 75.00),
    (10, 5, 5, NULL, 'Oleo para Barba 30ml', 1, 49.90),
    (11, 6, NULL, 6, 'Tingimento', 1, 130.00),
    (12, 6, 6, NULL, 'Balm para Barba 100ml', 1, 44.00),
    (13, 7, NULL, 7, 'Descoloracao', 1, 180.00),
    (14, 7, 7, NULL, 'Tintura Castanho 50g', 1, 59.90),
    (15, 8, NULL, 8, 'Hidratacao Capilar', 1, 80.00),
    (16, 8, 8, NULL, 'Mascara Capilar 250g', 1, 52.00),
    (17, 9, NULL, 9, 'Penteado', 1, 95.00),
    (18, 9, 9, NULL, 'Pente de Madeira', 1, 19.90),
    (19, 10, NULL, 10, 'Acabamento e Contorno', 1, 30.00),
    (20, 10, 10, NULL, 'Spray Finalizador 150ml', 1, 45.00);

-- TABELA: cupom_utilizacao | 10 registros
INSERT INTO cupom_utilizacao (id_utilizacao, id_cupom, cpf_cliente, id_comanda, data_utilizacao, valor_desconto_aplicado, tipo_desconto_aplicado, valor_original_desconto) VALUES
    (1, 1, '90000000001', 1, '2026-10-01 11:55:00', 12.00, 'Percentual', 10.00),
    (2, 2, '90000000002', 2, '2026-10-02 11:55:00', 5.00, 'Fixo', 5.00),
    (3, 3, '90000000003', 3, '2026-10-03 11:55:00', 10.99, 'Percentual', 10.00),
    (4, 4, '90000000004', 4, '2026-10-04 11:55:00', 5.00, 'Fixo', 5.00),
    (5, 5, '90000000005', 5, '2026-10-05 11:55:00', 15.99, 'Percentual', 10.00),
    (6, 6, '90000000006', 6, '2026-10-06 11:55:00', 5.00, 'Fixo', 5.00),
    (7, 7, '90000000007', 7, '2026-10-07 11:55:00', 26.49, 'Percentual', 10.00),
    (8, 8, '90000000008', 8, '2026-10-08 11:55:00', 5.00, 'Fixo', 5.00),
    (9, 9, '90000000009', 9, '2026-10-09 11:55:00', 12.99, 'Percentual', 10.00),
    (10, 10, '90000000010', 10, '2026-10-10 11:55:00', 5.00, 'Fixo', 5.00);

-- TABELA: avaliacao | 10 registros
INSERT INTO avaliacao (id_avaliacao, id_agendamento, nota_cliente, comentario_cliente, nota_barbeiro, comentario_barbeiro) VALUES
    (1, 1, 5, 'Atendimento cordial e pontual.', 5, 'Cliente colaborativo durante o atendimento.'),
    (2, 2, 5, 'Atendimento cordial e pontual.', 4, 'Cliente colaborativo durante o atendimento.'),
    (3, 3, 4, 'Atendimento cordial e pontual.', 5, 'Cliente colaborativo durante o atendimento.'),
    (4, 4, 5, 'Atendimento cordial e pontual.', 4, 'Cliente colaborativo durante o atendimento.'),
    (5, 5, 5, 'Atendimento cordial e pontual.', 5, 'Cliente colaborativo durante o atendimento.'),
    (6, 6, 4, 'Atendimento cordial e pontual.', 4, 'Cliente colaborativo durante o atendimento.'),
    (7, 7, 5, 'Atendimento cordial e pontual.', 5, 'Cliente colaborativo durante o atendimento.'),
    (8, 8, 5, 'Atendimento cordial e pontual.', 4, 'Cliente colaborativo durante o atendimento.'),
    (9, 9, 4, 'Atendimento cordial e pontual.', 5, 'Cliente colaborativo durante o atendimento.'),
    (10, 10, 5, 'Atendimento cordial e pontual.', 4, 'Cliente colaborativo durante o atendimento.');

COMMIT;


-- ==========================================================================
-- ETAPA 08 | FINANCEIRO
-- Movimentos operacionais e transferencias sao inseridos apos contas e obrigacoes.
-- ==========================================================================
START TRANSACTION;

-- TABELA: categoria_financeira | 10 registros
INSERT INTO categoria_financeira (id_categoria_financeira, nome, tipo, ativo) VALUES
    (1, 'Receitas de Servicos', 'Entrada', 1),
    (2, 'Receitas de Produtos', 'Entrada', 1),
    (3, 'Compras de Mercadorias', 'Saida', 1),
    (4, 'Despesas com Pessoal', 'Saida', 1),
    (5, 'Transferencia Interna', 'Transferencia', 1),
    (6, 'Ajustes Positivos', 'Ajuste', 1),
    (7, 'Ajustes Negativos', 'Ajuste', 1),
    (8, 'Receitas de Tratamentos', 'Entrada', 1),
    (9, 'Despesas Administrativas', 'Saida', 1),
    (10, 'Receitas Diversas', 'Entrada', 1);

-- TABELA: conta_financeira | 10 registros
INSERT INTO conta_financeira (id_conta, cnpj_unidade, nome, tipo, saldo_inicial, data_saldo_inicial, ativo) VALUES
    (1, '99000000000001', 'Conta Caixa Unidade 1', 'Caixa', 1300.00, '2026-01-01', 1),
    (2, '99000000000002', 'Conta Caixa Unidade 2', 'Caixa', 1600.00, '2026-01-01', 1),
    (3, '99000000000003', 'Conta Caixa Unidade 3', 'Caixa', 1900.00, '2026-01-01', 1),
    (4, '99000000000004', 'Conta Caixa Unidade 4', 'Caixa', 2200.00, '2026-01-01', 1),
    (5, '99000000000001', 'Conta Banco Unidade 1', 'Banco', 2500.00, '2026-01-01', 1),
    (6, '99000000000002', 'Conta Banco Unidade 2', 'Banco', 2800.00, '2026-01-01', 1),
    (7, '99000000000003', 'Conta Banco Unidade 3', 'Banco', 3100.00, '2026-01-01', 1),
    (8, '99000000000004', 'Conta Banco Unidade 4', 'Banco', 3400.00, '2026-01-01', 1),
    (9, '99000000000001', 'Conta Reserva Unidade 1', 'Banco', 3700.00, '2026-01-01', 1),
    (10, '99000000000002', 'Conta Reserva Unidade 2', 'Banco', 4000.00, '2026-01-01', 1);

-- 5 contas a pagar ligadas a compras e 5 a receber ligadas a comandas.
-- TABELA: obrigacao_financeira | 10 registros
INSERT INTO obrigacao_financeira (id_obrigacao, cnpj_unidade, id_categoria_financeira, cpf_funcionario, cnpj_fornecedor, id_compra, id_comanda, tipo, descricao, valor_original, data_emissao, data_vencimento, cancelada) VALUES
    (1, '99000000000001', 3, NULL, '88000000000001', 1, NULL, 'Pagar', 'Pagamento da compra 1', 150.00, '2026-09-01', '2026-10-11', 0),
    (2, '99000000000002', 3, NULL, '88000000000002', 2, NULL, 'Pagar', 'Pagamento da compra 2', 186.00, '2026-09-02', '2026-10-12', 0),
    (3, '99000000000003', 3, NULL, '88000000000003', 3, NULL, 'Pagar', 'Pagamento da compra 3', 200.50, '2026-09-03', '2026-10-13', 0),
    (4, '99000000000004', 3, NULL, '88000000000004', 4, NULL, 'Pagar', 'Pagamento da compra 4', 268.00, '2026-09-04', '2026-10-14', 0),
    (5, '99000000000001', 3, NULL, '88000000000005', 5, NULL, 'Pagar', 'Pagamento da compra 5', 331.00, '2026-09-05', '2026-10-15', 0),
    (6, '99000000000001', 1, NULL, NULL, NULL, 1, 'Receber', 'Recebimento da comanda 1', 108.00, '2026-10-01', '2026-10-06', 0),
    (7, '99000000000002', 1, NULL, NULL, NULL, 2, 'Receber', 'Recebimento da comanda 2', 162.00, '2026-10-02', '2026-10-07', 0),
    (8, '99000000000003', 1, NULL, NULL, NULL, 3, 'Receber', 'Recebimento da comanda 3', 98.91, '2026-10-03', '2026-10-08', 0),
    (9, '99000000000004', 1, NULL, NULL, NULL, 4, 'Receber', 'Recebimento da comanda 4', 116.00, '2026-10-04', '2026-10-09', 0),
    (10, '99000000000001', 1, NULL, NULL, NULL, 5, 'Receber', 'Recebimento da comanda 5', 143.91, '2026-10-05', '2026-10-10', 0);

-- Transferencias apenas entre contas da mesma unidade.
-- TABELA: transferencia_financeira | 10 registros
INSERT INTO transferencia_financeira (id_transferencia, id_conta_origem, id_conta_destino, valor, data_transferencia) VALUES
    (1, 1, 5, 60.00, '2026-10-12 14:00:00'),
    (2, 5, 9, 70.00, '2026-10-13 14:00:00'),
    (3, 9, 1, 80.00, '2026-10-14 14:00:00'),
    (4, 2, 6, 90.00, '2026-10-15 14:00:00'),
    (5, 6, 10, 100.00, '2026-10-16 14:00:00'),
    (6, 10, 2, 110.00, '2026-10-17 14:00:00'),
    (7, 3, 7, 120.00, '2026-10-18 14:00:00'),
    (8, 7, 3, 130.00, '2026-10-19 14:00:00'),
    (9, 4, 8, 140.00, '2026-10-20 14:00:00'),
    (10, 8, 4, 150.00, '2026-10-21 14:00:00');

-- 20 movimentos de transferencia (2 por transferencia) + 10 quitacoes parciais + 6 avulsos.
-- TABELA: movimento_financeiro | 36 registros
INSERT INTO movimento_financeiro (id_movimentacao, id_categoria_financeira, id_conta, id_obrigacao, id_transferencia, valor, data_movimento, tipo, natureza, forma_pagamento, descricao) VALUES
    (1, 5, 1, NULL, 1, 60.00, '2026-10-12 14:00:00', 'Saida', 'Transferencia', 'Transferencia', 'Transferencia 1: origem'),
    (2, 5, 5, NULL, 1, 60.00, '2026-10-12 14:00:00', 'Entrada', 'Transferencia', 'Transferencia', 'Transferencia 1: destino'),
    (3, 5, 5, NULL, 2, 70.00, '2026-10-13 14:00:00', 'Saida', 'Transferencia', 'Transferencia', 'Transferencia 2: origem'),
    (4, 5, 9, NULL, 2, 70.00, '2026-10-13 14:00:00', 'Entrada', 'Transferencia', 'Transferencia', 'Transferencia 2: destino'),
    (5, 5, 9, NULL, 3, 80.00, '2026-10-14 14:00:00', 'Saida', 'Transferencia', 'Transferencia', 'Transferencia 3: origem'),
    (6, 5, 1, NULL, 3, 80.00, '2026-10-14 14:00:00', 'Entrada', 'Transferencia', 'Transferencia', 'Transferencia 3: destino'),
    (7, 5, 2, NULL, 4, 90.00, '2026-10-15 14:00:00', 'Saida', 'Transferencia', 'Transferencia', 'Transferencia 4: origem'),
    (8, 5, 6, NULL, 4, 90.00, '2026-10-15 14:00:00', 'Entrada', 'Transferencia', 'Transferencia', 'Transferencia 4: destino'),
    (9, 5, 6, NULL, 5, 100.00, '2026-10-16 14:00:00', 'Saida', 'Transferencia', 'Transferencia', 'Transferencia 5: origem'),
    (10, 5, 10, NULL, 5, 100.00, '2026-10-16 14:00:00', 'Entrada', 'Transferencia', 'Transferencia', 'Transferencia 5: destino'),
    (11, 5, 10, NULL, 6, 110.00, '2026-10-17 14:00:00', 'Saida', 'Transferencia', 'Transferencia', 'Transferencia 6: origem'),
    (12, 5, 2, NULL, 6, 110.00, '2026-10-17 14:00:00', 'Entrada', 'Transferencia', 'Transferencia', 'Transferencia 6: destino'),
    (13, 5, 3, NULL, 7, 120.00, '2026-10-18 14:00:00', 'Saida', 'Transferencia', 'Transferencia', 'Transferencia 7: origem'),
    (14, 5, 7, NULL, 7, 120.00, '2026-10-18 14:00:00', 'Entrada', 'Transferencia', 'Transferencia', 'Transferencia 7: destino'),
    (15, 5, 7, NULL, 8, 130.00, '2026-10-19 14:00:00', 'Saida', 'Transferencia', 'Transferencia', 'Transferencia 8: origem'),
    (16, 5, 3, NULL, 8, 130.00, '2026-10-19 14:00:00', 'Entrada', 'Transferencia', 'Transferencia', 'Transferencia 8: destino'),
    (17, 5, 4, NULL, 9, 140.00, '2026-10-20 14:00:00', 'Saida', 'Transferencia', 'Transferencia', 'Transferencia 9: origem'),
    (18, 5, 8, NULL, 9, 140.00, '2026-10-20 14:00:00', 'Entrada', 'Transferencia', 'Transferencia', 'Transferencia 9: destino'),
    (19, 5, 8, NULL, 10, 150.00, '2026-10-21 14:00:00', 'Saida', 'Transferencia', 'Transferencia', 'Transferencia 10: origem'),
    (20, 5, 4, NULL, 10, 150.00, '2026-10-21 14:00:00', 'Entrada', 'Transferencia', 'Transferencia', 'Transferencia 10: destino'),
    (21, 3, 1, 1, NULL, 75.00, '2026-10-11 11:00:00', 'Saida', 'Operacional', 'Pix', 'Quitacao parcial da obrigacao 1'),
    (22, 3, 2, 2, NULL, 93.00, '2026-10-12 11:00:00', 'Saida', 'Operacional', 'Pix', 'Quitacao parcial da obrigacao 2'),
    (23, 3, 3, 3, NULL, 100.25, '2026-10-13 11:00:00', 'Saida', 'Operacional', 'Pix', 'Quitacao parcial da obrigacao 3'),
    (24, 3, 4, 4, NULL, 134.00, '2026-10-14 11:00:00', 'Saida', 'Operacional', 'Pix', 'Quitacao parcial da obrigacao 4'),
    (25, 3, 1, 5, NULL, 165.50, '2026-10-15 11:00:00', 'Saida', 'Operacional', 'Pix', 'Quitacao parcial da obrigacao 5'),
    (26, 1, 1, 6, NULL, 54.00, '2026-10-16 11:00:00', 'Entrada', 'Operacional', 'Pix', 'Quitacao parcial da obrigacao 6'),
    (27, 1, 2, 7, NULL, 81.00, '2026-10-17 11:00:00', 'Entrada', 'Operacional', 'Pix', 'Quitacao parcial da obrigacao 7'),
    (28, 1, 3, 8, NULL, 49.46, '2026-10-18 11:00:00', 'Entrada', 'Operacional', 'Pix', 'Quitacao parcial da obrigacao 8'),
    (29, 1, 4, 9, NULL, 58.00, '2026-10-19 11:00:00', 'Entrada', 'Operacional', 'Pix', 'Quitacao parcial da obrigacao 9'),
    (30, 1, 1, 10, NULL, 71.96, '2026-10-20 11:00:00', 'Entrada', 'Operacional', 'Pix', 'Quitacao parcial da obrigacao 10'),
    (31, 10, 1, NULL, NULL, 25.00, '2026-10-16 15:00:00', 'Entrada', 'Operacional', 'Dinheiro', 'Lancamento operacional avulso 1'),
    (32, 9, 2, NULL, NULL, 30.00, '2026-10-17 15:00:00', 'Saida', 'Operacional', 'Dinheiro', 'Lancamento operacional avulso 2'),
    (33, 10, 3, NULL, NULL, 35.00, '2026-10-18 15:00:00', 'Entrada', 'Operacional', 'Dinheiro', 'Lancamento operacional avulso 3'),
    (34, 9, 4, NULL, NULL, 40.00, '2026-10-19 15:00:00', 'Saida', 'Operacional', 'Dinheiro', 'Lancamento operacional avulso 4'),
    (35, 10, 1, NULL, NULL, 45.00, '2026-10-20 15:00:00', 'Entrada', 'Operacional', 'Dinheiro', 'Lancamento operacional avulso 5'),
    (36, 9, 2, NULL, NULL, 50.00, '2026-10-21 15:00:00', 'Saida', 'Operacional', 'Dinheiro', 'Lancamento operacional avulso 6');

COMMIT;


-- ==========================================================================
-- ETAPA 09 | AUDITORIA
-- ==========================================================================
START TRANSACTION;

-- TABELA: registro_auditoria | 10 registros
INSERT INTO registro_auditoria (id_auditoria, cpf_usuario, data_hora, modulo, acao, entidade_afetada, id_registro_afetado, descricao, justificativa) VALUES
    (1, '90000000021', '2026-10-13 16:00:00.000000', 'Usuarios', 'INSERT', 'Registro', '1', 'Inclusao ficticia no modulo Usuarios.', 'Evidencia academica da carga 1.'),
    (2, '90000000021', '2026-10-14 16:00:00.000000', 'Unidades', 'INSERT', 'Registro', '2', 'Inclusao ficticia no modulo Unidades.', 'Evidencia academica da carga 2.'),
    (3, '90000000021', '2026-10-15 16:00:00.000000', 'Recursos_Humanos', 'INSERT', 'Registro', '3', 'Inclusao ficticia no modulo Recursos_Humanos.', 'Evidencia academica da carga 3.'),
    (4, '90000000021', '2026-10-16 16:00:00.000000', 'Clientes', 'INSERT', 'Registro', '4', 'Inclusao ficticia no modulo Clientes.', 'Evidencia academica da carga 4.'),
    (5, '90000000021', '2026-10-17 16:00:00.000000', 'Produtos', 'INSERT', 'Registro', '5', 'Inclusao ficticia no modulo Produtos.', 'Evidencia academica da carga 5.'),
    (6, '90000000021', '2026-10-18 16:00:00.000000', 'Agendamentos', 'INSERT', 'Registro', '6', 'Inclusao ficticia no modulo Agendamentos.', 'Evidencia academica da carga 6.'),
    (7, '90000000021', '2026-10-19 16:00:00.000000', 'Atendimentos', 'INSERT', 'Registro', '7', 'Inclusao ficticia no modulo Atendimentos.', 'Evidencia academica da carga 7.'),
    (8, '90000000021', '2026-10-20 16:00:00.000000', 'Tratamentos', 'INSERT', 'Registro', '8', 'Inclusao ficticia no modulo Tratamentos.', 'Evidencia academica da carga 8.'),
    (9, '90000000021', '2026-10-21 16:00:00.000000', 'Vendas', 'INSERT', 'Registro', '9', 'Inclusao ficticia no modulo Vendas.', 'Evidencia academica da carga 9.'),
    (10, '90000000021', '2026-10-22 16:00:00.000000', 'Financeiro', 'INSERT', 'Registro', '10', 'Inclusao ficticia no modulo Financeiro.', 'Evidencia academica da carga 10.');

-- TABELA: detalhe_auditoria | 10 registros
INSERT INTO detalhe_auditoria (id_detalhe, id_auditoria, atributo_alterado, valor_anterior, valor_novo) VALUES
    (1, 1, 'status', NULL, 'Cadastrado'),
    (2, 2, 'status', NULL, 'Cadastrado'),
    (3, 3, 'status', NULL, 'Cadastrado'),
    (4, 4, 'status', NULL, 'Cadastrado'),
    (5, 5, 'status', NULL, 'Cadastrado'),
    (6, 6, 'status', NULL, 'Cadastrado'),
    (7, 7, 'status', NULL, 'Cadastrado'),
    (8, 8, 'status', NULL, 'Cadastrado'),
    (9, 9, 'status', NULL, 'Cadastrado'),
    (10, 10, 'status', NULL, 'Cadastrado');

COMMIT;

