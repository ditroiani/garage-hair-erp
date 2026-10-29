<div align="center">

# 💈 ERP Barbearia Garage Hair 💈

### Modelagem de Dados — Projeto Acadêmico

**UNICID — Universidade Cidade de São Paulo**

</div>

> **_Projeto de Modelagem de Dados desenvolvido para a disciplina de Modelagem de Dados, sob orientação do Prof. Clóvis José Ramos Ferraro._**


## 1. Apresentação do projeto

O **Garage Hair ERP** é um projeto de modelagem e implementação de banco de dados desenvolvido pelo **Grupo 02**, na disciplina de **Modelagem de Dados** da Universidade Cidade de São Paulo (UNICID), sob orientação do **Prof. Clóvis José Ramos Ferraro**.

O trabalho parte das necessidades de uma barbearia real, identifica seus processos e regras de negócio e os transforma em um **modelo conceitual, um modelo lógico e uma estrutura relacional em MySQL**. O repositório reúne os diagramas, a documentação da proposta e os scripts necessários para criar, popular, consultar e testar o banco.

> **Escopo da entrega:** este projeto implementa a **camada de banco de dados** de um ERP proposto. Não se trata de uma aplicação web de gestão pronta para uso.

## 2. Empresa e problema

A **Garage Hair** é uma barbearia de pequeno porte, localizada na **Zona Leste de São Paulo**. Conforme o levantamento realizado pela equipe, a operação atual conta com um barbeiro e oferece serviços como corte de cabelo, barba, sobrancelha e combos, além da comercialização de produtos de higiene e cuidados capilares. Tratamentos capilares fazem parte das possibilidades de expansão do negócio.

Atualmente, o **Booksy** centraliza os agendamentos, enquanto atividades como controle de estoque e gestão financeira dependem de planilhas e procedimentos manuais. O atendimento também precisa considerar clientes que preferem agendar diretamente pelo balcão ou por WhatsApp.

A equipe identificou um problema central: **as informações operacionais ficam distribuídas entre ferramentas e registros que não formam uma base integrada**. Isso aumenta o esforço administrativo e dificulta acompanhar estoque, vendas, histórico de atendimentos e situação financeira de forma consistente.

**Principais necessidades identificadas:**

- Unificar os cadastros e as informações sobre clientes, funcionários, serviços e produtos.
- Relacionar agendamentos, atendimentos, vendas e comandas.
- Organizar compras, fornecedores e estoque.
- Distinguir valores *a pagar/receber* dos pagamentos e recebimentos efetivamente realizados.
- Produzir consultas e indicadores úteis para decisões gerenciais.

## 3. Solução proposta

A equipe propôs a **modelagem de um ERP integrado**, com dados organizados em um banco relacional. A solução foi dimensionada também para cenários de crescimento, como uma rede com várias unidades, embora isso não corresponda à estrutura atual da empresa.

| Área do ERP | Informações e processos contemplados |
|:--|:--|
| **Cadastros e RH** | Usuários, clientes, funcionários, barbeiros, especialidades, unidades e horários |
| **Agenda e atendimento** | Disponibilidade, agendamentos, serviços e combos |
| **Vendas** | Comandas, itens vendidos, valores e histórico da composição dos combos |
| **Estoque e compras** | Produtos, categorias, fornecedores, compras e estoque por unidade |
| **Relacionamento** | Campanhas, cupons, avaliações e tratamentos capilares por fases |
| **Financeiro** | Contas financeiras, obrigações a pagar/receber, movimentações e transferências |
| **Auditoria** | Registros de operações críticas e detalhes das alterações |

## 5. Estrutura do repositório e documentação

```text
📦 garage-hair-erp/
├── 📁 docs/
│   ├── 📂 fluxograma/               # Fluxos dos processos do negócio
│   ├── 📂 modelo-conceitual/        # DER e materiais da modelagem conceitual
│   ├── 📂 modelo-logico/            # Modelo lógico relacional
|   └── 📄 documentacao-tecnica.pdf  # Documentação Técnica (RN, RF, RNF, Entidades, Cardinalidades, Atributos...)
├── 📁sql/
│   ├── 💾 01-estrutura.sql          # DDL: schema, tabelas e constraints
│   ├── 💾 02-carga_dados.sql        # DML: massa de dados fictícia
│   ├── 💾 03-testes_integridade.sql # Testes negativos: erros esperados
│   ├── 💾 04-consultas.sql          # Consultas SQL e views
│   └── 💾 05_consultas_bi.sql       # Indicadores gerenciais e views
└── 📄 README.md
```

### 📁 `docs/`

Reúne a documentação técnica e os materiais utilizados na definição do sistema.

