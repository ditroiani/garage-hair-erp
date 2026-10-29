-- ============================================================================
-- GARAGE HAIR ERP | MODELO FISICO MYSQL
-- Base: Modelo Logico final e Dicionario de Dados do Garage Hair.
-- 43 tabelas
-- ============================================================================

-- Inicialização da Base(executar uma unica vez) ========== 
CREATE DATABASE IF NOT EXISTS garage_hair_erp
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE garage_hair_erp;

-- ========== ETAPA 01 | ESTRUTURA E RECURSOS HUMANOS ========== 
-- TABELA: usuario
CREATE TABLE usuario (
  cpf CHAR(11) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  telefone VARCHAR(15) NULL,
  tipo VARCHAR(30) NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (cpf),
  UNIQUE KEY uk_usuario_email (email),
  CONSTRAINT ck_usuario_cpf CHECK (cpf REGEXP '^[0-9]{11}$'),
  CONSTRAINT ck_usuario_tipo CHECK (tipo IN ('Cliente','Funcionario'))
);

-- TABELA: unidade
CREATE TABLE unidade (
  cnpj CHAR(14) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  logradouro VARCHAR(150) NOT NULL,
  numero VARCHAR(10) NOT NULL,
  complemento VARCHAR(30),
  bairro VARCHAR(50) NOT NULL,
  cidade VARCHAR(50) NOT NULL,
  estado CHAR(2) NOT NULL,
  cep CHAR(8) NOT NULL,
  telefone VARCHAR(15),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (cnpj),
  CONSTRAINT ck_unidade_cnpj CHECK (cnpj REGEXP '^[0-9]{14}$'),
  CONSTRAINT ck_unidade_cep CHECK (cep REGEXP '^[0-9]{8}$')
);

-- TABELA: cliente
CREATE TABLE cliente (
  cpf CHAR(11) NOT NULL,
  data_nascimento DATE NOT NULL,
  observacoes_gerais TEXT,
  observacoes_internas TEXT,
  PRIMARY KEY (cpf),
  CONSTRAINT fk_cliente_usuario FOREIGN KEY (cpf) REFERENCES usuario (cpf)
);

-- TABELA: funcionario
CREATE TABLE funcionario (
  cpf CHAR(11) NOT NULL,
  cnpj CHAR(14) NOT NULL,
  matricula VARCHAR(20) NOT NULL,
  cargo VARCHAR(50) NOT NULL,
  data_admissao DATE NOT NULL,
  salario_bruto DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (cpf),
  UNIQUE KEY uk_funcionario_matricula (matricula),
  CONSTRAINT fk_funcionario_usuario FOREIGN KEY (cpf) REFERENCES usuario (cpf),
  CONSTRAINT fk_funcionario_unidade FOREIGN KEY (cnpj) REFERENCES unidade (cnpj),
  CHECK (cargo IN (
    'Barbeiro',
    'Gestor',
    'Recepcionista',
    'Auxiliar'
	)),
  CONSTRAINT ck_funcionario_salario CHECK (salario_bruto >= 0)
);

-- TABELA: barbeiro
CREATE TABLE barbeiro (
  cpf CHAR(11) NOT NULL,
  PRIMARY KEY (cpf),
  CONSTRAINT fk_barbeiro_funcionario FOREIGN KEY (cpf) REFERENCES funcionario (cpf)
);

-- TABELA: especialidade
CREATE TABLE especialidade (
  id_especialidade INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_especialidade),
  UNIQUE KEY uk_especialidade_nome (nome),
  CONSTRAINT ck_especialidade_nome
        CHECK (nome IN (
            'Corte Masculino',
            'Corte Feminino',
            'Corte Infantil',
            'Barba',
            'Barboterapia',
            'Tingimento',
            'Descoloração',
            'Tratamento Capilar',
            'Penteados'
        ))
);

