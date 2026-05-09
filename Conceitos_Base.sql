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
Presença ao longo do tempo
2. “Evolução” significa quantidade ou distribuição temporal?
Distribuição temporal
3. Você precisa contar eventos ou categorias (anos)?
Nesse caso os eventos seriam a presença de clientes em anos? Se for, então eventos...
4. A granularidade final será:
   - cliente?
   - cliente + ano?
   Explique melhor o que seria granularidade.
   Se bem entendi, devo contar vezes que os clientes aparecem em cada ano para saber sua reincidencia ao longo do tempo.
5. Você quer listar ou filtrar clientes?
Acredito que filtrar as vezes que os clientes aparecem por ano.
========================================================= */

SELECT
	CustomerID,
	COUNT(DISTINCT YEAR(OrderDate)) AS AnosReincidencia
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY AnosReincidencia DESC;

-- Opção com classificação
SELECT
	CustomerID,
	COUNT(DISTINCT YEAR(OrderDate)) AS AnosReincidencia,
	CASE
		WHEN COUNT(DISTINCT YEAR(OrderDate)) < 2 THEN 'BAIXA FIDELIZAÇÃO'
		WHEN COUNT(DISTINCT YEAR(OrderDate)) BETWEEN 2 AND 3 THEN 'MÉDIA FIDELIZAÇÃO'
		ELSE 'ALTA FIDELIZAÇÃO'
	END AS Status
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY AnosReincidencia DESC;


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
Preciso saber a média da empresa para comparar com o valor dos pedidos.
2. Essa referência é por cliente ou global?
Seria global pois preciso considerar a média geral da empresa
3. A média deve ser calculada antes ou depois do filtro?
Depois do filtro
4. Você precisa comparar linha com agregado?
Acredito que não
5. Isso sugere:
   - WHERE?
   - HAVING?
   - subquery?
   Subquery.

========================================================= */
SELECT
	SalesOrderID,
	TotalDue
FROM [Sales].[SalesOrderHeader]
WHERE TotalDue > (
	SELECT 
		AVG(TotalDue) AS MediaGlobal
	FROM [Sales].[SalesOrderHeader]
)
ORDER BY TotalDue DESC;

-- Opção formatada para análise de padrão de consumo em relatório
SELECT
	SalesOrderID,
	FORMAT(TotalDue,'C','pt-BR') AS ValorPedido
FROM [Sales].[SalesOrderHeader]
WHERE TotalDue > (
	SELECT 
		AVG(TotalDue) AS MediaGlobal
	FROM [Sales].[SalesOrderHeader]
)
ORDER BY TotalDue DESC;




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
Apenas verificar a existencia.
2. Isso é validação ou agregação?
Validação
3. Você quer saber:
   - o valor máximo?
   - ou apenas se existe?
   Apenas se existe
4. Qual abordagem é mais direta:
   - EXISTS?
   - MAX + GROUP BY?
   EXISTS

========================================================= */
SELECT
	C.CustomerID
FROM [Sales].[Customer] C
WHERE EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
	AND H.TotalDue > 20000
);


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
Na tabela de Produtos
2. Você precisa agregar ou apenas ordenar?
Ambos
3. O problema pede:
   - todos os produtos?
   - ou apenas os maiores?
   Apenas os maiores
4. Faz sentido limitar resultados?
Não, pois não há uma métrica explicita que sugira isso.
5. Isso envolve:
   - ORDER BY?
   - TOP?
   ORDER BY

========================================================= */

SELECT
    ProductID,
    Name,
    ListPrice
FROM [Production].[Product]
WHERE ListPrice > 0
ORDER BY ListPrice DESC;



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
Em um cenário que ressalta receita e faturamento, o ideal seriam valores
2. Você precisa agrupar por território?
Sim, para saber qual gera mais receita
3. Qual métrica usar?
A soma dos valores por territorio
4. Como identificar o maior:
   - ORDER BY?
   - subquery?
   - TOP?
   Com ORDER BY DESC
========================================================= */
SELECT
	TerritoryID,
	SUM(TotalDue) AS Receita