Inclui documentos relacionados a:

- Diagramas
- Modelos Lógico e Físico
- Requisitos Funcionais (RF);
- Requisitos Não Funcionais (RNF);
- Regras de Negócio;
- Dicionário de Dados;
- Justificativas da modelagem;

- ### 📁 `sql/`

Diretório destinado aos arquivos relacionados à estrutura do banco de dados, dados e consultas.


**Onde encontrar cada artefato:**

| Artefato | Para que serve | Localização |
|:--|:--|:--|
| **🗃️ Modelo conceitual (DER)** | Visualizar as entidades e as relações identificadas no negócio | [`docs/modelo-conceitual/`](./docs/modelo-conceitual/) |
| **🗃️ Modelo lógico** | Entender a conversão para tabelas, chaves e relacionamentos | [`docs/modelo-logico/`](./docs/modelo-logico/) |
| **🔄 Fluxogramas** | Acompanhar os processos analisados pela equipe | [`docs/fluxograma/`](./docs/fluxograma/) |
| **💾 Banco de dados** | Reproduzir a estrutura, a carga, os testes e as consultas | [`sql/`](./sql/) |
| **📄 Documentação técnica** | Consultar requisitos, regras de negócio, decisões de modelagem, normalização e dicionário de dados | [`documentacao-tecnica.pdf/`](./docs/documentacao-tecnica.pdf/) |


## 6. Como executar o projeto

Para reproduzir o banco, utilize **MySQL Server 8.0.16 ou superior** e, preferencialmente, o **MySQL Workbench**. É necessário ter permissão para criar bancos e tabelas.

**Execute em uma instância local de teste, com a base `garage_hair_erp` vazia. Não utilize dados de produção.**

1. Baixe ou clone este repositório e abra o **MySQL Workbench**.
2. Conecte-se ao seu servidor MySQL. No menu **File → Open SQL Script**, abra [`01-estrutura.sql`](./sql/01-estrutura.sql) e execute o arquivo completo para criar o banco e as tabelas.
3. Execute [`02-carga_dados.sql`](./sql/02-carga_dados.sql) para inserir a massa de dados fictícia. **A carga foi planejada para ser executada uma vez em um banco vazio.**
4. Abra e execute [`04-consultas.sql`](./sql/04-consultas.sql) para consultar os registros, relacionamentos e views.
5. Execute [`05_consultas_bi.sql`](./sql/05_consultas_bi.sql) para explorar as visões e consultas analíticas complementares.
6. Por último, utilize [`03-testes_integridade.sql`](./sql/03-testes_integridade.sql) **teste por teste**. Esses comandos tentam gravar dados inválidos: os **erros são esperados** e evidenciam o funcionamento das restrições. Siga as instruções de transação e `ROLLBACK` presentes no arquivo.

## 7. Evolução do projeto

O histórico abaixo resume decisões registradas no **diário de bordo coletivo** e a progressão dos artefatos do repositório:

| Etapa | Evolução registrada |
|:--|:--|
| **Levantamento inicial** | Identificação do negócio, dos processos, das principais entidades e de seus atributos |
| **Relacionamentos** | Revisão das cardinalidades e criação de entidades associativas, como `agendamento_servico`, para representar relações N:N |
| **Modelo lógico** | Conversão do DER em tabelas e definição de PKs, FKs e chaves compostas; revisão de entidades e suas dependências |
| **Auditoria e normalização** | Reavaliação da modelagem, incluindo a associação entre barbeiros e especialidades, e discussão de 1FN, 2FN e 3FN |
| **Implementação e verificação** | Construção do DDL, preparação da massa fictícia, elaboração de consultas e testes que verificam restrições de integridade |

## 8. Considerações finais

O **Garage Hair ERP** demonstra como necessidades de uma empresa podem ser traduzidas em um modelo de dados estruturado, com entidades, relacionamentos, regras de integridade e consultas capazes de gerar informações úteis.

Mais do que criar tabelas, o projeto reúne **modelagem, revisão, implementação e validação**, estabelecendo uma base para a evolução futura de um sistema de gestão integrado para a barbearia.

## 9. Equipe e informações acadêmicas

**Grupo 02 — Engenharia de Software · UNICID**

| Integrantes |
|:--|
| Danilo Felipe |
| João Pedro Rodrigues | 
| Vivian Cristina |
| Gustavo Miguel |
| Isac de Souza |
| Alessandro Oliveira |
| Luan de Oliveira Martins |
| Larissa Fujiwara |
| Diego Troiani |

---

<div align="center">

<sub>Projeto desenvolvido para fins acadêmicos · Grupo 02 · UNICID · 2026</sub>

</div>
