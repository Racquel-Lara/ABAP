# ABAP
Códigos para estudo ABAP
 # Relatórios ABAP – ALUNO 025

Este repositório contém diversos relatórios ABAP desenvolvidos durante o curso SAP, com foco em aprendizado prático de manipulação de dados, criação de relatórios ALV, uso de BAPIs e interação com tabelas customizadas.

## 📁 Arquivos e Descrições

### `EXCP`
> **Título:** Report Simples de Documentos Contábeis  
> **Descrição:** Consulta a tabela BKPF com filtros via SELECT-OPTIONS para empresa, número do documento e exercício.  
> **Transação:** ZREPO_EXCP_ALUNO025

---

### `EXCP2`
> **Título:** Report com JOIN BKPF e BSEG  
> **Descrição:** Extensão do relatório EXCP com uso de `JOIN` entre BKPF e BSEG, exibindo informações detalhadas de lançamentos contábeis.  
> **Transação:** ZREPO_EXCP2_ALUNO025

---

### `EXCP3`
> **Título:** Armazenamento de dados na Tabela ZTBMM_ALUNO025  
> **Descrição:** Relatório que insere dados de pedidos de compras (EKKO/EKPO) na tabela customizada `ZTBMM_ALUNO025`.  
> **Transação:** ZEXCP3_025

---

### `EXCP4`
> **Título:** Criação de Documento via BAPI  
> **Descrição:** Recebe um pedido e empresa como parâmetros e utiliza estruturas da BAPI para preparar a criação de documentos no SAP.  
> **Transação:** ZREPO_EXCP4_ALUNO025

---

### `EXCP5`
> **Título:** ALV com CL_GUI_ALV_GRID + Inserção e Visualização  
> **Descrição:** Relatório que exibe dados da tabela `ZTBMM_ALUNO025` em ALV Grid (classe `CL_GUI_ALV_GRID`), com opções de inserção, visualização e manipulação de dados. Implementação de tela, container e métodos personalizados.  
> **Transação:** ZREPO_EXCP5_ALUNO025

---

### `EXCPF`
> **Título:** Relatório de Notas Fiscais  
> **Descrição:** Leitura de dados da tabela `J_1BNFDOC` com persistência na tabela `ZTBSD_ALUNO025`. Utiliza a função `J_1B_NF_DOCUMENT_READ` para obter dados das NFs e exibe via ALV.  
> **Transação:** ZREPO_EXCPF_ALUNO025

---

### `IMC`
> **Título:** Calculadora de IMC  
> **Descrição:** Programa simples de cálculo de IMC com exibição de resultados via `MESSAGE` e `WRITE`. Utiliza constantes para classificação de faixas de IMC.  
> **Transação:** ZIMC_025

---

## 🧠 Autor
- **Nome:** Racquel Marques Lara de Almeida  
- **ID:** ALUNO025  
- **Contato:** racquellara.dev@gmail.com  
  

## 🗓️ Datas dos Relatórios
| Arquivo  | Data       |
|----------|------------|
| EXCPF    | 03/05/2025 |
| IMC      | 09/05/2025 |
| EXCP3    | 22/05/2025 |
| EXCP4    | 23/05/2025 |
| EXCP5    | 30/05/2025 |

## 🛠️ Tecnologias e Conceitos Utilizados
- SAP ABAP (Reports)
- Tabelas BKPF, BSEG, EKKO, EKPO, J_1BNFDOC
- Tabelas customizadas: `ZTBMM_ALUNO025`, `ZTBSD_ALUNO025`
- BAPI de criação de documento
- ALV Grid (REUSE_ALV e `CL_GUI_ALV_GRID`)
- SELECTION-SCREEN
- Estruturas `TYPES`, `DATA`, `FORM`, `CLASS`, `METHODS`

## ✅ Status
Todos os programas foram desenvolvidos com fins acadêmicos e podem ser utilizados como referência para criação de relatórios SAP no ambiente SAP GUI.

---

