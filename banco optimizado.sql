CREATE DATABASE IF NOT EXISTS supertech_store;
USE supertech_store;

CREATE TABLE produtos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(200) NOT NULL,
  descricao TEXT,
  preco_custo DECIMAL(10,2),
  preco_venda DECIMAL(10,2),
  categoria_id INT,
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE categorias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  descricao TEXT
) ENGINE=InnoDB;

CREATE TABLE estoque (
  id INT AUTO_INCREMENT PRIMARY KEY,
  produto_id INT,
  quantidade INT,
  armazem_id INT,
  data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(200) NOT NULL,
  email VARCHAR(150),
  cidade VARCHAR(100),
  estado CHAR(2),
  data_cadastro DATE
) ENGINE=InnoDB;

CREATE TABLE vendas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT,
  data_venda DATE,
  valor_total DECIMAL(10,2),
  status ENUM('pendente', 'processando', 'concluida', 'cancelada'),
  -- SEM ÍNDICES NAS CHAVES ESTRANGEIRAS E CAMPOS DE BUSCA FREQUENTE
  observacao TEXT
) ENGINE=InnoDB;

CREATE TABLE itens_venda (
  id INT AUTO_INCREMENT PRIMARY KEY,
  venda_id INT,
  produto_id INT,
  quantidade INT,
  preco_unitario DECIMAL(10,2),
  -- FALTAM ÍNDICES PARA JOINS EFICIENTES
  subtotal DECIMAL(10,2)
) ENGINE=InnoDB;

CREATE TABLE logs_acesso (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT,
  acao VARCHAR(50),
  data_hora DATETIME,
  ip VARCHAR(15),
  -- SEM ÍNDICE NA DATA - consultas por período serão lentas
  detalhes TEXT
) ENGINE=InnoDB;

INSERT INTO categorias (nome, descricao) VALUES
('Eletrônicos', 'Dispositivos eletrônicos em geral'),
('Informática', 'Computadores e acessórios'),
('Smartphones', 'Telefones inteligentes'),
('Games', 'Jogos e consoles'),
('Áudio', 'Fones e equipamentos de som');

INSERT INTO produtos (nome, descricao, preco_custo, preco_venda, categoria_id) VALUES
('Smartphone Galaxy X', 'Smartphone avançado com 128GB', 800.00, 1200.00, 3),
('iPhone 15 Pro', 'iPhone com câmera tripla', 900.00, 1500.00, 3),
('Notebook Dell i7', 'Notebook com processor i7 e 16GB RAM', 1200.00, 2000.00, 2),
('Mouse Gamer RGB', 'Mouse com iluminação RGB', 50.00, 120.00, 2),
('Teclado Mecânico', 'Teclado mecânico blue switch', 80.00, 180.00, 2),
('PlayStation 5', 'Console de última geração', 400.00, 800.00, 4),
('Xbox Series X', 'Console Microsoft', 350.00, 700.00, 4),
('Fone Bluetooth', 'Fone de ouvido sem fio', 60.00, 150.00, 5),
('Monitor 24"', 'Monitor Full HD 24 polegadas', 200.00, 400.00, 2),
('Tablet Samsung', 'Tablet com caneta stylus', 150.00, 300.00, 1);

INSERT INTO produtos (nome, descricao, preco_custo, preco_venda, categoria_id)
SELECT
  CONCAT('Produto ', n),
  CONCAT('Descrição do produto ', n),
  ROUND(RAND() * 500 + 50, 2),
  ROUND(RAND() * 1000 + 100, 2),
  FLOOR(RAND() * 5) + 1
FROM (SELECT a.N + b.N * 10 + 1 as n
  FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
  CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION
SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
) numbers
WHERE n <= 40;

INSERT INTO estoque (produto_id, quantidade, armazem_id)
SELECT id, FLOOR(RAND() * 100) + 10, 1 FROM produtos;

INSERT INTO clientes (nome, email, cidade, estado, data_cadastro) VALUES
('João Silva', 'joao@email.com', 'São Paulo', 'SP', '2024-01-15'),
('Maria Santos', 'maria@email.com', 'Rio de Janeiro', 'RJ', '2024-02-20'),
('Pedro Oliveira', 'pedro@email.com', 'Belo Horizonte', 'MG', '2024-03-10');

