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
2. Você terá quantos níveis de agregação?
3. A média será de pedidos ou clientes?
4. CTE ajudaria?
5. A granularidade final será:
   - território?
   - cliente?
   - cliente dentro do território?

========================================================= */



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
2. Como separar “antigo” e “recente”?
3. DATEADD entra?
4. Quantos níveis de cálculo existirão?
5. CASE ajudaria na classificação?

========================================================= */



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
2. A média será calculada sobre quê?
3. Você precisará comparar:
   - linha com agregado?
   - agregado com agregado?
4. CTE pode melhorar legibilidade?
5. Granularidade final?

========================================================= */



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
2. O CASE dependerá de múltiplas regras?
3. COUNT DISTINCT entra?
4. Qual será a granularidade?
5. CTE ajudaria na organização?

========================================================= */



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