-- TABELA ASSOCIATIVA: especialidade_barbeiro
CREATE TABLE especialidade_barbeiro (
  id_especialidade INT NOT NULL,
  cpf CHAR(11) NOT NULL,
  descricao VARCHAR(200),
  PRIMARY KEY (id_especialidade, cpf),
  CONSTRAINT fk_esp_bar_especialidade FOREIGN KEY (id_especialidade) REFERENCES especialidade (id_especialidade),
  CONSTRAINT fk_esp_bar_barbeiro FOREIGN KEY (cpf) REFERENCES barbeiro (cpf)
);

-- TABELA: horario_funcionamento
CREATE TABLE horario_funcionamento (
  cnpj CHAR(14) NOT NULL,
  dia_semana VARCHAR(15) NOT NULL,
  hora_abertura TIME NOT NULL,
  hora_fechamento TIME NOT NULL,
  fechado BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (cnpj, dia_semana),
  CONSTRAINT fk_hor_func_unidade FOREIGN KEY (cnpj) REFERENCES unidade (cnpj),
  CONSTRAINT ck_hor_func_dia CHECK (dia_semana IN ('Segunda','Terca','Quarta','Quinta','Sexta','Sabado','Domingo')),
  CONSTRAINT ck_hor_func_periodo
    CHECK (hora_abertura < hora_fechamento)
);

-- TABELA: horario_funcionario
CREATE TABLE horario_funcionario (
  cpf CHAR(11) NOT NULL,
  dia_semana VARCHAR(15) NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  hora_inicio_intervalo TIME NOT NULL,
  hora_fim_intervalo TIME NOT NULL,
  folga BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (cpf, dia_semana),
  CONSTRAINT fk_horario_funcionario FOREIGN KEY (cpf) REFERENCES funcionario (cpf),
  CONSTRAINT ck_horario_funcionario_dia CHECK (dia_semana IN ('Segunda','Terca','Quarta','Quinta','Sexta','Sabado','Domingo')),
  CONSTRAINT ck_horario_funcionario_periodo
	CHECK (
		hora_inicio < hora_inicio_intervalo
		AND hora_inicio_intervalo < hora_fim_intervalo
		AND hora_fim_intervalo < hora_fim
	)
);

-- ========== ETAPA 02 | CATALOGO DE PRODUTOS, SERVICOS E COMBOS ========== 
-- TABELA: categoria_produto
CREATE TABLE categoria_produto (
  id_categoria_produto INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL,
  descricao TEXT,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_categoria_produto),
  UNIQUE KEY uk_categoria_produto_nome (nome)
);

-- TABELA: produto
CREATE TABLE produto (
  id_produto INT NOT NULL AUTO_INCREMENT,
  id_categoria_produto INT NOT NULL,
  codigo_interno VARCHAR(50) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  data_validade DATE,
  preco_custo DECIMAL(8,2) NOT NULL,
  preco_venda DECIMAL(8,2) NOT NULL,
  disponivel BOOLEAN NOT NULL DEFAULT TRUE,
  -- Atributo derivado
   lucro_unitario DECIMAL(12,2)
        GENERATED ALWAYS AS (
            preco_venda - preco_custo
        ) VIRTUAL,
  PRIMARY KEY (id_produto),
  UNIQUE KEY uk_produto_codigo (codigo_interno),
  UNIQUE KEY uk_produto_nome (nome),
  CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria_produto) REFERENCES categoria_produto (id_categoria_produto),
  CONSTRAINT ck_produto_precos CHECK (preco_custo >= 0 AND preco_venda >= 0)
);

-- TABELA: foto_produto
CREATE TABLE foto_produto (
  id_foto INT NOT NULL AUTO_INCREMENT,
  id_produto INT NOT NULL,
  url_foto VARCHAR(255) NOT NULL,
  legenda VARCHAR(100),
  PRIMARY KEY (id_foto),
  CONSTRAINT fk_foto_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
);

-- TABELA: servico
CREATE TABLE servico (
  id_servico INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  duracao_estimada INT NOT NULL,
  preco DECIMAL(8,2) NOT NULL,
  descricao TEXT,
  disponivel BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_servico),
  UNIQUE KEY uk_servico_nome (nome),
  CONSTRAINT ck_servico_duracao CHECK (duracao_estimada > 0),
  CONSTRAINT ck_servico_preco CHECK (preco >= 0)
);

