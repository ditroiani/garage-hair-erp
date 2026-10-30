-- ============================================================================
-- GARAGE HAIR ERP | 05 - CONSULTAS E INDICADORES DE BUSINESS INTELLIGENCE (BI)
-- Base: 01-estrutura.sql + 02-carga_dados.sql
-- ============================================================================

USE garage_hair_erp;

-- ============================================================================
-- PARTE A | VIEWS PARA ATRIBUTOS DERIVADOS
-- ============================================================================

-- VIEW 01: Valor total de cada compra = soma (quantidade * valor_unitario).
-- LEFT JOIN inclui compras sem itens; COALESCE troca resultado NULL por zero.
CREATE OR REPLACE VIEW vw_total_compra AS
SELECT
    c.id_compra,
    c.cnpj_unidade,
    c.cnpj_fornecedor,
    c.data_compra,
    c.status,
    COALESCE(SUM(ci.quantidade * ci.valor_unitario), 0) AS valor_total
FROM compra c
LEFT JOIN compra_item ci ON ci.id_compra = c.id_compra
GROUP BY c.id_compra, c.cnpj_unidade, c.cnpj_fornecedor, c.data_compra, c.status;

-- VIEW 02: Valor bruto dos itens, desconto aplicado e valor final da comanda.
-- subtotal e uma coluna VIRTUAL gerada em comanda_item.
-- cupom_utilizacao.id_comanda e UNIQUE: no maximo um cupom por comanda.
CREATE OR REPLACE VIEW vw_total_comanda AS
SELECT
    c.id_comanda,
    c.cnpj,
    c.cpf_cliente,
    c.data_fechamento,
    c.status,
    COALESCE(SUM(ci.subtotal), 0) AS valor_bruto,
    COALESCE(cu.valor_desconto_aplicado, 0) AS desconto,
    COALESCE(SUM(ci.subtotal), 0) - COALESCE(cu.valor_desconto_aplicado, 0) AS valor_total
FROM comanda c
LEFT JOIN comanda_item ci ON ci.id_comanda = c.id_comanda
LEFT JOIN cupom_utilizacao cu ON cu.id_comanda = c.id_comanda
GROUP BY c.id_comanda, c.cnpj, c.cpf_cliente, c.data_fechamento,
         c.status, cu.valor_desconto_aplicado;

-- VIEW 03: Saldo de cada conta = saldo inicial + entradas - saidas.
-- Considera somente os movimentos desde a data do saldo inicial.
-- Transferencias entram via movimentos de Entrada e Saida na conta correspondente.
CREATE OR REPLACE VIEW vw_saldo_conta AS
SELECT
    cf.id_conta,
    cf.cnpj_unidade,
    cf.nome AS conta,
    cf.saldo_inicial,
    cf.saldo_inicial + COALESCE(SUM(
        CASE
            WHEN mf.tipo = 'Entrada' THEN mf.valor
            WHEN mf.tipo = 'Saida' THEN -mf.valor
            ELSE 0
        END
    ), 0) AS saldo_atual
FROM conta_financeira cf
LEFT JOIN movimento_financeiro mf
    ON mf.id_conta = cf.id_conta
   AND mf.data_movimento >= cf.data_saldo_inicial
GROUP BY cf.id_conta, cf.cnpj_unidade, cf.nome, cf.saldo_inicial;

-- VIEW 04: Valor quitado e saldo pendente de obrigacoes financeiras.
-- Apenas movimentos operacionais no sentido esperado quitam obrigacoes:
-- Pagar -> Saida; Receber -> Entrada.
-- Cancelamento nao anula historicamente o valor; coluna cancelada permite filtrar.
CREATE OR REPLACE VIEW vw_saldo_obrigacao AS
SELECT
    q.id_obrigacao,
    q.cnpj_unidade,
    q.tipo,
    q.cancelada,
    q.data_vencimento,
    q.valor_original,
    q.valor_quitado,
    q.valor_original - q.valor_quitado AS saldo_pendente
