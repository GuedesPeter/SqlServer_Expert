USE AdventureWorks
GO

/* =========================================================
🧠 EX 1 — CLIENTES ACIMA DA MÉDIA DO TERRITÓRIO
=========================================================

🎯 CENÁRIO:
A diretoria percebeu que alguns territórios possuem clientes muito acima
do comportamento médio regional.

O objetivo é identificar clientes cujo faturamento seja superior
à média de faturamento do próprio território.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Comparar clientes com a média regional de consumo.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. A comparação é global ou segmentada?
Segmentada por território
2. Você terá quantos níveis de agregação?
Pelo que vejo dois: Cliente e território
3. A média será de pedidos ou clientes?
Será referente a média dos faturamentos dos clientes
4. CTE ajudaria?
Sim
5. A granularidade final será:
   - território?
   - cliente?
   - cliente dentro do território?
   Cliente + Territorio -> Territorio
========================================================= */
WITH FaturamentoCliente AS (

	SELECT
		CustomerID,
		TerritoryID,
		SUM(TotalDue) AS Faturamento
	FROM [Sales].[SalesOrderHeader]
	GROUP BY CustomerID,TerritoryID
),
MediaTerritorio AS (
	SELECT
		TerritoryID,
		AVG(Faturamento) AS MediaFaturamento
	FROM FaturamentoCliente
	GROUP BY TerritoryID
	
)
SELECT
	C.CustomerID,
	FORMAT(C.Faturamento,'C','pt-BR') AS FatCliente,
	FORMAT(M.MediaFaturamento,'C','pt-BR') AS MedRegiao
FROM FaturamentoCliente C
JOIN MediaTerritorio M
ON M.TerritoryID = C.TerritoryID
WHERE C.Faturamento > M.MediaFaturamento



/* =========================================================
🧠 EX 2 — CLIENTES COM QUEDA DE CONSUMO
=========================================================

🎯 CENÁRIO:
O time de retenção quer identificar clientes que reduziram fortemente
suas compras ao longo do tempo.

Clientes que compravam muito e hoje compram pouco
podem indicar risco de churn.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Comparar faturamento antigo vs recente dos clientes.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Você precisará dividir períodos?
Sim
2. Como separar “antigo” e “recente”?
Definindo uma métrica com base nas datas de pedidos dispostas na base de dados
3. DATEADD entra?
Não utilizei na soluçãi
4. Quantos níveis de cálculo existirão?
Apenas um, a soma.
5. CASE ajudaria na classificação?
Sim.

========================================================= */
WITH Antigo AS (

	SELECT
		CustomerID,
		SUM(TotalDue) AS Fatura1
	FROM [Sales].[SalesOrderHeader]
	WHERE OrderDate BETWEEN '2011-01-01' AND '2012-12-31'
	GROUP BY CustomerID
),
Recente AS (
	
	SELECT
		CustomerID,
		SUM(TotalDue) AS Fatura2
	FROM [Sales].[SalesOrderHeader]
	WHERE OrderDate BETWEEN '2013-01-01' AND '2014-12-31'
	GROUP BY CustomerID
)
SELECT
    A.CustomerID,
    A.Fatura1 AS FaturamentoAntigo,
    R.Fatura2 AS FaturamentoRecente,
    CASE
        WHEN R.Fatura2 > A.Fatura1 THEN 'Cliente Recente'
        WHEN R.Fatura2 = A.Fatura1 THEN 'Cliente Equilibrado'
        ELSE 'Risco de Churn'
    END AS Status
FROM Antigo A
JOIN Recente R 
    ON R.CustomerID = A.CustomerID;

-- Opção para análise do time de retenção

WITH Antigo AS (

	SELECT
		CustomerID,
		SUM(TotalDue) AS Fatura1
	FROM [Sales].[SalesOrderHeader]
	WHERE OrderDate BETWEEN '2011-01-01' AND '2012-12-31'
	GROUP BY CustomerID
),
Recente AS (
	
	SELECT
		CustomerID,
		SUM(TotalDue) AS Fatura2
	FROM [Sales].[SalesOrderHeader]
	WHERE OrderDate BETWEEN '2013-01-01' AND '2014-12-31'
	GROUP BY CustomerID
)
SELECT
    A.CustomerID,
    FORMAT(A.Fatura1,'C','pt-BR') AS FaturamentoAntigo,
    FORMAT(R.Fatura2,'C','pt-BR') AS FaturamentoRecente,
    CASE
        WHEN R.Fatura2 > A.Fatura1 THEN 'Cliente Recente'
        WHEN R.Fatura2 = A.Fatura1 THEN 'Cliente Equilibrado'
        ELSE 'Risco de Churn'
    END AS Status