FROM [Sales].[SalesOrderHeader]
GROUP BY TerritoryID
ORDER BY Receita DESC;

-- Opção visual para cenário analitico

SELECT
	TerritoryID,
	FORMAT(SUM(TotalDue),'C','pt-BR') AS Receita
FROM [Sales].[SalesOrderHeader]
GROUP BY TerritoryID
ORDER BY SUM(TotalDue) DESC;


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
Ausencia. Clientes que não constam na tabela de vendas
2. Você precisa evitar duplicidade?
Não
3. Qual abordagem é mais segura:
   - NOT EXISTS?
   - LEFT JOIN + IS NULL?
   NOT EXISTS
4. Existe risco de erro lógico com JOIN?
Somente com "JOIN" sim.
========================================================= */
-- Opção 1 (Minha escolha)
SELECT 
	C.CustomerID
FROM [Sales].[Customer] C
WHERE NOT EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
)
-- Opção 2
SELECT 
	C.CustomerID
FROM [Sales].[Customer] C
LEFT JOIN [Sales].[SalesOrderHeader] H
	ON H.CustomerID = C.CustomerID
WHERE H.CustomerID IS NULL

-- Opção 3 - Remoção dos clientes
DELETE C
FROM [Sales].[Customer] C
WHERE NOT EXISTS(
	SELECT 1 FROM [Sales].[SalesOrderHeader] H
	WHERE H.CustomerID = C.CustomerID
)

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
Ticket médio por cliente
2. Você precisa de quantos níveis?
   - pedido
   - cliente
   Cliente e valor dos pedidos
3. Precisa de subquery ou GROUP BY resolve?
GROUP BY resolve
4. A média será:
   - direta?
   - ou baseada em outro cálculo?
   Direta
========================================================= */
SELECT
	CustomerID,
	AVG(TotalDue) AS TicketMedio
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY TicketMedio DESC;

-- Opção de analise
SELECT
	CustomerID,
	FORMAT(AVG(TotalDue),'C','pt-BR') AS TicketMedio
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY AVG(TotalDue) DESC;

-- Rankeados
SELECT TOP 10
	CustomerID,
	FORMAT(AVG(TotalDue),'C','pt-BR') AS TicketMedio
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY AVG(TotalDue) DESC;


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
A quantidade de produtos em um pedido
2. Você precisa contar o quê?
Os produtos/itens
3. A granularidade final é pedido ou produto?
Por Pedido
4. O filtro ocorre antes ou depois da contagem?
Depois
5. HAVING entra aqui?
Sim

========================================================= */
SELECT
	SalesOrderID,
	SUM(OrderQty) AS QtItens_Por_Pedido
FROM [Sales].[SalesOrderDetail]
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 10
ORDER BY QtItens_Por_Pedido DESC;


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
É global. Acredito que tenho que obter a media de consumo dos clientes
2. Você precisa calcular dois níveis?
Sim, média e faturamento
3. Como comparar agregado com agregado?
Faturamento deve ser maior que a media
4. Subquery ajuda aqui?

========================================================= */
SELECT
    CustomerID,
    SUM(TotalDue) AS Faturamento
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
HAVING SUM(TotalDue) > (
    
    SELECT AVG(FaturamentoCliente)
    FROM (
        
        SELECT
            SUM(TotalDue) AS FaturamentoCliente
        FROM [Sales].[SalesOrderHeader]
        GROUP BY CustomerID

    ) AS MediaBase

)
ORDER BY Faturamento DESC;

-- OU

WITH FaturamentoClientes AS (

    SELECT
        CustomerID,
        SUM(TotalDue) AS Faturamento
    FROM [Sales].[SalesOrderHeader]
    GROUP BY CustomerID

)

SELECT
    CustomerID,
    Faturamento
FROM FaturamentoClientes
WHERE Faturamento > (

    SELECT AVG(Faturamento)
    FROM FaturamentoClientes

)
ORDER BY Faturamento DESC;

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
Quantidade
2. Você precisa somar ou contar?
Contar
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
