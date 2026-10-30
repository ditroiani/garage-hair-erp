-- ============================================================================
-- GARAGE HAIR ERP | 03 - TESTES DE INTEGRIDADE
-- Base: 01-estrutura.sql + 02-carga_dados.sql
-- 45 TESTES | 5 POR MODULO
-- ============================================================================

USE garage_hair_erp;
START TRANSACTION;

-- ============================================================================
-- ETAPA 01 | USUARIOS, UNIDADES, RECURSOS HUMANOS E HORARIOS | 5 TESTES
-- ============================================================================

-- TESTE 01 | PRIMARY KEY | Repetir um usuario ja existente.
-- Esperado: 1062 (PRIMARY / CPF duplicado).
INSERT INTO usuario (cpf, nome, email, senha_hash, telefone, tipo, ativo)
SELECT cpf, nome, email, senha_hash, telefone, tipo, ativo
FROM usuario WHERE cpf = '90000000001';

-- TESTE 02 | UNIQUE | Repetir o e-mail de um usuario com outro CPF.
-- Esperado: 1062 (uk_usuario_email).
INSERT INTO usuario (cpf, nome, email, senha_hash, tipo)
SELECT '88888888881', 'Teste Email Duplicado', email, 'HASH_TESTE', 'Cliente'
FROM usuario WHERE cpf = '90000000001';

-- TESTE 03 | FOREIGN KEY | Barbeiro sem funcionario correspondente.
-- Esperado: 1452 (fk_barbeiro_funcionario).
INSERT INTO barbeiro (cpf) VALUES ('88888888882');

-- TESTE 04 | CHECK | Salario bruto negativo.
-- Esperado: 3819 (ck_funcionario_salario).
UPDATE funcionario SET salario_bruto = -1.00 LIMIT 1;

-- TESTE 05 | CHECK | Horario de funcionario com intervalo invertido.
-- Esperado: 3819 (ck_horario_funcionario_periodo).
UPDATE horario_funcionario
SET hora_inicio = '08:00:00', hora_inicio_intervalo = '14:00:00',
    hora_fim_intervalo = '13:00:00', hora_fim = '18:00:00'
LIMIT 1;

-- ============================================================================
-- ETAPA 02 | CATALOGO DE PRODUTOS, SERVICOS E COMBOS | 5 TESTES
-- ============================================================================

-- TESTE 06 | UNIQUE | Nome de categoria de produto duplicado.
-- Esperado: 1062 (uk_categoria_produto_nome).
INSERT INTO categoria_produto (nome)
SELECT nome FROM categoria_produto WHERE id_categoria_produto = 1;

-- TESTE 07 | CHECK | Produto com preco negativo.
-- Esperado: 3819 (ck_produto_precos).
UPDATE produto SET preco_venda = -0.01 WHERE id_produto = 1;

-- TESTE 08 | CHECK | Servico com duracao igual a zero.
-- Esperado: 3819 (ck_servico_duracao).
UPDATE servico SET duracao_estimada = 0 WHERE id_servico = 1;

-- TESTE 09 | CHECK | Combo com preco negativo.
-- Esperado: 3819 (ck_combo_preco).
UPDATE combo SET preco = -10.00 WHERE id_combo = 1;

-- TESTE 10 | CHECK | Produto de combo com quantidade igual a zero.
-- Esperado: 3819 (ck_combo_produto_qtd).
UPDATE combo_produto SET quantidade = 0 LIMIT 1;

-- ============================================================================
-- ETAPA 03 | CAMPANHAS E CUPONS | 5 TESTES
-- ============================================================================

-- TESTE 11 | CHECK | Campanha terminando antes de comecar.
-- Esperado: 3819 (ck_campanha_datas).
UPDATE campanha
SET data_inicio = '2026-12-31', data_fim = '2026-01-01'
WHERE id_campanha = 1;

-- TESTE 12 | CHECK | Cupom com tipo de desconto desconhecido.
-- Esperado: 3819 (ck_cupom_tipo).
UPDATE cupom SET tipo_desconto = 'Progressivo' WHERE id_cupom = 1;

-- TESTE 13 | CHECK | Cupom com valor de desconto igual a zero.
-- Esperado: 3819 (ck_cupom_valor).
UPDATE cupom SET valor_desconto = 0 WHERE id_cupom = 1;

-- TESTE 14 | CHECK | Cupom com limite de usos negativo.
-- Esperado: 3819 (ck_cupom_limites).
UPDATE cupom SET limite_usos = -1 WHERE id_cupom = 1;