FROM (
    SELECT
        o.id_obrigacao,
        o.cnpj_unidade,
        o.tipo,
        o.cancelada,
        o.data_vencimento,
        o.valor_original,
        COALESCE(SUM(
            CASE
                WHEN o.tipo = 'Pagar' AND mf.tipo = 'Saida'
                     AND mf.natureza = 'Operacional' THEN mf.valor
                WHEN o.tipo = 'Receber' AND mf.tipo = 'Entrada'
                     AND mf.natureza = 'Operacional' THEN mf.valor
                ELSE 0
            END
        ), 0) AS valor_quitado
    FROM obrigacao_financeira o
    LEFT JOIN movimento_financeiro mf ON mf.id_obrigacao = o.id_obrigacao
    GROUP BY o.id_obrigacao, o.cnpj_unidade, o.tipo, o.cancelada,
             o.data_vencimento, o.valor_original
) q;

-- ============================================================================
-- PARTE B | 35 CONSULTAS PRATICAS PARA RELATORIOS E INDICADORES
-- Sugestao: execute cada SELECT separadamente no MySQL Workbench.
-- ============================================================================

-- --------------------------------------------------------------------------
-- MODULO 01 | USUARIOS, UNIDADES E RECURSOS HUMANOS (CONSULTAS 01 A 05)
-- --------------------------------------------------------------------------

-- CONSULTA 01 | Clientes ativos (SELECT + INNER JOIN + ORDER BY).
SELECT u.nome AS cliente, u.email, u.telefone
FROM cliente c
INNER JOIN usuario u ON u.cpf = c.cpf
WHERE u.ativo = TRUE
ORDER BY u.nome;

-- CONSULTA 02 | Total de funcionarios cadastrados em cada unidade (COUNT).
SELECT un.nome AS unidade, COUNT(f.cpf) AS total_funcionarios
FROM unidade un
LEFT JOIN funcionario f ON f.cnpj = un.cnpj
GROUP BY un.cnpj, un.nome
ORDER BY total_funcionarios DESC;

-- CONSULTA 03 | Barbeiros e respectivas especialidades (JOIN).
SELECT u.nome AS barbeiro, e.nome AS especialidade
FROM especialidade_barbeiro eb
INNER JOIN usuario u ON u.cpf = eb.cpf
INNER JOIN especialidade e ON e.id_especialidade = eb.id_especialidade
ORDER BY u.nome, e.nome;

-- CONSULTA 04 | Horario regular de funcionamento das unidades.
-- fechado = TRUE significa que o horario cadastrado e apenas referencial.
SELECT un.nome AS unidade, hf.dia_semana, hf.hora_abertura, hf.hora_fechamento, hf.fechado
FROM horario_funcionamento hf
INNER JOIN unidade un ON un.cnpj = hf.cnpj
ORDER BY un.nome, hf.dia_semana;

-- CONSULTA 05 | Funcionarios de folga (podera retornar zero linhas).
SELECT u.nome AS funcionario, hf.dia_semana
FROM horario_funcionario hf
INNER JOIN usuario u ON u.cpf = hf.cpf
WHERE hf.folga = TRUE
ORDER BY u.nome, hf.dia_semana;

-- --------------------------------------------------------------------------
-- MODULO 02 | PRODUTOS, SERVICOS E COMBOS (CONSULTAS 06 A 10)
-- --------------------------------------------------------------------------

-- CONSULTA 06 | Produtos disponiveis e lucro unitario (coluna gerada).
SELECT nome AS produto, preco_custo, preco_venda, lucro_unitario
FROM produto
WHERE disponivel = TRUE
ORDER BY nome;

-- CONSULTA 07 | Quantidade de produtos por categoria.
SELECT cp.nome AS categoria, COUNT(p.id_produto) AS quantidade_produtos
FROM categoria_produto cp
LEFT JOIN produto p ON p.id_categoria_produto = cp.id_categoria_produto
GROUP BY cp.id_categoria_produto, cp.nome
ORDER BY quantidade_produtos DESC;