FROM Antigo A
JOIN Recente R 
    ON R.CustomerID = A.CustomerID
ORDER BY Status DESC; -- Prioriza os clientes com riscos



/* =========================================================
🧠 EX 3 — PRODUTOS COM VENDA ACIMA DA MÉDIA
=========================================================

🎯 CENÁRIO:
O estoque quer entender quais produtos performam acima
do padrão médio da empresa.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar produtos cuja quantidade vendida
supera a média dos demais produtos.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. “performance” significa:
   - valor?
   - quantidade?
   Quantidade
2. A média será calculada sobre quê?
Sobre a quantidade geral dos produtos vendidos
3. Você precisará comparar:
   - linha com agregado?
   - agregado com agregado?
   Linha com agregado
4. CTE pode melhorar legibilidade?
ACredito que sim possibilitando comparar a media geral com as quantidades acima da media
5. Granularidade final?
1 linha = Produto + Media + quantidade
========================================================= */
WITH SomaProd AS (

	SELECT
		ProductID,
		SUM(OrderQty) AS QtSomada
	FROM [Sales].[SalesOrderDetail]
	GROUP BY ProductID
),
MediaProd AS (
	SELECT
		AVG(QtSomada) AS Media
	FROM SomaProd
)
SELECT
	S.ProductID,
	S.QtSomada,
	M.Media
FROM SomaProd S
CROSS JOIN MediaProd M
WHERE S.QtSomada > M.Media
ORDER BY S.QtSomada DESC;



/* =========================================================
🧠 EX 4 — CLASSIFICAÇÃO AVANÇADA DE CLIENTES
=========================================================

🎯 CENÁRIO:
A empresa quer segmentar clientes para campanhas específicas.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Criar classificação considerando:
- quantidade de pedidos
- faturamento
- recorrência em anos distintos

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Quantas métricas existirão?
3 metricas
2. O CASE dependerá de múltiplas regras?
Sim, mas vamos visualizar passo a passo isso
3. COUNT DISTINCT entra?
Sim, para atuar na distinção dos anos
4. Qual será a granularidade?
1 linha = 1 cliente
5. CTE ajudaria na organização?
Acredito que sim, de modo a isolar cada métrica
========================================================= */
-- Solução Inicial
WITH EtapaPedidos AS (
	SELECT
		CustomerID,
		COUNT(SalesOrderID) AS QtPedidos,
		CASE
			WHEN COUNT(SalesOrderID) <= 4 THEN 'Baixo Fluxo'
			WHEN COUNT(SalesOrderID) BETWEEN 5 AND 10 THEN 'Fluxo Regular'
			ELSE 'Alto Fluxo'
		END AS StatusPedidos
	FROM [Sales].[SalesOrderHeader]
	GROUP BY CustomerID
),
EtapaFaturamento AS (
		SELECT
		CustomerID,
		SUM(TotalDue) AS Faturamento,
		CASE
			WHEN SUM(TotalDue)  < 10000 THEN 'Baixo Faturamento'
			WHEN SUM(TotalDue)  BETWEEN 10000 AND 40000 THEN 'Faturamento Regular'
			ELSE 'Alto Faturamento'
		END AS StatusFaturamento
	FROM [Sales].[SalesOrderHeader]
	GROUP BY CustomerID
),
EtapaTempo AS (
		SELECT
		CustomerID,
		COUNT(DISTINCT YEAR(OrderDate)) AS AnosComVendas,
		CASE
			WHEN COUNT(DISTINCT YEAR(OrderDate)) < 2 THEN 'Baixa recorrencia'
			WHEN COUNT(DISTINCT YEAR(OrderDate)) BETWEEN 2 AND 3 THEN 'Recorrencia Regular'
			ELSE 'Alta Recorrencia'
		END AS RecorrenciaAnual
	FROM [Sales].[SalesOrderHeader]
	GROUP BY CustomerID
)
SELECT 
	E1.CustomerID,
	E2.Faturamento,
	E3.AnosComVendas,
	E1.StatusPedidos,
	E2.StatusFaturamento,
	E3.RecorrenciaAnual