INSERT INTO clientes (nome, email, cidade, estado, data_cadastro)
SELECT
  CONCAT('Cliente ', n),
  CONCAT('cliente', n, '@email.com'),
  ELT(FLOOR(RAND() * 5) + 1, 'São Paulo', 'Rio de Janeiro', 'Belo Horizonte', 'Porto
Alegre', 'Salvador'),
  ELT(FLOOR(RAND() * 5) + 1, 'SP', 'RJ', 'MG', 'RS', 'BA'),
  DATE_SUB(CURRENT_DATE, INTERVAL FLOOR(RAND() * 365) DAY)
FROM (SELECT a.N + b.N * 10 + 4 as n
  FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
  CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION
SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
) numbers
WHERE n <= 97;

INSERT INTO vendas (cliente_id, data_venda, valor_total, status)
SELECT
  FLOOR(RAND() * 100) + 1,
  DATE_SUB(CURRENT_DATE, INTERVAL FLOOR(RAND() * 180) DAY),
  ROUND(RAND() * 1000 + 50, 2),
  ELT(FLOOR(RAND() * 4) + 1, 'pendente', 'processando', 'concluida', 'concluida')
FROM (SELECT a.N + b.N * 10 + c.N * 100 as n
  FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
  CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION
SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
  CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION
SELECT 4 UNION SELECT 5) c
) numbers
WHERE n BETWEEN 1 AND 500;

INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario, subtotal)
SELECT
  v.id,
  p.id,
  FLOOR(RAND() * 3) + 1,
  p.preco_venda,
  (FLOOR(RAND() * 3) + 1) * p.preco_venda
FROM vendas v
CROSS JOIN (SELECT id, preco_venda FROM produtos ORDER BY RAND() LIMIT 1) p
WHERE RAND() < 0.8;

INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario, subtotal)
SELECT
  v.id,
  p.id,
  FLOOR(RAND() * 2) + 1,
  p.preco_venda,
  (FLOOR(RAND() * 2) + 1) * p.preco_venda
FROM vendas v
CROSS JOIN (SELECT id, preco_venda FROM produtos ORDER BY RAND() LIMIT 1) p
WHERE RAND() < 0.3;

INSERT INTO logs_acesso (usuario_id, acao, data_hora, ip, detalhes)
SELECT
  FLOOR(RAND() * 100) + 1,
  ELT(FLOOR(RAND() * 5) + 1, 'login', 'logout', 'consulta', 'compra', 'cadastro'),
  DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 864000) SECOND),
  CONCAT('192.168.', FLOOR(RAND() * 255), '.', FLOOR(RAND() * 255)),
  CONCAT('Ação realizada pelo usuário ', FLOOR(RAND() * 100) + 1)
FROM (SELECT a.N + b.N * 10 + c.N * 100 as n
  FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a
  CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION
SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b
  CROSS JOIN (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION
SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c
) numbers
WHERE n BETWEEN 1 AND 1000;


CREATE INDEX idx_vendas_cliente_id ON vendas(cliente_id);
CREATE INDEX idx_vendas_data_status ON vendas(data_venda, status);
CREATE INDEX idx_itens_venda_venda_id ON itens_venda(venda_id);
CREATE INDEX idx_itens_venda_produto_id ON itens_venda(produto_id);
CREATE INDEX idx_estoque_produto_id ON estoque(produto_id);

CREATE INDEX idx_logs_acesso_data_hora ON logs_acesso(data_hora);
CREATE INDEX idx_clientes_cidade_estado ON clientes(cidade, estado);

CREATE INDEX idx_vendas_cliente_data ON vendas(cliente_id, data_venda);

SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    INDEX_TYPE
FROM information_schema.STATISTICS 
WHERE TABLE_SCHEMA = 'supertech_store'
ORDER BY TABLE_NAME, INDEX_NAME;

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


SELECT 
    acao,
    COUNT(*) as total,
    DATE(data_hora) as data
FROM logs_acesso
WHERE data_hora BETWEEN '2024-06-01' AND '2025-12-30'
GROUP BY acao, DATE(data_hora);


