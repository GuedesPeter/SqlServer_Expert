USE AdventureWorks
GO

/* =========================================================
🧠 EX 11 — CLIENTES COM MAIOR VARIEDADE DE PRODUTOS
=========================================================

🎯 CENÁRIO:
O time comercial quer identificar clientes com perfil de compra diversificado.

Clientes que compram muitos tipos diferentes de produtos
costumam responder melhor a campanhas amplas.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Identificar clientes com alta variedade de produtos comprados.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. “variedade” significa:
   - quantidade total?
   - produtos distintos?
Produtos Distintos
2. COUNT DISTINCT entra?
Sim
3. A granularidade será:
   - cliente?
   - cliente + produto?
Cliente + Produtos distintos
4. HAVING faz sentido?
Não pois não há uma métrica a comprara, por exemplo
5. Como ordenar os clientes mais diversificados?
ORDER BY DESC. (Com produtos mais diversificados para os menos)

========================================================= */

SELECT
	H.CustomerID AS Cliente,
	COUNT(DISTINCT D.ProductID) AS ProdutosDistintos
FROM [Sales].[SalesOrderHeader] H
JOIN [Sales].[SalesOrderDetail] D
 ON D.SalesOrderID = H.SalesOrderID
GROUP BY H.CustomerID
ORDER BY ProdutosDistintos DESC;

/* =========================================================
🧠 EX 12 — ANÁLISE DE CRESCIMENTO ANUAL
=========================================================

🎯 CENÁRIO:
A diretoria quer acompanhar a evolução do faturamento ao longo dos anos.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Comparar o faturamento anual da empresa.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Qual dimensão temporal será usada?
Anos
2. O agrupamento será por:
   - mês?
   - ano?
Por ano
3. SUM ou COUNT?
Se tratando de faturamento, SUM()
4. A granularidade final será:
   - ano?
   - ano + cliente?
Ano
5. ORDER BY ajudará na análise histórica?
Ajuda na ordenação dos anos

========================================================= */
SELECT
	YEAR(OrderDate) AS Ano,
	SUM(TotalDue) AS Faturamento
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR(OrderDate)
ORDER BY Ano;

-- Opção formatada apenas para relatório visual de análise

SELECT
	YEAR(OrderDate) AS Ano,
	FORMAT(SUM(TotalDue),'C','pt-BR') AS Faturamento
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR(OrderDate)
ORDER BY Ano;

-- Opção para análise mostrando os anos com maior Faturamento

SELECT
	YEAR(OrderDate) AS Ano,
	FORMAT(SUM(TotalDue),'C','pt-BR') AS Faturamento
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR(OrderDate)
ORDER BY SUM(TotalDue) DESC;

/* =========================================================
🧠 EX 13 — PRODUTOS COM ALTA DEPENDÊNCIA DE DESCONTO
=========================================================

🎯 CENÁRIO:
O financeiro quer identificar produtos que dependem muito
de descontos para vender.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar produtos frequentemente vendidos com desconto.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Onde está a informação de desconto?
Na tabela de detalhes da venda
2. Você precisa:
   - validar existência?
   - medir frequência?
Frequencia
3. COUNT ajuda?
Ajuda na contagem dos produtos que foram vendidos com desconto
possibilitando visualizar quantas vezes ele fora vendido assim.
O cenário não solicita que eu conte, mas sim que eu apenas identifique.
4. O filtro será:
   - WHERE?
   - HAVING?
WHERE
5. Granularidade final?
Produto.
========================================================= */
	SELECT 
		D.ProductID AS IdProduto,
		P.Name AS Produto,
		COUNT(D.ProductID) AS QtProd_Vendido_Com_Desconto
	FROM [Sales].[SalesOrderDetail] D
	JOIN [Production].[Product] P 
	 ON P.ProductID = D.ProductID
	WHERE D.UnitPriceDiscount > 0
	GROUP BY D.ProductID, P.Name	
	ORDER BY QtProd_Vendido_Com_Desconto DESC;