-- TABELA: combo
CREATE TABLE combo (
  id_combo INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  preco DECIMAL(8,2) NOT NULL,
  descricao TEXT,
  ativo BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (id_combo),
  UNIQUE KEY uk_combo_nome (nome),
  CONSTRAINT ck_combo_preco CHECK (preco >= 0)
);

-- TABELA ASSOCIATIVA: combo_servico
CREATE TABLE combo_servico (
  id_combo INT NOT NULL,
  id_servico INT NOT NULL,
  PRIMARY KEY (id_combo, id_servico),
  CONSTRAINT fk_combo_servico_combo FOREIGN KEY (id_combo) REFERENCES combo (id_combo),
  CONSTRAINT fk_combo_servico_servico FOREIGN KEY (id_servico) REFERENCES servico (id_servico)
);

-- TABELA ASSOCIATIVA: combo_produto
CREATE TABLE combo_produto (
  id_combo INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  PRIMARY KEY (id_combo, id_produto),
  CONSTRAINT fk_combo_produto_combo FOREIGN KEY (id_combo) REFERENCES combo (id_combo),
  CONSTRAINT fk_combo_produto_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto),
  CONSTRAINT ck_combo_produto_qtd CHECK (quantidade > 0)
);

-- ========== ETAPA 03 | CAMPANHAS E CUPONS ========== 
-- TABELA: campanha
CREATE TABLE campanha (
  id_campanha INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  tipo VARCHAR(30) NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  descricao TEXT,
  ativo BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (id_campanha),
  UNIQUE KEY uk_campanha_nome (nome),
  CONSTRAINT ck_campanha_datas CHECK (data_fim >= data_inicio)
);

-- TABELA: cupom
CREATE TABLE cupom (
  id_cupom INT NOT NULL AUTO_INCREMENT,
  id_campanha INT NOT NULL,
  codigo_cupom VARCHAR(20) NOT NULL,
  tipo_desconto VARCHAR(20) NOT NULL,
  valor_desconto DECIMAL(8,2) NOT NULL,
  limite_usos INT,
  limite_usos_cliente INT,
  quantidade_usada INT NOT NULL DEFAULT 0,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_cupom),
  UNIQUE KEY uk_cupom_codigo (codigo_cupom),
  CONSTRAINT fk_cupom_campanha FOREIGN KEY (id_campanha) REFERENCES campanha (id_campanha),
  CONSTRAINT ck_cupom_tipo CHECK (tipo_desconto IN ('Percentual','Fixo')),
  CONSTRAINT ck_cupom_valor CHECK (valor_desconto > 0),
  CONSTRAINT ck_cupom_limites CHECK (limite_usos IS NULL OR limite_usos > 0),
  CONSTRAINT ck_cupom_limite_cliente CHECK (limite_usos_cliente IS NULL OR limite_usos_cliente > 0),
  CONSTRAINT ck_cupom_utilizacoes CHECK (quantidade_usada >= 0)
);

-- ========== ETAPA 04 | AGENDAMENTO ========== 
-- TABELA: agendamento
CREATE TABLE agendamento (
  id_agendamento INT NOT NULL AUTO_INCREMENT,
  cpf_cliente CHAR(11) NOT NULL,
  cpf_barbeiro CHAR(11) NOT NULL,
  id_cupom INT,
  data_hora DATETIME NOT NULL,
  duracao_estimada INT NOT NULL,
  status VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_agendamento),
  INDEX idx_ag_barbeiro_horario (cpf_barbeiro, data_hora),
  CONSTRAINT fk_ag_cliente FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
  CONSTRAINT fk_ag_barbeiro FOREIGN KEY (cpf_barbeiro) REFERENCES barbeiro (cpf),
  CONSTRAINT fk_ag_cupom FOREIGN KEY (id_cupom) REFERENCES cupom (id_cupom),
  CONSTRAINT ck_ag_duracao CHECK (duracao_estimada > 0),
  CONSTRAINT ck_ag_status CHECK (status IN ('Confirmado','Cancelado','Concluido'))
);