-- TESTE 15 | UNIQUE | Codigo de cupom repetido.
-- Esperado: 1062 (uk_cupom_codigo).
INSERT INTO cupom (id_campanha, codigo_cupom, tipo_desconto, valor_desconto)
SELECT id_campanha, codigo_cupom, tipo_desconto, valor_desconto
FROM cupom WHERE id_cupom = 1;

-- ============================================================================
-- ETAPA 04 | AGENDAMENTOS | 5 TESTES
-- ============================================================================

-- TESTE 16 | FOREIGN KEY | Cliente inexistente em agendamento.
-- Esperado: 1452 (fk_ag_cliente).
UPDATE agendamento SET cpf_cliente = '88888888883' WHERE id_agendamento = 1;

-- TESTE 17 | FOREIGN KEY | Barbeiro inexistente em agendamento.
-- Esperado: 1452 (fk_ag_barbeiro).
UPDATE agendamento SET cpf_barbeiro = '88888888884' WHERE id_agendamento = 1;

-- TESTE 18 | CHECK | Duracao de agendamento igual a zero.
-- Esperado: 3819 (ck_ag_duracao).
UPDATE agendamento SET duracao_estimada = 0 WHERE id_agendamento = 1;

-- TESTE 19 | CHECK | Status de agendamento nao permitido.
-- Esperado: 3819 (ck_ag_status).
UPDATE agendamento SET status = 'Em andamento' WHERE id_agendamento = 1;

-- TESTE 20 | FOREIGN KEY | Associar agendamento a combo inexistente.
-- Esperado: 1452 (fk_agcombo_combo).
UPDATE agendamento_combo SET id_combo = 999999 LIMIT 1;

-- ============================================================================
-- ETAPA 05 | TRATAMENTOS E ACOMPANHAMENTO | 5 TESTES
-- ============================================================================

-- TESTE 21 | CHECK | Tratamento com status nao permitido.
-- Esperado: 3819 (ck_trat_status).
UPDATE tratamento SET status = 'Pausado' WHERE id_tratamento = 1;

-- TESTE 22 | CHECK | Tratamento cancelado sem motivo.
-- Esperado: 3819 (ck_trat_motivo).
UPDATE tratamento
SET status = 'Cancelado', motivo_cancelamento = NULL
WHERE id_tratamento = 1;

-- TESTE 23 | CHECK | Data final anterior ao inicio do tratamento.
-- Esperado: 3819 (ck_trat_datas).
UPDATE tratamento
SET data_inicio = '2026-10-20', data_fim = '2026-10-19'
WHERE id_tratamento = 1;

-- TESTE 24 | CHECK | Numero de fase menor que 1.
-- Esperado: 3819 (ck_fase_numero).
UPDATE fase_tratamento SET numero_fase = 0 WHERE id_fase = 1;

-- TESTE 25 | FOREIGN KEY | Foto associada a fase inexistente.
-- Esperado: 1452 (fk_foto_fase).
UPDATE foto_fase SET id_fase = 999999 WHERE id_foto = 1;

-- ============================================================================
-- ETAPA 06 | FORNECEDORES, COMPRAS E ESTOQUE | 5 TESTES
-- ============================================================================

-- TESTE 26 | CHECK | Fornecedor com CNPJ contendo letras.
-- Esperado: 3819 (ck_fornecedor_cnpj).
INSERT INTO fornecedor (cnpj, nome, logradouro, numero, complemento, bairro, cidade, estado, cep, tipo, ativo)
SELECT 'AB000000000001', nome, logradouro, numero, complemento,
       bairro, cidade, estado, cep, tipo, ativo
FROM fornecedor LIMIT 1;

-- TESTE 27 | CHECK | CEP de fornecedor invalido.
-- Esperado: 3819 (ck_fornecedor_cep).
UPDATE fornecedor SET cep = 'ABCDEFGH' LIMIT 1;

-- TESTE 28 | CHECK | Status de compra nao permitido.
-- Esperado: 3819 (ck_compra_status).
UPDATE compra SET status = 'Em transporte' WHERE id_compra = 1;

-- TESTE 29 | CHECK | Item de compra com quantidade zero.
-- Esperado: 3819 (ck_ci_quantidade).
UPDATE compra_item SET quantidade = 0 LIMIT 1;

-- TESTE 30 | CHECK | Estoque com quantidade negativa.
-- Esperado: 3819 (ck_estoque_quantidades).
UPDATE estoque_unidade SET quantidade_atual = -1 LIMIT 1;

-- ============================================================================
-- ETAPA 07 | ATENDIMENTOS, VENDAS, CUPONS E AVALIACOES | 5 TESTES
-- ============================================================================

