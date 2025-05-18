-- 1. Total de pedidos por forma de pagamento
SELECT forma_pagamento, COUNT(*) AS total
FROM Pedido
GROUP BY forma_pagamento;

-- 2. Top 5 clientes que mais compraram (em número de pedidos)
SELECT c.nome, COUNT(p.id_pedido) AS total_pedidos
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.nome
ORDER BY total_pedidos DESC
LIMIT 5;

-- 3. Receita total por jogo (considerando quantidade e preço)
SELECT j.titulo, SUM(pj.quantidade * pj.preco_unitario) AS receita
FROM Pedido_Jogo pj
JOIN Jogo j ON pj.id_jogo = j.id_jogo
GROUP BY j.titulo
ORDER BY receita DESC;

-- 4. Quantidade de jogos por plataforma
SELECT p.nome AS plataforma, COUNT(jp.id_jogo) AS total_jogos
FROM Jogo_Plataforma jp
JOIN Plataforma p ON jp.id_plataforma = p.id_plataforma
GROUP BY p.nome;

-- 5. Jogos mais vendidos (por quantidade total)
SELECT j.titulo, SUM(pj.quantidade) AS total_vendido
FROM Pedido_Jogo pj
JOIN Jogo j ON pj.id_jogo = j.id_jogo
GROUP BY j.titulo
ORDER BY total_vendido DESC
LIMIT 5;

-- 6. Clientes que usaram cupons em pedidos
SELECT DISTINCT c.nome
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
JOIN Cupom_Pedido cp ON p.id_pedido = cp.id_pedido;

-- 7. Valor médio gasto por pedido
SELECT ROUND(AVG(total), 2) AS media_valor
FROM (
  SELECT SUM(pj.quantidade * pj.preco_unitario) AS total
  FROM Pedido_Jogo pj
  GROUP BY pj.id_pedido
) sub;

-- 8. Lista de pedidos com valor total (quantidade * preço)
SELECT p.id_pedido, c.nome, SUM(pj.quantidade * pj.preco_unitario) AS total_pedido
FROM Pedido p
JOIN Cliente c ON p.id_cliente = c.id_cliente
JOIN Pedido_Jogo pj ON p.id_pedido = pj.id_pedido
GROUP BY p.id_pedido, c.nome;

-- 9. Funcionário que processou mais pedidos
SELECT f.nome, COUNT(p.id_pedido) AS pedidos_processados
FROM Funcionario f
JOIN Pedido p ON f.id_funcionario = p.id_funcionario
GROUP BY f.nome
ORDER BY pedidos_processados DESC
LIMIT 1;

-- 10. Quantidade de jogos por gênero
SELECT genero, COUNT(*) AS total
FROM Jogo
GROUP BY genero;