-- CONSULTA 08 | Servicos disponiveis ordenados pelo preco.
SELECT nome AS servico, duracao_estimada AS duracao_minutos, preco
FROM servico
WHERE disponivel = TRUE
ORDER BY preco DESC;

-- CONSULTA 09 | Combos disponiveis e seus precos.
SELECT nome AS combo, preco
FROM combo
WHERE ativo = TRUE
ORDER BY preco DESC;

-- CONSULTA 10 | Produtos que compoem os combos, com quantidades.
SELECT c.nome AS combo, p.nome AS produto, cp.quantidade
FROM combo_produto cp
INNER JOIN combo c ON c.id_combo = cp.id_combo
INNER JOIN produto p ON p.id_produto = cp.id_produto
ORDER BY c.nome, p.nome;

-- --------------------------------------------------------------------------
-- MODULOS 03 E 04 | MARKETING E AGENDAMENTOS (CONSULTAS 11 A 15)
-- --------------------------------------------------------------------------

-- CONSULTA 11 | Cupons vinculados as campanhas, com limite e uso.
SELECT ca.nome AS campanha, cu.codigo_cupom, cu.tipo_desconto,
       cu.valor_desconto, cu.quantidade_usada, cu.limite_usos
FROM cupom cu
INNER JOIN campanha ca ON ca.id_campanha = cu.id_campanha
ORDER BY ca.nome, cu.codigo_cupom;

-- CONSULTA 12 | Total de agendamentos por situacao.
SELECT status, COUNT(*) AS quantidade
FROM agendamento
GROUP BY status
ORDER BY quantidade DESC;

-- CONSULTA 13 | Agenda detalhada: cliente, barbeiro, data e status.
SELECT a.id_agendamento,
       uc.nome AS cliente, ub.nome AS barbeiro,
       a.data_hora, a.status
FROM agendamento a
INNER JOIN usuario uc ON uc.cpf = a.cpf_cliente
INNER JOIN usuario ub ON ub.cpf = a.cpf_barbeiro
ORDER BY a.data_hora;

-- CONSULTA 14 | Agendamentos por barbeiro (indicador de demanda).
SELECT u.nome AS barbeiro, COUNT(a.id_agendamento) AS total_agendamentos
FROM barbeiro b
INNER JOIN usuario u ON u.cpf = b.cpf
LEFT JOIN agendamento a ON a.cpf_barbeiro = b.cpf
GROUP BY b.cpf, u.nome
ORDER BY total_agendamentos DESC;

-- CONSULTA 15 | Servicos escolhidos em cada agendamento.
SELECT a.id_agendamento, s.nome AS servico, a.data_hora
FROM agendamento_servico ags
INNER JOIN agendamento a ON a.id_agendamento = ags.id_agendamento
INNER JOIN servico s ON s.id_servico = ags.id_servico
ORDER BY a.data_hora, s.nome;

-- --------------------------------------------------------------------------
-- MODULO 05 | TRATAMENTOS (CONSULTAS 16 A 18)
-- --------------------------------------------------------------------------

-- CONSULTA 16 | Tratamentos, clientes e situacao atual.
SELECT t.id_tratamento, u.nome AS cliente, tt.nome AS tratamento, t.status
FROM tratamento t
INNER JOIN usuario u ON u.cpf = t.cpf_cliente
INNER JOIN tipo_tratamento tt ON tt.id_tipo_tratamento = t.id_tipo_tratamento
ORDER BY t.id_tratamento;

-- CONSULTA 17 | Quantidade de tratamentos por status.
SELECT status, COUNT(*) AS quantidade
FROM tratamento
GROUP BY status
ORDER BY quantidade DESC;

-- CONSULTA 18 | Quantidade de fases cadastradas para cada tratamento.
SELECT t.id_tratamento, COUNT(ft.id_fase) AS total_fases
FROM tratamento t
LEFT JOIN fase_tratamento ft ON ft.id_tratamento = t.id_tratamento
GROUP BY t.id_tratamento
ORDER BY total_fases DESC;