/* =========================================================
🧠 EX 14 — CLIENTES SEM COMPRAS RECENTES MAS COM HISTÓRICO FORTE
=========================================================

🎯 CENÁRIO:
O marketing quer recuperar clientes antigos de alto valor.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar clientes que:
- já gastaram muito
- mas não compram há mais de 2 anos

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Você terá:
   - condição de presença?
   - condição de ausência?
Ausencia
2. DATEADD entra?
Não pois não quero pegar a data atual (ano de 2026) para me basear na lógica.
3. EXISTS ou NOT EXISTS?
NOT EXISTS
4. Quantos níveis de validação existirão?
Visualizo dois, tempo e faturamento
5. CASE ajudaria?
Sem pensar em query, visualizando o cenário, acredito que não pois inicialmente eu não vejo uma ideia de classificação.
========================================================= */
SELECT
    H.CustomerID AS Cliente,
    SUM(H.TotalDue) AS Faturamento
FROM Sales.SalesOrderHeader H
WHERE NOT EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader S
    WHERE S.CustomerID = H.CustomerID
      AND S.OrderDate > '20130101'
)
GROUP BY
    H.CustomerID
ORDER BY
    Faturamento DESC;



/* =========================================================
🧠 EX 15 — TERRITÓRIOS COM QUEDA DE FATURAMENTO
=========================================================

🎯 CENÁRIO:
A diretoria suspeita que algumas regiões perderam força comercial.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Comparar faturamento antigo vs recente por território.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Você precisará separar períodos?
2. O agrupamento será:
   - território?
   - território + ano?
3. DATEADD ajudará?
4. SUM será suficiente?
5. CTE pode organizar melhor?

========================================================= */



/* =========================================================
🧠 EX 16 — PEDIDOS COM MUITOS PRODUTOS DIFERENTES
=========================================================

🎯 CENÁRIO:
A logística quer identificar pedidos complexos de separar.

Pedidos com muitos produtos distintos
exigem maior esforço operacional.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar pedidos com alta variedade de produtos.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Você precisa medir:
   - quantidade total?
   - diversidade?
2. COUNT DISTINCT entra?
3. Granularidade final?
4. HAVING será necessário?
5. ORDER BY ajuda na priorização?

========================================================= */



/* =========================================================
🧠 EX 17 — CLIENTES ACIMA DA MÉDIA DE PEDIDOS
=========================================================

🎯 CENÁRIO:
O comercial quer identificar clientes com frequência acima do padrão.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar clientes cuja quantidade de pedidos
supera a média da base.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. A média será de:
   - pedidos?
   - faturamento?
2. Quantos níveis de agregação existirão?
3. Subquery ou CTE?
4. Você comparará:
   - agregado com agregado?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 18 — MANUTENÇÃO DE DADOS (UPDATE COM CASE)
=========================================================

🎯 CENÁRIO:
A empresa decidiu categorizar automaticamente clientes
com base no faturamento.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Atualizar uma coluna de classificação:
- VIP
- MÉDIO
- BÁSICO

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O CASE será usado onde?
2. UPDATE direto é seguro?
3. Vale validar antes com SELECT?
4. EXISTS ajudaria?
5. CTE pode organizar os cálculos?

========================================================= */



/* =========================================================
🧠 EX 19 — IDENTIFICAÇÃO DE PEDIDOS DUPLICADOS
=========================================================

🎯 CENÁRIO:
O financeiro suspeita de registros duplicados
gerados por falhas operacionais.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Identificar possíveis pedidos repetidos.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O que caracteriza duplicidade?
2. GROUP BY ajudaria?
3. HAVING entra?
4. COUNT será usado para quê?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 20 — PREPARAÇÃO PARA REMOÇÃO EM MASSA
=========================================================

🎯 CENÁRIO:
A empresa deseja remover registros antigos,
mas antes precisa validar impacto.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Identificar pedidos antigos candidatos à exclusão.

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. DELETE deve ser imediato?
2. DATEADD ajudará?
3. Vale começar com SELECT?
4. TRANSACTION faria sentido?
5. Como evitar remoções incorretas?

========================================================= */