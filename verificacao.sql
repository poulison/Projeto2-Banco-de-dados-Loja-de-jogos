-- 1. Verificar se todos os pedidos têm cliente associado
SELECT * FROM Pedido
WHERE id_cliente NOT IN (SELECT id_cliente FROM Cliente);

-- 2. Verificar se todos os pedidos têm funcionário associado
SELECT * FROM Pedido
WHERE id_funcionario NOT IN (SELECT id_funcionario FROM Funcionario);

-- 3. Verificar se todos os pedidos possuem pelo menos 1 jogo relacionado
SELECT p.id_pedido
FROM Pedido p
LEFT JOIN Pedido_Jogo pj ON p.id_pedido = pj.id_pedido
WHERE pj.id_jogo IS NULL;

-- 4. Verificar se todos os pedidos com cupom realmente existem
SELECT cp.*
FROM Cupom_Pedido cp
LEFT JOIN Pedido p ON cp.id_pedido = p.id_pedido
WHERE p.id_pedido IS NULL;

-- 5. Verificar se todos os cupons aplicados existem na tabela de cupons
SELECT cp.*
FROM Cupom_Pedido cp
LEFT JOIN CupomDesconto c ON cp.id_cupom = c.id_cupom
WHERE c.id_cupom IS NULL;

-- 6. Verificar se todos os jogos em Pedido_Jogo realmente existem
SELECT pj.*
FROM Pedido_Jogo pj
LEFT JOIN Jogo j ON pj.id_jogo = j.id_jogo
WHERE j.id_jogo IS NULL;

-- 7. Verificar se todos os relacionamentos Jogo_Plataforma têm jogo e plataforma válidos
SELECT *
FROM Jogo_Plataforma jp
LEFT JOIN Jogo j ON jp.id_jogo = j.id_jogo
LEFT JOIN Plataforma p ON jp.id_plataforma = p.id_plataforma
WHERE j.id_jogo IS NULL OR p.id_plataforma IS NULL;