-- --------------------------------------------------------------------------
-- MODULO 06 | COMPRAS, FORNECEDORES E ESTOQUE (CONSULTAS 19 A 23)
-- --------------------------------------------------------------------------

-- CONSULTA 19 | Compras com nome do fornecedor e total calculado pela VIEW.
SELECT c.id_compra, f.nome AS fornecedor, c.status, v.valor_total
FROM compra c
INNER JOIN fornecedor f ON f.cnpj = c.cnpj_fornecedor
INNER JOIN vw_total_compra v ON v.id_compra = c.id_compra
ORDER BY c.id_compra;

-- CONSULTA 20 | Total de compras por fornecedor (inclui compras pendentes).
SELECT f.nome AS fornecedor, COUNT(c.id_compra) AS numero_compras,
       COALESCE(SUM(v.valor_total), 0) AS total_comprado
FROM fornecedor f
LEFT JOIN compra c ON c.cnpj_fornecedor = f.cnpj
LEFT JOIN vw_total_compra v ON v.id_compra = c.id_compra
GROUP BY f.cnpj, f.nome
ORDER BY total_comprado DESC;

-- CONSULTA 21 | Posicao do estoque: unidade, produto e quantidades.
SELECT u.nome AS unidade, p.nome AS produto,
       e.quantidade_atual, e.quantidade_minima
FROM estoque_unidade e
INNER JOIN unidade u ON u.cnpj = e.cnpj
INNER JOIN produto p ON p.id_produto = e.id_produto
ORDER BY u.nome, p.nome;

-- CONSULTA 22 | Produtos com estoque igual ou abaixo do minimo.
-- E esperado que possa retornar zero linhas quando todos os saldos estao adequados.
SELECT u.nome AS unidade, p.nome AS produto, e.quantidade_atual, e.quantidade_minima
FROM estoque_unidade e
INNER JOIN unidade u ON u.cnpj = e.cnpj
INNER JOIN produto p ON p.id_produto = e.id_produto
WHERE e.quantidade_atual <= e.quantidade_minima
ORDER BY e.quantidade_atual;

-- CONSULTA 23 | Quantidade total de itens no estoque de cada unidade.
SELECT u.nome AS unidade, COALESCE(SUM(e.quantidade_atual), 0) AS unidades_em_estoque
FROM unidade u
LEFT JOIN estoque_unidade e ON e.cnpj = u.cnpj
GROUP BY u.cnpj, u.nome
ORDER BY unidades_em_estoque DESC;

-- --------------------------------------------------------------------------
-- MODULO 07 | ATENDIMENTOS, VENDAS, CUPONS E AVALIACOES (CONSULTAS 24 A 29)
-- --------------------------------------------------------------------------

-- CONSULTA 24 | Totais por comanda (bruto, desconto e liquido).
SELECT id_comanda, status, valor_bruto, desconto, valor_total
FROM vw_total_comanda
ORDER BY id_comanda;

-- CONSULTA 25 | Receita de comandas fechadas por unidade.
-- Nao inclui comandas abertas ou canceladas.
SELECT u.nome AS unidade, COUNT(v.id_comanda) AS comandas_fechadas,
       COALESCE(SUM(v.valor_total), 0) AS receita_comandas
FROM unidade u
LEFT JOIN vw_total_comanda v
    ON v.cnpj = u.cnpj AND v.status = 'Fechada'
GROUP BY u.cnpj, u.nome
ORDER BY receita_comandas DESC;

-- CONSULTA 26 | Produtos mais vendidos em comandas fechadas.
-- Nao conta componentes internos dos combos como vendas separadas.
SELECT p.nome AS produto, SUM(ci.quantidade) AS unidades_vendidas
FROM comanda_item ci
INNER JOIN comanda c ON c.id_comanda = ci.id_comanda
INNER JOIN produto p ON p.id_produto = ci.id_produto
WHERE c.status = 'Fechada'
GROUP BY p.id_produto, p.nome
ORDER BY unidades_vendidas DESC;