-- TABELA ASSOCIATIVA: agendamento_combo
CREATE TABLE agendamento_combo (
  id_agendamento INT NOT NULL,
  id_combo INT NOT NULL,
  observacao VARCHAR(255),
  PRIMARY KEY (id_agendamento, id_combo),
  CONSTRAINT fk_agcombo_ag FOREIGN KEY (id_agendamento) REFERENCES agendamento (id_agendamento),
  CONSTRAINT fk_agcombo_combo FOREIGN KEY (id_combo) REFERENCES combo (id_combo)
);

-- TABELA ASSOCIATIVA: agendamento_servico
CREATE TABLE agendamento_servico (
  id_agendamento INT NOT NULL,
  id_servico INT NOT NULL,
  observacao VARCHAR(255),
  PRIMARY KEY (id_agendamento, id_servico),
  CONSTRAINT fk_agserv_ag FOREIGN KEY (id_agendamento) REFERENCES agendamento (id_agendamento),
  CONSTRAINT fk_agserv_servico FOREIGN KEY (id_servico) REFERENCES servico (id_servico)
);

-- ========== ETAPA 05 | TRATAMENTOS ========== 
-- TABELA: tipo_tratamento
CREATE TABLE tipo_tratamento (
  id_tipo_tratamento INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_tipo_tratamento),
  UNIQUE KEY uk_tipo_tratamento_nome (nome)
);

-- TABELA: tratamento
CREATE TABLE tratamento (
  id_tratamento INT NOT NULL AUTO_INCREMENT,
  cpf_cliente CHAR(11) NOT NULL,
  cpf_barbeiro CHAR(11) NOT NULL,
  id_tipo_tratamento INT NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE,
  status VARCHAR(20) NOT NULL,
  motivo_cancelamento TEXT,
  objetivo TEXT,
  PRIMARY KEY (id_tratamento),
  CONSTRAINT fk_trat_cliente FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
  CONSTRAINT fk_trat_barbeiro FOREIGN KEY (cpf_barbeiro) REFERENCES barbeiro (cpf),
  CONSTRAINT fk_trat_tipo FOREIGN KEY (id_tipo_tratamento) REFERENCES tipo_tratamento (id_tipo_tratamento),
  CONSTRAINT ck_trat_status CHECK (status IN ('Ativo','Concluido','Cancelado')),
  CONSTRAINT ck_trat_motivo CHECK (status <> 'Cancelado' OR motivo_cancelamento IS NOT NULL),
  CONSTRAINT ck_trat_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio)
);

-- TABELA: fase_tratamento
CREATE TABLE fase_tratamento (
  id_fase INT NOT NULL AUTO_INCREMENT,
  id_tratamento INT NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  data DATE NOT NULL,
  numero_fase INT NOT NULL,
  descricao TEXT,
  observacoes_barbeiro TEXT,
  observacoes_cliente TEXT,
  PRIMARY KEY (id_fase),
  UNIQUE KEY uk_fase_numero (id_tratamento, numero_fase),
  CONSTRAINT fk_fase_tratamento FOREIGN KEY (id_tratamento) REFERENCES tratamento (id_tratamento),
  CONSTRAINT ck_fase_numero CHECK (numero_fase > 0)
);

-- TABELA: foto_fase
CREATE TABLE foto_fase (
  id_foto INT NOT NULL AUTO_INCREMENT,
  id_fase INT NOT NULL,
  url_foto VARCHAR(255) NOT NULL,
  legenda VARCHAR(100),
  data_foto DATE NOT NULL,
  PRIMARY KEY (id_foto),
  CONSTRAINT fk_foto_fase FOREIGN KEY (id_fase) REFERENCES fase_tratamento (id_fase)
);

