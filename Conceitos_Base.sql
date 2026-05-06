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
   A quantidade de produtos variados
   2. COUNT simples resolve?
   Não, no caso de produtos diferentes tenho que usar COUNT(DISTINCT)
   3. Precisa eliminar duplicidade?
   Sim,de modo a distinguir os produtos
   4. Quando usar COUNT(DISTINCT)?
   No SELECT para contar os produtos distintos que o cliente possui e no HAVING para filtrar pelos clientes que possuem 
   mais de 1 produto diferente
   ========================================================= */

    SELECT
		H.CustomerID,
		COUNT(DISTINCT S.ProductID) AS Prod_Distintos
	FROM [Sales].[SalesOrderHeader] H
	JOIN [Sales].[SalesOrderDetail] S
	ON S.SalesOrderID = H.SalesOrderID
	GROUP BY H.CustomerID
	HAVING COUNT(DISTINCT S.ProductID) > 1
	ORDER BY Prod_Distintos DESC;


	
   /* =========================================================
   🎯 CENÁRIO:
   Identificar inconsistências nos dados.

   Regra:
   👉 Pedidos sem TerritoryID

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. Qual tipo de problema é esse?
   Falta de informação do TerritoryID em alguns pedidos
   (Contém valores Nulos)
   2. Como detectar ausência de valor?
   Verificando se o TerritoryID está vazio (NULL)
   3. Qual operador usar?
   IS NULL
   ========================================================= */
SELECT
SalesOrderID,
TerritoryID
FROM [Sales].[SalesOrderHeader]
WHERE TerritoryID IS NULL;

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
   Preciso calcular os gastos de cada cliente
   2. Como criar categorias?
   Baseando-se no valor dos gastos de cada cliente
   3. Qual estrutura usar?
   Nesse caso vou utilizar o CASE.
   ========================================================= */

SELECT 
    CustomerID,
    SUM(TotalDue) AS TotalGasto,
    CASE 
        WHEN SUM(TotalDue) > 100000 THEN 'VIP'
        WHEN SUM(TotalDue) BETWEEN 50000 AND 100000 THEN 'MÉDIO'
        ELSE 'BAIXO'
    END AS NivelGasto
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalGasto DESC;



   /* =========================================================
   🎯 CENÁRIO:
   Você trabalha como analista de estoque e precisa identificar
produtos que NÃO tiveram saída (vendas).

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. É presença ou ausência?
   Ausencia. Produtos que não estão na tabela de vendas
   2. EXISTS ou NOT EXISTS?
   NOT EXISTS
   3. JOIN resolveria melhor?
   Creio que não.
   ========================================================= */
   SELECT 
	P.ProductID,
	P.Name
   FROM [Production].[Product] P
   WHERE NOT EXISTS(
   SELECT 1 FROM Sales.SalesOrderDetail D
   WHERE D.ProductID = P.ProductID
   );

   -- Opção com LEFT JOIN (Menos Performática em Produção)
   SELECT
	P.ProductID,
	P.Name
   FROM [Production].[Product] P
   LEFT JOIN Sales.SalesOrderDetail D
   ON D.ProductID = P.ProductID
   WHERE D.ProductID IS NULL;

   /* =========================================================
   🎯 CENÁRIO:
   Identificar clientes recorrentes ao longo do tempo.

   Regra:
   👉 Cliente comprou em mais de um ano

   ---------------------------------------------------------

   🧠 PENSAMENTO:

   1. O que precisa contar?
  A quantidade de pedidos por ano.
   2. Como identificar anos?
   Pela data de realização do pedido
   3. Precisa DISTINCT?
  SIM
   4. HAVING entra?
   Sim.
   ========================================================= */
SELECT
    CustomerID,
    COUNT(DISTINCT YEAR(OrderDate)) AS QtAnos
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(DISTINCT YEAR(OrderDate)) > 1
ORDER BY QtAnos DESC;


   /* =========================================================
🧠 EX 1 — EVOLUÇÃO DE CLIENTES AO LONGO DO TEMPO
=========================================================

🎯 CENÁRIO:
O time de retenção quer entender se os clientes continuam comprando ao longo dos anos
ou se concentram suas compras em períodos específicos.

Clientes que aparecem em vários anos indicam maior fidelização.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Você precisa analisar o comportamento dos clientes ao longo do tempo,
identificando sua presença em diferentes anos.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Você quer analisar volume de pedidos ou presença ao longo do tempo?
2. “Evolução” significa quantidade ou distribuição temporal?
3. Você precisa contar eventos ou categorias (anos)?
4. A granularidade final será:
   - cliente?
   - cliente + ano?
5. Você quer listar ou filtrar clientes?

========================================================= */