-- CONSULTA 27 | Servicos mais vendidos em comandas fechadas.
SELECT s.nome AS servico, SUM(ci.quantidade) AS vezes_vendido
FROM comanda_item ci
INNER JOIN comanda c ON c.id_comanda = ci.id_comanda
INNER JOIN servico s ON s.id_servico = ci.id_servico
WHERE c.status = 'Fechada'
GROUP BY s.id_servico, s.nome
ORDER BY vezes_vendido DESC;

-- CONSULTA 28 | Total de descontos aplicados por cupom.
SELECT cu.codigo_cupom, COUNT(util.id_utilizacao) AS utilizacoes,
       COALESCE(SUM(util.valor_desconto_aplicado), 0) AS total_descontos
FROM cupom cu
LEFT JOIN cupom_utilizacao util ON util.id_cupom = cu.id_cupom
GROUP BY cu.id_cupom, cu.codigo_cupom
ORDER BY total_descontos DESC;

-- CONSULTA 29 | Media das notas de avaliacao dadas pelos clientes.
-- AVG ignora notas NULL.
SELECT ROUND(AVG(nota_cliente), 2) AS media_avaliacao_cliente,
       COUNT(nota_cliente) AS avaliacoes_com_nota
FROM avaliacao;

-- --------------------------------------------------------------------------
-- MODULO 08 | FINANCEIRO (CONSULTAS 30 A 34)
-- --------------------------------------------------------------------------

-- CONSULTA 30 | Saldo de todas as contas (VIEW).
SELECT conta, saldo_inicial, saldo_atual
FROM vw_saldo_conta
ORDER BY saldo_atual DESC;

-- CONSULTA 31 | Saldo total por unidade, somando suas contas.
SELECT u.nome AS unidade, COALESCE(SUM(v.saldo_atual), 0) AS saldo_total
FROM unidade u
LEFT JOIN vw_saldo_conta v ON v.cnpj_unidade = u.cnpj
GROUP BY u.cnpj, u.nome
ORDER BY saldo_total DESC;

-- CONSULTA 32 | Entradas e saidas por conta (inclui transferencias).
SELECT cf.nome AS conta,
       COALESCE(SUM(CASE WHEN mf.tipo = 'Entrada' THEN mf.valor ELSE 0 END), 0) AS entradas,
       COALESCE(SUM(CASE WHEN mf.tipo = 'Saida' THEN mf.valor ELSE 0 END), 0) AS saidas
FROM conta_financeira cf
LEFT JOIN movimento_financeiro mf ON mf.id_conta = cf.id_conta
GROUP BY cf.id_conta, cf.nome
ORDER BY cf.nome;

-- CONSULTA 33 | Obrigacoes nao canceladas com saldo pendente.
SELECT id_obrigacao, tipo, valor_original, valor_quitado,
       saldo_pendente, data_vencimento
FROM vw_saldo_obrigacao
WHERE cancelada = FALSE AND saldo_pendente > 0
ORDER BY data_vencimento;

-- CONSULTA 34 | Transferencias financeiras entre contas.
SELECT tf.id_transferencia, origem.nome AS conta_origem,
       destino.nome AS conta_destino, tf.valor, tf.data_transferencia
FROM transferencia_financeira tf
INNER JOIN conta_financeira origem ON origem.id_conta = tf.id_conta_origem
INNER JOIN conta_financeira destino ON destino.id_conta = tf.id_conta_destino
ORDER BY tf.data_transferencia;

-- --------------------------------------------------------------------------
-- MODULO 09 | AUDITORIA (CONSULTA 35)
-- --------------------------------------------------------------------------

-- CONSULTA 35 | Quantidade de registros de auditoria por modulo.
SELECT modulo, COUNT(*) AS quantidade_registros
FROM registro_auditoria
GROUP BY modulo
ORDER BY quantidade_registros DESC, modulo;

-- ============================================================================