-- ========== ETAPA 06 | FORNECEDORES, COMPRAS E ESTOQUE ========== 
-- TABELA: fornecedor
CREATE TABLE fornecedor (
  cnpj CHAR(14) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  logradouro VARCHAR(150) NOT NULL,
  numero VARCHAR(10) NOT NULL,
  complemento VARCHAR(30),
  bairro VARCHAR(50) NOT NULL,
  cidade VARCHAR(50) NOT NULL,
  estado CHAR(2) NOT NULL,
  cep CHAR(8) NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (cnpj),
  CONSTRAINT ck_fornecedor_cnpj CHECK (cnpj REGEXP '^[0-9]{14}$'),
  CONSTRAINT ck_fornecedor_cep CHECK (cep REGEXP '^[0-9]{8}$')
);

-- TABELA: contato_fornecedor
CREATE TABLE contato_fornecedor (
  id_contato_fornecedor INT NOT NULL AUTO_INCREMENT,
  cnpj CHAR(14) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  telefone VARCHAR(15),
  email VARCHAR(100),
  cargo VARCHAR(50),
  PRIMARY KEY (id_contato_fornecedor),
  CONSTRAINT fk_contato_fornecedor FOREIGN KEY (cnpj) REFERENCES fornecedor (cnpj)
);

-- TABELA ASSOCIATIVA: produto_fornecedor
CREATE TABLE produto_fornecedor (
  id_produto INT NOT NULL,
  cnpj CHAR(14) NOT NULL,
  PRIMARY KEY (id_produto, cnpj),
  CONSTRAINT fk_prodfor_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto),
  CONSTRAINT fk_prodfor_fornecedor FOREIGN KEY (cnpj) REFERENCES fornecedor (cnpj)
);

-- TABELA: compra
CREATE TABLE compra (
  id_compra INT NOT NULL AUTO_INCREMENT,
  cnpj_fornecedor CHAR(14) NOT NULL,
  cnpj_unidade CHAR(14) NOT NULL,
  data_compra DATETIME NOT NULL,
  data_recebimento DATETIME,
  status VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_compra),
  CONSTRAINT fk_compra_fornecedor FOREIGN KEY (cnpj_fornecedor) REFERENCES fornecedor (cnpj),
  CONSTRAINT fk_compra_unidade FOREIGN KEY (cnpj_unidade) REFERENCES unidade (cnpj),
  CONSTRAINT ck_compra_status CHECK (status IN ('Pendente','Recebido','Cancelado'))
);

-- TABELA ASSOCIATIVA: compra_item
CREATE TABLE compra_item (
  id_compra INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  valor_unitario DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (id_compra, id_produto),
  CONSTRAINT fk_ci_compra FOREIGN KEY (id_compra) REFERENCES compra (id_compra),
  CONSTRAINT fk_ci_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto),
  CONSTRAINT ck_ci_quantidade CHECK (quantidade > 0),
  CONSTRAINT ck_ci_valor CHECK (valor_unitario >= 0)
);

-- TABELA ASSOCIATIVA: estoque_unidade
CREATE TABLE estoque_unidade (
  cnpj CHAR(14) NOT NULL,
  id_produto INT NOT NULL,
  quantidade_atual INT NOT NULL DEFAULT 0,
  quantidade_minima INT NOT NULL DEFAULT 0,
  PRIMARY KEY (cnpj, id_produto),
  CONSTRAINT fk_estoque_unidade FOREIGN KEY (cnpj) REFERENCES unidade (cnpj),
  CONSTRAINT fk_estoque_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto),
  CONSTRAINT ck_estoque_quantidades CHECK (quantidade_atual >= 0 AND quantidade_minima >= 0)
);

-- ========== ETAPA 07 | ATENDIMENTO, VENDA, CUPONS UTILIZADOS E AVALIACAO ========== 
-- TABELA: comanda
CREATE TABLE comanda (
  id_comanda INT NOT NULL AUTO_INCREMENT,
  id_agendamento INT,
  cnpj CHAR(14) NOT NULL,
  cpf_funcionario CHAR(11) NOT NULL,
  cpf_cliente CHAR(11),
  data_fechamento DATETIME,
  forma_pagamento VARCHAR(30),
  status VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_comanda),
  UNIQUE KEY uk_comanda_agendamento (id_agendamento),
  CONSTRAINT fk_comanda_ag FOREIGN KEY (id_agendamento) REFERENCES agendamento (id_agendamento),
  CONSTRAINT fk_comanda_unidade FOREIGN KEY (cnpj) REFERENCES unidade (cnpj),
  CONSTRAINT fk_comanda_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES funcionario (cpf),
  CONSTRAINT fk_comanda_cliente FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
  CONSTRAINT ck_comanda_status CHECK (status IN ('Aberta','Fechada','Cancelada'))
);

