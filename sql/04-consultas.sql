-- ============================================================================
-- GARAGE HAIR ERP | 04 - CONSULTAS SQL
-- Compativel com: 01-estrutura.sql + 02-carga_dados.sql
-- ============================================================================
USE garage_hair_erp;

-- ============================================================================
-- SECAO 01 | CONSULTAS SIMPLES
-- SELECT, WHERE, ORDER BY, LIMIT, LIKE, BETWEEN
-- ============================================================================

-- CONSULTA 01 | Usuarios ativos
SELECT cpf, nome, email, tipo FROM usuario WHERE ativo = TRUE ORDER BY nome;

-- CONSULTA 02 | Clientes cadastrados
SELECT cpf, data_nascimento FROM cliente ORDER BY data_nascimento;

-- CONSULTA 03 | Unidades ativas
SELECT cnpj, nome, cidade, estado FROM unidade WHERE ativo = TRUE ORDER BY nome;

-- CONSULTA 04 | Funcionarios barbeiros
SELECT cpf, matricula, cargo, salario_bruto FROM funcionario WHERE cargo = 'Barbeiro';

-- CONSULTA 05 | Categorias de produtos
SELECT id_categoria_produto, nome, ativo FROM categoria_produto ORDER BY nome;

-- CONSULTA 06 | Produtos disponiveis com lucro unitario calculado
SELECT id_produto, nome, preco_custo, preco_venda, lucro_unitario
FROM produto WHERE disponivel = TRUE ORDER BY nome;

-- CONSULTA 07 | Produtos em uma faixa de preco
SELECT nome, preco_venda FROM produto
WHERE preco_venda BETWEEN 20.00 AND 100.00 ORDER BY preco_venda;

-- CONSULTA 08 | Servicos com nome contendo 'Corte'
SELECT id_servico, nome, preco, duracao_estimada
FROM servico WHERE nome LIKE '%Corte%' ORDER BY nome;

-- CONSULTA 09 | Agendamentos confirmados
SELECT id_agendamento, cpf_cliente, cpf_barbeiro, data_hora
FROM agendamento WHERE status = 'Confirmado' ORDER BY data_hora;

-- CONSULTA 10 | Cinco compras mais recentes
SELECT id_compra, cnpj_fornecedor, data_compra, status
FROM compra ORDER BY data_compra DESC LIMIT 5;

-- ============================================================================
-- SECAO 02 | CONSULTAS COM RELACIONAMENTOS
-- INNER JOIN e LEFT JOIN
-- ============================================================================

-- CONSULTA 11 | Clientes e seus nomes de usuario
SELECT c.cpf, u.nome AS cliente, u.email, c.data_nascimento
FROM cliente c INNER JOIN usuario u ON u.cpf = c.cpf ORDER BY u.nome;

-- CONSULTA 12 | Funcionarios e suas unidades
SELECT u.nome AS funcionario, f.cargo, un.nome AS unidade
FROM funcionario f
INNER JOIN usuario u ON u.cpf = f.cpf
INNER JOIN unidade un ON un.cnpj = f.cnpj
ORDER BY un.nome, u.nome;

-- CONSULTA 13 | Especialidades dos barbeiros
SELECT u.nome AS barbeiro, e.nome AS especialidade
FROM especialidade_barbeiro eb
INNER JOIN barbeiro b ON b.cpf = eb.cpf
INNER JOIN usuario u ON u.cpf = b.cpf
INNER JOIN especialidade e ON e.id_especialidade = eb.id_especialidade
ORDER BY u.nome, e.nome;

-- CONSULTA 14 | Produtos e categorias
SELECT p.nome AS produto, cp.nome AS categoria, p.preco_venda
FROM produto p INNER JOIN categoria_produto cp
ON cp.id_categoria_produto = p.id_categoria_produto
ORDER BY cp.nome, p.nome;

-- CONSULTA 15 | Servicos presentes nos combos
SELECT cb.nome AS combo, s.nome AS servico
FROM combo_servico cs
INNER JOIN combo cb ON cb.id_combo = cs.id_combo
INNER JOIN servico s ON s.id_servico = cs.id_servico
ORDER BY cb.nome, s.nome;

-- CONSULTA 16 | Agendamentos com cliente e barbeiro
SELECT a.id_agendamento, uc.nome AS cliente, ub.nome AS barbeiro,
       a.data_hora, a.status
FROM agendamento a
INNER JOIN usuario uc ON uc.cpf = a.cpf_cliente
INNER JOIN usuario ub ON ub.cpf = a.cpf_barbeiro
ORDER BY a.data_hora;

-- CONSULTA 17 | Tratamentos e seus tipos
SELECT t.id_tratamento, u.nome AS cliente, tt.nome AS tratamento, t.status
FROM tratamento t
INNER JOIN usuario u ON u.cpf = t.cpf_cliente
INNER JOIN tipo_tratamento tt ON tt.id_tipo_tratamento = t.id_tipo_tratamento
ORDER BY t.id_tratamento;

