SET profiling = 1;

-- ===========================
-- CONSULTA 1 (DEPOIS)
-- ===========================
EXPLAIN SELECT 
    c.nome as cliente,
    v.data_venda,
    v.valor_total,
    COUNT(iv.id) as total_itens
FROM vendas v
JOIN clientes c ON v.cliente_id = c.id
JOIN itens_venda iv ON v.id = iv.venda_id
WHERE v.data_venda BETWEEN '2023-01-01' AND '2025-12-31'
  AND v.status = 'concluida'
GROUP BY v.id, c.nome, v.data_venda, v.valor_total
ORDER BY v.data_venda DESC
LIMIT 10;

SELECT 
    c.nome as cliente,
    v.data_venda,
    v.valor_total,
    COUNT(iv.id) as total_itens
FROM vendas v
JOIN clientes c ON v.cliente_id = c.id
JOIN itens_venda iv ON v.id = iv.venda_id
WHERE v.data_venda BETWEEN '2023-01-01' AND '2025-12-31'
  AND v.status = 'concluida'
GROUP BY v.id, c.nome, v.data_venda, v.valor_total
ORDER BY v.data_venda DESC
LIMIT 10;

SHOW PROFILE FOR QUERY 1;
SHOW PROFILE FOR QUERY 2;

-- ===========================
-- CONSULTA 2 (DEPOIS)
-- ===========================
EXPLAIN SELECT 
    p.nome as produto,
    SUM(iv.quantidade) as total_vendido
FROM produtos p
JOIN itens_venda iv ON p.id = iv.produto_id
JOIN vendas v ON iv.venda_id = v.id
WHERE v.status = 'concluida'
GROUP BY p.nome
ORDER BY total_vendido DESC
LIMIT 10;

SELECT 
    p.nome as produto,
    SUM(iv.quantidade) as total_vendido
FROM produtos p
JOIN itens_venda iv ON p.id = iv.produto_id
JOIN vendas v ON iv.venda_id = v.id
WHERE v.status = 'concluida'
GROUP BY p.nome
ORDER BY total_vendido DESC
LIMIT 10;

SHOW PROFILE FOR QUERY 3;
SHOW PROFILE FOR QUERY 4;

-- ===========================
-- CONSULTA 3 (DEPOIS)
-- ===========================
EXPLAIN SELECT 
    acao,
    COUNT(*) as total,
    DATE(data_hora) as data
FROM logs_acesso
WHERE data_hora BETWEEN '2024-06-01' AND '2025-12-30'
GROUP BY acao, DATE(data_hora);

SELECT 
    acao,
    COUNT(*) as total,
    DATE(data_hora) as data
FROM logs_acesso
WHERE data_hora BETWEEN '2024-06-01' AND '2025-12-30'
GROUP BY acao, DATE(data_hora);

SHOW PROFILE FOR QUERY 5;
SHOW PROFILE FOR QUERY 6;