-- TABELA ASSOCIATIVA: comanda_item
CREATE TABLE comanda_item (
  id_item INT NOT NULL AUTO_INCREMENT,
  id_comanda INT NOT NULL,
  id_servico INT,
  id_produto INT,
  id_combo INT,
  id_tratamento INT,
  descricao_item VARCHAR(100) NOT NULL,
  quantidade INT NOT NULL,
  valor_unitario DECIMAL(8,2) NOT NULL,
  -- Atributo derivado: calcula automaticamente o subtotal
	subtotal DECIMAL(12,2)
        GENERATED ALWAYS AS (
            quantidade * valor_unitario
        ) VIRTUAL,
  PRIMARY KEY (id_item),
  CONSTRAINT fk_item_comanda FOREIGN KEY (id_comanda) REFERENCES comanda (id_comanda),
  CONSTRAINT fk_item_servico FOREIGN KEY (id_servico) REFERENCES servico (id_servico),
  CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto),
  CONSTRAINT fk_item_combo FOREIGN KEY (id_combo) REFERENCES combo (id_combo),
  CONSTRAINT fk_item_tratamento FOREIGN KEY (id_tratamento) REFERENCES tratamento (id_tratamento),
  CONSTRAINT ck_item_qtd CHECK (quantidade > 0),
  CONSTRAINT ck_item_valor CHECK (valor_unitario >= 0),
  CONSTRAINT ck_item_exclusividade CHECK (
    (id_servico IS NOT NULL) + (id_produto IS NOT NULL) +
    (id_combo IS NOT NULL) + (id_tratamento IS NOT NULL) = 1
  ) -- Evita ambiguidade no registro
);

-- TABELA ASSOCIATIVA: comanda_combo_composicao
CREATE TABLE comanda_combo_composicao (
  id_composicao INT NOT NULL AUTO_INCREMENT,
  id_item INT NOT NULL,
  id_produto INT,
  id_servico INT,
  nome_item VARCHAR(100) NOT NULL,
  quantidade INT NOT NULL,
  valor_referencia DECIMAL(8,2),
  PRIMARY KEY (id_composicao),
  CONSTRAINT fk_ccc_item FOREIGN KEY (id_item) REFERENCES comanda_item (id_item),
  CONSTRAINT fk_ccc_produto FOREIGN KEY (id_produto) REFERENCES produto (id_produto),
  CONSTRAINT fk_ccc_servico FOREIGN KEY (id_servico) REFERENCES servico (id_servico),
  CONSTRAINT ck_ccc_exclusividade CHECK ((id_produto IS NOT NULL) + (id_servico IS NOT NULL) = 1), -- Evita ambiguidade de ter um serviço e produto no mesmo registro
  CONSTRAINT ck_ccc_qtd CHECK (quantidade > 0)
);

-- TABELA ASSOCIATIVA: cupom_utilizacao
CREATE TABLE cupom_utilizacao (
  id_utilizacao INT NOT NULL AUTO_INCREMENT,
  id_cupom INT NOT NULL,
  cpf_cliente CHAR(11) NOT NULL,
  id_comanda INT NOT NULL,
  data_utilizacao DATETIME NOT NULL,
  valor_desconto_aplicado DECIMAL(8,2) NOT NULL,
  tipo_desconto_aplicado VARCHAR(20) NOT NULL,
  valor_original_desconto DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (id_utilizacao),
  UNIQUE KEY uk_cupom_util_comanda (id_comanda),
  CONSTRAINT fk_cu_cupom FOREIGN KEY (id_cupom) REFERENCES cupom (id_cupom),
  CONSTRAINT fk_cu_cliente FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
  CONSTRAINT fk_cu_comanda FOREIGN KEY (id_comanda) REFERENCES comanda (id_comanda),
  CONSTRAINT ck_cu_valor CHECK (valor_desconto_aplicado >= 0)
);