FROM EtapaPedidos E1
JOIN EtapaFaturamento E2
	ON E2.CustomerID = E1.CustomerID
JOIN EtapaTempo E3
	ON E3.CustomerID = E1.CustomerID
ORDER BY E1.CustomerID;

-- Estrutura Ideal
WITH BaseClientes AS (
    SELECT
        CustomerID,
        COUNT(SalesOrderID) AS QtPedidos,
        SUM(TotalDue) AS Faturamento,
        COUNT(DISTINCT YEAR(OrderDate)) AS AnosComVendas
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    Faturamento,
    AnosComVendas,

    CASE
        WHEN QtPedidos <= 4 THEN 'Baixo Fluxo'
        WHEN QtPedidos BETWEEN 5 AND 10 THEN 'Fluxo Regular'
        ELSE 'Alto Fluxo'
    END AS StatusPedidos,

    CASE
        WHEN Faturamento < 10000 THEN 'Baixo Faturamento'
        WHEN Faturamento BETWEEN 10000 AND 40000 THEN 'Faturamento Regular'
        ELSE 'Alto Faturamento'
    END AS StatusFaturamento,

    CASE
        WHEN AnosComVendas < 2 THEN 'Baixa Recorrencia'
        WHEN AnosComVendas BETWEEN 2 AND 3 THEN 'Recorrencia Regular'
        ELSE 'Alta Recorrencia'
    END AS RecorrenciaAnual

FROM BaseClientes
ORDER BY CustomerID;




/* =========================================================
🧠 EX 5 — PEDIDOS FORA DO PADRÃO DO CLIENTE
=========================================================

🎯 CENÁRIO:
O financeiro suspeita de pedidos anormais.

Alguns pedidos podem estar muito acima
do comportamento normal do próprio cliente.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar pedidos acima da média individual do cliente.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. A média é global ou individual?
2. Quantos níveis de agregação existem?
3. Você comparará:
   - pedido vs cliente?
4. Subquery ou CTE?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 6 — PRODUTOS NUNCA VENDIDOS NOS ÚLTIMOS 3 ANOS
=========================================================

🎯 CENÁRIO:
O estoque quer revisar produtos obsoletos.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar produtos sem vendas recentes.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Isso é presença ou ausência?
2. EXISTS ou NOT EXISTS?
3. Onde entra o filtro de data?
4. DATEADD será necessário?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 7 — RELATÓRIO EXECUTIVO COM CTE
=========================================================

🎯 CENÁRIO:
A diretoria quer um relatório consolidado dos clientes.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Para cada cliente:
- total de pedidos
- faturamento
- ticket médio
- classificação

Mas agora o relatório deve ser construído usando CTE.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O que deve ficar dentro da CTE?
2. O CASE depende de quais métricas?
3. Quais cálculos podem ser reaproveitados?
4. Qual a granularidade?
5. Como melhorar legibilidade?

========================================================= */



/* =========================================================
🧠 EX 8 — CLIENTES COM COMPORTAMENTO IRREGULAR
=========================================================

🎯 CENÁRIO:
O time comercial quer identificar clientes inconsistentes.

Clientes que alternam anos de compra e ausência
podem indicar comportamento irregular.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Identificar clientes que compraram em poucos anos,
mesmo estando cadastrados há muito tempo.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. COUNT DISTINCT entra?
2. Como medir recorrência?
3. DATEADD ajudaria?
4. CASE faz sentido?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 9 — MANUTENÇÃO DE BASE (UPDATE)
=========================================================

🎯 CENÁRIO:
A empresa decidiu marcar clientes VIP
para futuras campanhas exclusivas.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Atualizar clientes cujo faturamento total
ultrapassa determinado valor.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O UPDATE atuará diretamente?
2. Você validaria antes com SELECT?
3. EXISTS ajuda?
4. Como evitar atualização incorreta?
5. CTE pode ajudar?

========================================================= */



/* =========================================================
🧠 EX 10 — LIMPEZA CONTROLADA DE DADOS
=========================================================

🎯 CENÁRIO:
A empresa deseja remover produtos
que nunca foram vendidos.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Excluir produtos sem histórico de vendas.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. DELETE direto é seguro?
2. Como validar antes?
3. NOT EXISTS entra?
4. Existe risco operacional?
5. TRANSACTION faria sentido futuramente?

========================================================= */