-- TESTE 31 | CHECK | Status de comanda inexistente.
-- Esperado: 3819 (ck_comanda_status).
UPDATE comanda SET status = 'Estornada' WHERE id_comanda = 1;

-- TESTE 32 | CHECK | Item sem servico, produto, combo ou tratamento.
-- Esperado: 3819 (ck_item_exclusividade).
UPDATE comanda_item
SET id_servico = NULL, id_produto = NULL,
    id_combo = NULL, id_tratamento = NULL
WHERE id_item = 1;

-- TESTE 33 | CHECK | Item da comanda com quantidade zero.
-- Esperado: 3819 (ck_item_qtd).
UPDATE comanda_item SET quantidade = 0 WHERE id_item = 1;

-- TESTE 34 | CHECK | Valor de desconto aplicado negativo.
-- Esperado: 3819 (ck_cu_valor).
UPDATE cupom_utilizacao
SET valor_desconto_aplicado = -1.00 WHERE id_utilizacao = 1;

-- TESTE 35 | CHECK | Avaliacao do cliente fora do intervalo 1 a 5.
-- Esperado: 3819 (ck_nota_cliente).
UPDATE avaliacao SET nota_cliente = 6 WHERE id_avaliacao = 1;

-- ============================================================================
-- ETAPA 08 | FINANCEIRO | 5 TESTES
-- ============================================================================

-- TESTE 36 | CHECK | Categoria financeira com tipo desconhecido.
-- Esperado: 3819 (ck_categoria_financeira_tipo).
UPDATE categoria_financeira
SET tipo = 'Emprestimo' WHERE id_categoria_financeira = 1;

-- TESTE 37 | CHECK | Obrigacao simultaneamente ligada a compra e comanda.
-- Esperado: 3819 (ck_ob_origem).
UPDATE obrigacao_financeira
SET id_compra = 1, id_comanda = 1 WHERE id_obrigacao = 1;

-- TESTE 38 | CHECK | Transferencia para a propria conta.
-- Esperado: 3819 (ck_transfer_contas).
UPDATE transferencia_financeira
SET id_conta_destino = id_conta_origem WHERE id_transferencia = 1;

-- TESTE 39 | CHECK | Movimento com tipo nao permitido.
-- Esperado: 3819 (ck_mov_tipo).
UPDATE movimento_financeiro
SET tipo = 'Estorno' WHERE id_movimentacao = 1;

-- TESTE 40 | CHECK | Movimento de transferencia sem id_transferencia.
-- Esperado: 3819 (ck_mov_transfer).
UPDATE movimento_financeiro
SET natureza = 'Transferencia', id_transferencia = NULL
WHERE id_movimentacao = 1;

-- ============================================================================
-- ETAPA 09 | AUDITORIA | 5 TESTES
-- ============================================================================

-- TESTE 41 | CHECK | Modulo de auditoria nao permitido.
-- Esperado: 3819 (ck_auditoria_modulo).
UPDATE registro_auditoria
SET modulo = 'Modulo_Inexistente' WHERE id_auditoria = 1;

-- TESTE 42 | FOREIGN KEY | Registro de auditoria com usuario inexistente.
-- Esperado: 1452 (fk_registro_usuario).
UPDATE registro_auditoria
SET cpf_usuario = '88888888885' WHERE id_auditoria = 1;

-- TESTE 43 | NOT NULL | Acao de auditoria obrigatoria.
-- Esperado: 1048 (coluna acao nao admite NULL).
UPDATE registro_auditoria SET acao = NULL WHERE id_auditoria = 1;

-- TESTE 44 | FOREIGN KEY | Detalhe de auditoria sem registro principal.
-- Esperado: 1452 (fk_detalhe_auditoria).
UPDATE detalhe_auditoria SET id_auditoria = 999999 WHERE id_detalhe = 1;

-- TESTE 45 | NOT NULL | Atributo alterado e obrigatorio.
-- Esperado: 1048 (coluna atributo_alterado nao admite NULL).
UPDATE detalhe_auditoria
SET atributo_alterado = NULL WHERE id_detalhe = 1;

-- ============================================================================
-- ENCERRAMENTO | EXECUTAR ISOLADAMENTE APOS TODOS OS TESTES
-- ============================================================================
-- ROLLBACK desfaz alteracoes inesperadamente aceitas dentro da transacao.
ROLLBACK;

-- Conferencia opcional: os usuarios originais continuam cadastrados.
SELECT cpf, nome, email, tipo FROM usuario ORDER BY cpf LIMIT 5;