-- TABELA: avaliacao
CREATE TABLE avaliacao (
  id_avaliacao INT NOT NULL AUTO_INCREMENT,
  id_agendamento INT NOT NULL,
  nota_cliente INT,
  comentario_cliente TEXT,
  nota_barbeiro INT,
  comentario_barbeiro TEXT,
  PRIMARY KEY (id_avaliacao),
  UNIQUE KEY uk_avaliacao_ag (id_agendamento),
  CONSTRAINT fk_avaliacao_ag FOREIGN KEY (id_agendamento) REFERENCES agendamento (id_agendamento),
  CONSTRAINT ck_nota_cliente CHECK (nota_cliente IS NULL OR nota_cliente BETWEEN 1 AND 5),
  CONSTRAINT ck_nota_barbeiro CHECK (nota_barbeiro IS NULL OR nota_barbeiro BETWEEN 1 AND 5)
);

-- ========== ETAPA 08 | FINANCEIRO ========== 
-- TABELA: categoria_financeira
CREATE TABLE categoria_financeira (
  id_categoria_financeira INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(50) NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_categoria_financeira),
  UNIQUE KEY uk_categoria_financeira_nome (nome),
  CONSTRAINT ck_categoria_financeira_tipo CHECK (tipo IN ('Entrada','Saida','Transferencia','Ajuste'))
);

-- TABELA: conta_financeira
CREATE TABLE conta_financeira (
  id_conta INT NOT NULL AUTO_INCREMENT,
  cnpj_unidade CHAR(14) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  tipo VARCHAR(30) NOT NULL,
  saldo_inicial DECIMAL(12,2) NOT NULL,
  data_saldo_inicial DATE NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_conta),
  CONSTRAINT fk_conta_unidade FOREIGN KEY (cnpj_unidade) REFERENCES unidade (cnpj)
);

-- TABELA: obrigacao_financeira
CREATE TABLE obrigacao_financeira (
  id_obrigacao INT NOT NULL AUTO_INCREMENT,
  cnpj_unidade CHAR(14) NOT NULL,
  id_categoria_financeira INT NOT NULL,
  cpf_funcionario CHAR(11),
  cnpj_fornecedor CHAR(14),
  id_compra INT,
  id_comanda INT,
  tipo VARCHAR(20) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  valor_original DECIMAL(12,2) NOT NULL,
  data_emissao DATE NOT NULL,
  data_vencimento DATE NOT NULL,
  cancelada BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (id_obrigacao),
  CONSTRAINT fk_ob_unidade FOREIGN KEY (cnpj_unidade) REFERENCES unidade (cnpj),
  CONSTRAINT fk_ob_categoria FOREIGN KEY (id_categoria_financeira) REFERENCES categoria_financeira (id_categoria_financeira),
  CONSTRAINT fk_ob_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES funcionario (cpf),
  CONSTRAINT fk_ob_fornecedor FOREIGN KEY (cnpj_fornecedor) REFERENCES fornecedor (cnpj),
  CONSTRAINT fk_ob_compra FOREIGN KEY (id_compra) REFERENCES compra (id_compra),
  CONSTRAINT fk_ob_comanda FOREIGN KEY (id_comanda) REFERENCES comanda (id_comanda),
  CONSTRAINT ck_ob_tipo CHECK (tipo IN ('Pagar','Receber')),
  CONSTRAINT ck_ob_valor CHECK (valor_original > 0),
  CONSTRAINT ck_ob_origem CHECK (id_compra IS NULL OR id_comanda IS NULL) -- Evita que tenhamos recebimento e pagamento na mesma obrigação
);

