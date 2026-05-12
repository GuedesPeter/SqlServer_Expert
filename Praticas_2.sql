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
2. COUNT DISTINCT entra?
3. A granularidade será:
   - cliente?
   - cliente + produto?
4. HAVING faz sentido?
5. Como ordenar os clientes mais diversificados?

========================================================= */



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
2. O agrupamento será por:
   - mês?
   - ano?
3. SUM ou COUNT?
4. A granularidade final será:
   - ano?
   - ano + cliente?
5. ORDER BY ajudará na análise histórica?

========================================================= */



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
2. Você precisa:
   - validar existência?
   - medir frequência?
3. COUNT ajuda?
4. O filtro será:
   - WHERE?
   - HAVING?
5. Granularidade final?

========================================================= */



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
2. DATEADD entra?
3. EXISTS ou NOT EXISTS?
4. Quantos níveis de validação existirão?
5. CASE ajudaria?

========================================================= */



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