-- CONSULTA 18 | Compras e nomes dos fornecedores
SELECT c.id_compra, f.nome AS fornecedor, c.data_compra, c.status
FROM compra c INNER JOIN fornecedor f ON f.cnpj = c.cnpj_fornecedor
ORDER BY c.data_compra DESC;

-- CONSULTA 19 | Estoque por produto e unidade
SELECT un.nome AS unidade, p.nome AS produto,
       eu.quantidade_atual, eu.quantidade_minima
FROM estoque_unidade eu
INNER JOIN unidade un ON un.cnpj = eu.cnpj
INNER JOIN produto p ON p.id_produto = eu.id_produto
ORDER BY un.nome, p.nome;

-- CONSULTA 20 | Comandas e clientes (LEFT JOIN inclui venda sem cliente)
SELECT c.id_comanda, u.nome AS cliente, c.status, c.data_fechamento
FROM comanda c LEFT JOIN usuario u ON u.cpf = c.cpf_cliente
ORDER BY c.id_comanda;

-- ============================================================================
-- SECAO 03 | CONTAGENS E SOMA
-- COUNT, SUM, AVG, MIN, MAX, GROUP BY
-- ============================================================================

-- CONSULTA 21 | Quantidade de usuarios por tipo
SELECT tipo, COUNT(*) AS quantidade FROM usuario GROUP BY tipo;

-- CONSULTA 22 | Funcionarios por cargo
SELECT cargo, COUNT(*) AS quantidade FROM funcionario GROUP BY cargo;

-- CONSULTA 23 | Produtos por categoria
SELECT cp.nome AS categoria, COUNT(p.id_produto) AS total_produtos
FROM categoria_produto cp
LEFT JOIN produto p ON p.id_categoria_produto = cp.id_categoria_produto
GROUP BY cp.id_categoria_produto, cp.nome ORDER BY total_produtos DESC;

-- CONSULTA 24 | Preco medio dos produtos
SELECT ROUND(AVG(preco_venda), 2) AS preco_medio FROM produto;

-- CONSULTA 25 | Menor e maior preco dos servicos
SELECT MIN(preco) AS menor_preco, MAX(preco) AS maior_preco FROM servico;

-- CONSULTA 26 | Agendamentos agrupados por status
SELECT status, COUNT(*) AS quantidade FROM agendamento GROUP BY status;

-- CONSULTA 27 | Quantidade de tratamentos por status
SELECT status, COUNT(*) AS quantidade FROM tratamento GROUP BY status;

-- CONSULTA 28 | Itens de cada compra (quantidade e custo total)
SELECT c.id_compra, COALESCE(SUM(ci.quantidade), 0) AS total_unidades,
       COALESCE(SUM(ci.quantidade * ci.valor_unitario), 0) AS valor_compra
FROM compra c LEFT JOIN compra_item ci ON ci.id_compra = c.id_compra
GROUP BY c.id_compra ORDER BY c.id_compra;

-- CONSULTA 29 | Quantidade total em estoque por unidade
SELECT un.nome AS unidade, COALESCE(SUM(eu.quantidade_atual), 0) AS total_unidades_estoque
FROM unidade un LEFT JOIN estoque_unidade eu ON eu.cnpj = un.cnpj
GROUP BY un.cnpj, un.nome ORDER BY un.nome;

-- CONSULTA 30 | Valor bruto dos itens por comanda
SELECT c.id_comanda, COALESCE(SUM(ci.subtotal), 0) AS valor_bruto
FROM comanda c LEFT JOIN comanda_item ci ON ci.id_comanda = c.id_comanda
GROUP BY c.id_comanda ORDER BY c.id_comanda;

-- ============================================================================
-- SECAO 04 | CONSULTAS INTERMEDIARIAS
-- HAVING, CASE, IS NULL, subconsulta
-- ============================================================================

-- CONSULTA 31 | Produtos abaixo do estoque minimo
SELECT un.nome AS unidade, p.nome AS produto,
       eu.quantidade_atual, eu.quantidade_minima
FROM estoque_unidade eu
INNER JOIN unidade un ON un.cnpj = eu.cnpj
INNER JOIN produto p ON p.id_produto = eu.id_produto
WHERE eu.quantidade_atual < eu.quantidade_minima
ORDER BY un.nome, p.nome;

-- CONSULTA 32 | Categorias com pelo menos dois produtos
SELECT cp.nome AS categoria, COUNT(p.id_produto) AS total_produtos
FROM categoria_produto cp
INNER JOIN produto p ON p.id_categoria_produto = cp.id_categoria_produto
GROUP BY cp.id_categoria_produto, cp.nome
HAVING COUNT(p.id_produto) >= 2 ORDER BY total_produtos DESC;

-- CONSULTA 33 | Situacao simplificada do estoque
SELECT p.nome AS produto, eu.quantidade_atual, eu.quantidade_minima,
       CASE WHEN eu.quantidade_atual < eu.quantidade_minima
            THEN 'Reposicao necessaria' ELSE 'Estoque suficiente' END AS situacao
FROM estoque_unidade eu
INNER JOIN produto p ON p.id_produto = eu.id_produto
ORDER BY p.nome;