-- TABELA: transferencia_financeira
CREATE TABLE transferencia_financeira (
  id_transferencia INT NOT NULL AUTO_INCREMENT,
  id_conta_origem INT NOT NULL,
  id_conta_destino INT NOT NULL,
  valor DECIMAL(12,2) NOT NULL,
  data_transferencia DATETIME NOT NULL,
  PRIMARY KEY (id_transferencia),
  CONSTRAINT fk_transfer_origem FOREIGN KEY (id_conta_origem) REFERENCES conta_financeira (id_conta),
  CONSTRAINT fk_transfer_destino FOREIGN KEY (id_conta_destino) REFERENCES conta_financeira (id_conta),
  CONSTRAINT ck_transfer_contas CHECK (id_conta_origem <> id_conta_destino),
  CONSTRAINT ck_transfer_valor CHECK (valor > 0)
);

-- TABELA: movimento_financeiro
CREATE TABLE movimento_financeiro (
  id_movimentacao INT NOT NULL AUTO_INCREMENT,
  id_categoria_financeira INT NOT NULL,
  id_conta INT NOT NULL,
  id_obrigacao INT,
  id_transferencia INT,
  valor DECIMAL(12,2) NOT NULL,
  data_movimento DATETIME NOT NULL,
  tipo VARCHAR(10) NOT NULL,
  natureza VARCHAR(20) NOT NULL,
  forma_pagamento VARCHAR(30),
  descricao TEXT,
  PRIMARY KEY (id_movimentacao),
  CONSTRAINT fk_mov_categoria FOREIGN KEY (id_categoria_financeira) REFERENCES categoria_financeira (id_categoria_financeira),
  CONSTRAINT fk_mov_conta FOREIGN KEY (id_conta) REFERENCES conta_financeira (id_conta),
  CONSTRAINT fk_mov_obrigacao FOREIGN KEY (id_obrigacao) REFERENCES obrigacao_financeira (id_obrigacao),
  CONSTRAINT fk_mov_transfer FOREIGN KEY (id_transferencia) REFERENCES transferencia_financeira (id_transferencia),
  CONSTRAINT ck_mov_valor CHECK (valor > 0),
  CONSTRAINT ck_mov_tipo CHECK (tipo IN ('Entrada','Saida')),
  CONSTRAINT ck_mov_natureza CHECK (natureza IN ('Operacional','Transferencia','Ajuste')),
  CONSTRAINT ck_mov_transfer CHECK (
    (natureza = 'Transferencia' AND id_transferencia IS NOT NULL AND id_obrigacao IS NULL)
    OR (natureza <> 'Transferencia' AND id_transferencia IS NULL)
  )
);

-- ========== ETAPA 09 | AUDITORIA ========== 
-- TABELA: registro_auditoria
CREATE TABLE registro_auditoria (
  id_auditoria BIGINT NOT NULL AUTO_INCREMENT,
  cpf_usuario CHAR(11) NOT NULL,
  data_hora DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  modulo VARCHAR(30) NOT NULL,
  acao VARCHAR(30) NOT NULL,
  entidade_afetada VARCHAR(60) NOT NULL,
  id_registro_afetado VARCHAR(100) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  justificativa TEXT,
  PRIMARY KEY (id_auditoria),
  INDEX idx_auditoria_data_modulo (data_hora, modulo),
  CONSTRAINT fk_registro_usuario FOREIGN KEY (cpf_usuario) REFERENCES usuario (cpf),
  CONSTRAINT ck_auditoria_modulo
	CHECK (modulo IN (
		'Usuarios',
		'Unidades',
		'Recursos_Humanos',
		'Clientes',
		'Produtos',
		'Agendamentos',
		'Atendimentos',
		'Tratamentos',
		'Vendas',
		'Estoque',
		'Compras',
		'Marketing',
		'Financeiro',
		'Auditoria'
	))
);

-- TABELA: detalhe_auditoria
CREATE TABLE detalhe_auditoria (
  id_detalhe BIGINT NOT NULL AUTO_INCREMENT,
  id_auditoria BIGINT NOT NULL,
  atributo_alterado VARCHAR(100) NOT NULL,
  valor_anterior TEXT,
  valor_novo TEXT,
  PRIMARY KEY (id_detalhe),
  CONSTRAINT fk_detalhe_auditoria FOREIGN KEY (id_auditoria) REFERENCES registro_auditoria (id_auditoria)
);