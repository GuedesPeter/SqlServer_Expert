USE AdventureWorks
GO

/* =========================================================
   🎯 CENÁRIO:
   O time de marketing quer focar em clientes ativos recentemente.

   Regra:
   👉 Cliente recente = fez pedido nos últimos 365 dias

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. O que define "recente"?
   Os pedidos realizado nos últimos 365 dias
   2. Onde está a data?
   Na tabela de Vendas/Pedidos
   3. Você precisa verificar existência ou calcular algo?
   Preciso verificar se existem pedidos para um determinado cliente no último ano
   4. O filtro de data acontece dentro ou fora da subquery?
   Ocorre dentro.
   5. Granularidade final?
   Filtrar os clientes que possuem algum pedido no último ano.

   ========================================================= */
SELECT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderHeader] S
	WHERE S.CustomerID = C.CustomerID
	AND S.OrderDate >= DATEADD(YEAR, -1, GETDATE()) -- “data atual - 1 ano” : ✔ Isso resolve o “últimos 365 dias” de forma dinâmica
);


   /* =========================================================
   🎯 CENÁRIO:
   A empresa quer recuperar clientes inativos.

   Regra:
   👉 Cliente alvo = NÃO comprou nos últimos 2 anos

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Você está buscando presença ou ausência?
   Ausencia (Clientes nos quais NÃO existem pedidos nos ultimos 2 anos)
   2. Qual operador resolve melhor isso?
   NOT EXISTS
   3. Onde aplicar o filtro de data?
   Dentro da subquery
   4. Como evitar erro lógico com clientes antigos?
   Verificando se o cliente comprou ou não nos últimos 2 anos

   ========================================================= */
   SELECT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE NOT EXISTS (
	SELECT 1 FROM [Sales].[SalesOrderHeader] S
	WHERE S.CustomerID = C.CustomerID
	AND S.OrderDate >= DATEADD(YEAR, -2, GETDATE()) 
);


   /* =========================================================
   🎯 CENÁRIO:
   O financeiro quer analisar pedidos relevantes.

   Regra:
   👉 Pedido grande = TotalDue > 5000

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Você precisa agrupar?
   No caso que estou atuando, como não existem pedidos repetidos, não preciso agrupar
   2. Ou apenas filtrar?
   Filtrar  se aplica.
   3. Qual cláusula resolve direto?
   No meu cenário o WHERE resolve, mas posso fazer uma opção utilizando GROUP BY E HAVING
   4. Granularidade?
   Agrupar os pedidos que possuem TotalDue > 5000
   ========================================================= */
   -- Aqui já atende
   SELECT
	SalesOrderID,
	TotalDue
   FROM [Sales].[SalesOrderHeader]
   WHERE TotalDue > 5000
   ORDER BY TotalDue DESC;

   -- OU opção com agrupamento.
   SELECT
	SalesOrderID,
	SUM(TotalDue) AS PedRelevantes
   FROM [Sales].[SalesOrderHeader]
   GROUP BY SalesOrderID
   HAVING SUM(TotalDue) > 5000
   ORDER BY PedRelevantes DESC;
   


   /* =========================================================
   🎯 CENÁRIO:
   A empresa quer saber quantos produtos diferentes já foram vendidos.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. O que significa “diferente”?
   Produtos distintos.
   2. COUNT resolve sozinho?
   Nesse caso se aplica o COUNT DISTINCT
   3. Qual função evita duplicidade?
   DISTINCT

   ========================================================= */
SELECT
	COUNT(DISTINCT ProductID) AS Prod_Distintos
FROM [Sales].[SalesOrderDetail];
-- Nota:
--Se a pergunta for:
--“quantos X diferentes”
--→ pense primeiro em COUNT(DISTINCT)


   /* =========================================================
   🎯 CENÁRIO:
   O time quer identificar clientes com consumo variado.

   Regra:
   👉 Cliente comprou MAIS DE UM produto diferente

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. O que você precisa contar?
   2. COUNT simples resolve?
   3. Precisa eliminar duplicidade?
   4. Quando usar COUNT(DISTINCT)?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Identificar inconsistências nos dados.

   Regra:
   👉 Pedidos sem TerritoryID

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Qual tipo de problema é esse?
   2. Como detectar ausência de valor?
   3. Qual operador usar?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Classificar clientes por nível de gasto.

   Regras:
   - > 100000 → VIP
   - entre 50000 e 100000 → Médio
   - < 50000 → Baixo

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Você precisa calcular algo antes?
   2. Como criar categorias?
   3. Qual estrutura usar?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Identificar produtos sem saída.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. É presença ou ausência?
   2. EXISTS ou NOT EXISTS?
   3. JOIN resolveria melhor?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Identificar clientes recorrentes ao longo do tempo.

   Regra:
   👉 Cliente comprou em mais de um ano

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. O que precisa contar?
   2. Como identificar anos?
   3. Precisa DISTINCT?
   4. HAVING entra?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Analisar evolução de clientes ao longo do tempo.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Quantas dimensões existem?
   2. Como combinar ano + cliente?
   3. Qual métrica usar?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Analisar evolução de clientes ao longo do tempo.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Quantas dimensões existem?
   2. Como combinar ano + cliente?
   3. Qual métrica usar?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Identificar pedidos acima do padrão.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Você precisa comparar com quê?
   2. Como calcular média geral?
   3. Subquery entra aqui?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Identificar clientes com grandes compras individuais.

   Regra:
   👉 Pelo menos 1 pedido acima de 20000

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. EXISTS ou agregação?
   2. MAX ajuda?
   3. Qual abordagem é mais simples?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Identificar produtos de alto valor.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Onde está o preço?
   2. Você precisa ordenar?
   3. TOP pode ser usado?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Encontrar o melhor território.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Precisa agrupar?
   2. Como identificar o maior?
   3. ORDER BY ou subquery?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Base de clientes inativos total.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. NOT EXISTS ou LEFT JOIN?
   2. Como evitar erro lógico?
   3. Qual abordagem é mais segura?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Entender comportamento de compra.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Primeiro nível: pedido
   2. Segundo nível: média
   3. Subquery ajuda?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Identificar pedidos grandes em volume.

   Regra:
   👉 Pedido com mais de 10 itens

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. O que contar?
   2. Agrupamento por quê?
   3. HAVING entra?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Identificar clientes acima da média da base.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Comparar com média global?
   2. Subquery?
   3. SUM + comparação?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Identificar produtos pouco vendidos.

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Soma ou contagem?
   2. Qual métrica define “baixo”?
   3. HAVING entra?

   ========================================================= */

   /* =========================================================
   🎯 CENÁRIO:
   Relatório executivo.

   Para cada cliente:
   - quantidade de pedidos
   - faturamento total
   - classificação (CASE)

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Múltiplas métricas?
   2. CASE entra onde?
   3. Granularidade?
   4. Ordem de execução mental?

   ========================================================= */
