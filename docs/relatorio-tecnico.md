# Otimização de Performance em Banco de Dados MySQL  
### Centro Universitário Salesiano — Engenharia de Software (6º Período)  
**Aluno:** Gustavo Cardoso Rodrigues  
**Professor:** Alexandre B. Souza  
25/11/2025  

---

## 1. Introdução

Este relatório apresenta o diagnóstico e otimização de consultas SQL em um banco de dados MySQL utilizado para simular operações de uma loja virtual. O banco armazena dados de produtos, clientes, vendas, itens vendidos e logs de acessos.  

A versão inicial (banco **problemático**) apresentava gargalos de performance ao executar relatórios analíticos, como:
- vendas concluídas por período;
- produtos mais vendidos;
- consulta de acessos por data.  

O objetivo do estudo foi:
 **Identificar gargalos usando o plano de execução (`EXPLAIN`)**  
 **Aplicar otimizações reais (índices e ajustes)**  
 **Comparar o desempenho ANTES e DEPOIS**

---

## 2. Metodologia

| Técnica / Ferramenta | Utilidade |
|---------------------|----------|
| `EXPLAIN` | Identificar uso (ou ausência) de índices |
| `SET profiling` + `SHOW PROFILE` | Medir tempo das queries |
| MySQL Workbench | Execução, visualização e monitoramento |
| Índices e índices compostos | Otimizar pesquisas e JOINs |

Queries analisadas (Before e After)
```sql
/* Consulta de vendas concluídas */
SELECT c.nome, v.data_venda, v.valor_total, COUNT(iv.id) AS total_itens
FROM vendas v
JOIN clientes c ON v.cliente_id = c.id
JOIN itens_venda iv ON v.id = iv.venda_id
WHERE v.data_venda BETWEEN '2024-01-01' AND '2025-12-31'
  AND v.status = 'concluida'
GROUP BY v.id, c.nome, v.data_venda, v.valor_total;

/* Produtos mais vendidos */
SELECT p.nome, SUM(iv.quantidade) AS total_vendido
FROM produtos p
JOIN itens_venda iv ON p.id = iv.produto_id
JOIN vendas v ON iv.venda_id = v.id
WHERE v.status = 'concluida'
GROUP BY p.nome
ORDER BY total_vendido DESC;

/* Logs agrupados por data */
SELECT acao, COUNT(*) AS total, DATE(data_hora) AS data
FROM logs_acesso
WHERE data_hora BETWEEN '2024-06-01' AND '2025-12-30'
GROUP BY acao, DATE(data_hora);
```
## Diagnóstico – Before

- **JOIN sem índices**
  - Tabelas envolvidas: `clientes`, `vendas`, `items_venda`
  - Problema: consultas executavam FULL SCAN
  - Ausência de índices nos campos:
    - `cliente_id`
    - `venda_id`
    - `produto_id`
  - **EXPLAIN evidência:** `type: ALL`, `possible_keys: NULL`

- **Filtro por data + status sem índice**
  - Consultas com período + status faziam varredura completa
  - **EXPLAIN evidência:** `Using where; Using temporary; Using filesort`

- **Logs lentos**
  - A tabela `logs_acesso` consultava `data_hora` sem índice
  - **EXPLAIN evidência:** ausência de `possible_keys`
    
  Proposta de Otimização

- **Criação de índices em FKs**
  - Melhora JOINs
  - Reduz varreduras completas

- **Índice composto `(data_venda, status)`**
  - Acelera filtros combinados
  - Melhora seletividade

- **Índice em `data_hora`**
  - Otimiza relatórios cronológicos
  - Acelera busca por período

### Exemplo aplicado
```sql
CREATE INDEX idx_vendas_data_status 
ON vendas(data_venda, status);
````

| Consulta                 | Antes (ms) | Depois (ms) | Melhoria |
|--------------------------|------------|-------------|----------|
| Relatório de vendas      | 1200       | 120         | 90%      |
| Produtos mais vendidos   | 980        | 110         | 88%      |
| Logs por período         | 540        | 60          | 89%      |

## 6. Conclusão
Este estudo demonstrou, de forma prática, que índices corretamente aplicados reduzem drasticamente o tempo de consultas SQL, sem necessidade de upgrades de hardware.
Aprendizados principais:

EXPLAIN e SHOW PROFILE são essenciais para diagnóstico real.

Índices devem ser criados com base nos padrões das consultas.

Índices compostos são decisivos em relatórios analíticos.

Ganho médio obtido: 89% de performance 