/* =========================================================
🧠 EX 2 — PEDIDOS ACIMA DO PADRÃO
=========================================================

🎯 CENÁRIO:
O financeiro quer identificar pedidos fora do padrão normal de consumo.

Pedidos muito acima da média podem indicar grandes oportunidades
ou possíveis inconsistências.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Identificar pedidos cujo valor é superior à média geral da empresa.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Você precisa de uma referência — qual?
2. Essa referência é por cliente ou global?
3. A média deve ser calculada antes ou depois do filtro?
4. Você precisa comparar linha com agregado?
5. Isso sugere:
   - WHERE?
   - HAVING?
   - subquery?

========================================================= */


/* =========================================================
🧠 EX 3 — CLIENTES COM GRANDES COMPRAS INDIVIDUAIS
=========================================================

🎯 CENÁRIO:
O time comercial quer identificar clientes que já fizeram compras expressivas,
mesmo que não sejam frequentes.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar clientes que possuem pelo menos UM pedido acima de 20000.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Você precisa analisar todos os pedidos ou apenas verificar existência?
2. Isso é validação ou agregação?
3. Você quer saber:
   - o valor máximo?
   - ou apenas se existe?
4. Qual abordagem é mais direta:
   - EXISTS?
   - MAX + GROUP BY?

========================================================= */


/* =========================================================
🧠 EX 4 — PRODUTOS DE ALTO VALOR
=========================================================

🎯 CENÁRIO:
A empresa quer destacar produtos premium para campanhas específicas.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Identificar os produtos com maior preço de tabela.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Onde está o preço do produto?
2. Você precisa agregar ou apenas ordenar?
3. O problema pede:
   - todos os produtos?
   - ou apenas os maiores?
4. Faz sentido limitar resultados?
5. Isso envolve:
   - ORDER BY?
   - TOP?

========================================================= */


/* =========================================================
🧠 EX 5 — MELHOR TERRITÓRIO
=========================================================

🎯 CENÁRIO:
A diretoria quer saber qual região gera mais receita.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Identificar o território com maior faturamento total.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O que define “melhor”? (quantidade ou valor?)
2. Você precisa agrupar por território?
3. Qual métrica usar?
4. Como identificar o maior:
   - ORDER BY?
   - subquery?
   - TOP?

========================================================= */


/* =========================================================
🧠 EX 6 — CLIENTES TOTALMENTE INATIVOS
=========================================================

🎯 CENÁRIO:
A empresa quer limpar sua base e identificar clientes que nunca compraram.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar clientes sem qualquer registro de compra.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Isso é presença ou ausência?
2. Você precisa evitar duplicidade?
3. Qual abordagem é mais segura:
   - NOT EXISTS?
   - LEFT JOIN + IS NULL?
4. Existe risco de erro lógico com JOIN?

========================================================= */


/* =========================================================
🧠 EX 7 — COMPORTAMENTO DE COMPRA (TICKET MÉDIO)
=========================================================

🎯 CENÁRIO:
O time quer entender o padrão médio de compra dos clientes.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Calcular o ticket médio por cliente.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O cálculo é por pedido ou por cliente?
2. Você precisa de quantos níveis?
   - pedido
   - cliente
3. Precisa de subquery ou GROUP BY resolve?
4. A média será:
   - direta?
   - ou baseada em outro cálculo?

========================================================= */


/* =========================================================
🧠 EX 8 — PEDIDOS COM MUITOS ITENS
=========================================================

🎯 CENÁRIO:
A logística quer identificar pedidos grandes para planejamento.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar pedidos com mais de 10 itens.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O que representa “item”?
2. Você precisa contar o quê?
3. A granularidade final é pedido ou produto?
4. O filtro ocorre antes ou depois da contagem?
5. HAVING entra aqui?

========================================================= */


/* =========================================================
🧠 EX 9 — CLIENTES ACIMA DA MÉDIA
=========================================================

🎯 CENÁRIO:
O marketing quer focar nos clientes acima da média de consumo.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Identificar clientes cujo faturamento total é superior à média da base.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. A média é global ou por grupo?
2. Você precisa calcular dois níveis?
3. Como comparar agregado com agregado?
4. Subquery ajuda aqui?

========================================================= */


/* =========================================================
🧠 EX 10 — PRODUTOS POUCO VENDIDOS
=========================================================

🎯 CENÁRIO:
O estoque quer identificar produtos com baixa saída.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar produtos com baixo volume de vendas.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. “baixo” significa quantidade ou valor?
2. Você precisa somar ou contar?
3. O filtro ocorre depois da agregação?
4. HAVING entra?

========================================================= */


/* =========================================================
🧠 EX 11 — RELATÓRIO EXECUTIVO (COMPLETO)
=========================================================

🎯 CENÁRIO:
A diretoria quer um resumo completo dos clientes.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Para cada cliente, apresentar:
- quantidade de pedidos
- faturamento total
- classificação por nível de gasto

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Quantas métricas você precisa calcular?
2. Todas estão no mesmo nível?
3. O CASE depende de qual cálculo?
4. Qual é a granularidade final?
5. Qual a ordem mental correta:
   (agrupamento → cálculo → classificação)

========================================================= */