-- CONSULTA 34 | Produtos com preco acima da media de venda
SELECT nome, preco_venda FROM produto
WHERE preco_venda > (SELECT AVG(preco_venda) FROM produto)
ORDER BY preco_venda DESC;

-- CONSULTA 35 | Compras ainda sem data de recebimento
SELECT id_compra, data_compra, status
FROM compra WHERE data_recebimento IS NULL ORDER BY data_compra;

-- ============================================================================
-- SECAO 05 | VIEWS - CONSULTAS REUTILIZAVEIS
-- ============================================================================

-- VIEW 01 | Total de cada compra, inclusive compras sem itens
CREATE OR REPLACE VIEW vw_total_compra AS
SELECT c.id_compra,
       COALESCE(SUM(ci.quantidade * ci.valor_unitario), 0) AS valor_total
FROM compra c
LEFT JOIN compra_item ci ON ci.id_compra = c.id_compra
GROUP BY c.id_compra;

-- VIEW 02 | Total da comanda apos o desconto efetivamente registrado
-- Ha no maximo um cupom_utilizacao por comanda (UNIQUE em id_comanda).
CREATE OR REPLACE VIEW vw_total_comanda AS
SELECT c.id_comanda,
       COALESCE(SUM(ci.subtotal), 0) AS valor_bruto,
       COALESCE(cu.valor_desconto_aplicado, 0) AS desconto,
       COALESCE(SUM(ci.subtotal), 0) - COALESCE(cu.valor_desconto_aplicado, 0) AS valor_total
FROM comanda c
LEFT JOIN comanda_item ci ON ci.id_comanda = c.id_comanda
LEFT JOIN cupom_utilizacao cu ON cu.id_comanda = c.id_comanda
GROUP BY c.id_comanda, cu.valor_desconto_aplicado;

-- VIEW 03 | Saldo de cada conta: saldo inicial + entradas - saidas
-- Considera movimentos desde a data informada para o saldo inicial.
CREATE OR REPLACE VIEW vw_saldo_conta AS
SELECT cf.id_conta, cf.nome AS conta, cf.saldo_inicial,
       cf.saldo_inicial + COALESCE(SUM(
           CASE WHEN mf.tipo = 'Entrada' THEN mf.valor
                WHEN mf.tipo = 'Saida' THEN -mf.valor
                ELSE 0 END
       ), 0) AS saldo_atual
FROM conta_financeira cf
LEFT JOIN movimento_financeiro mf
    ON mf.id_conta = cf.id_conta
    AND mf.data_movimento >= cf.data_saldo_inicial
GROUP BY cf.id_conta, cf.nome, cf.saldo_inicial;

-- VIEW 04 | Valor quitado e saldo pendente por obrigacao
-- Pagamentos (Saida) quitam 'Pagar'; recebimentos (Entrada) quitam 'Receber'.
-- Considera apenas movimentos operacionais: estornos e cancelamentos exigem
-- tratamento especifico que nao faz parte desta demonstracao basica.
CREATE OR REPLACE VIEW vw_saldo_obrigacao AS
SELECT o.id_obrigacao, o.tipo, o.valor_original, o.cancelada,
       COALESCE(SUM(CASE
           WHEN o.tipo = 'Pagar' AND mf.tipo = 'Saida' AND mf.natureza = 'Operacional' THEN mf.valor
           WHEN o.tipo = 'Receber' AND mf.tipo = 'Entrada' AND mf.natureza = 'Operacional' THEN mf.valor
           ELSE 0 END), 0) AS valor_quitado,
       o.valor_original - COALESCE(SUM(CASE
           WHEN o.tipo = 'Pagar' AND mf.tipo = 'Saida' AND mf.natureza = 'Operacional' THEN mf.valor
           WHEN o.tipo = 'Receber' AND mf.tipo = 'Entrada' AND mf.natureza = 'Operacional' THEN mf.valor
           ELSE 0 END), 0) AS saldo_pendente
FROM obrigacao_financeira o
LEFT JOIN movimento_financeiro mf ON mf.id_obrigacao = o.id_obrigacao
GROUP BY o.id_obrigacao, o.tipo, o.valor_original, o.cancelada;

-- ============================================================================
-- SECAO 06 | EXEMPLOS PRATICOS DE USO DAS VIEWS
-- ============================================================================
-- Consulta os totais de compras
SELECT * FROM vw_total_compra ORDER BY id_compra;

-- Consulta as comandas de maior valor final
SELECT * FROM vw_total_comanda ORDER BY valor_total DESC;

-- Consulta os saldos das contas
SELECT * FROM vw_saldo_conta ORDER BY conta;

-- Consulta obrigacoes nao canceladas com valor pendente
SELECT * FROM vw_saldo_obrigacao
WHERE cancelada = FALSE AND saldo_pendente > 0 ORDER BY saldo_pendente DESC;

-- ============================================================================
-- FIM DO ARQUIVO | 35 CONSULTAS + 4 VIEWS + 4 CONSULTA AS VIEWS
-- ============================================================================
