/* =========================================================
🧠 EX 21 — FUNCIONÁRIOS COM MAIS HORAS DE FÉRIAS
=========================================================

🎯 CENÁRIO:
O RH quer identificar funcionários com maior saldo de férias
para planejar períodos de ausência.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar funcionários com maior quantidade de horas disponíveis de férias.

---------------------------------------------------------

📌 TABELAS SUGERIDAS:
- HumanResources.Employee
- HumanResources.EmployeePayHistory

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Onde estão as informações do funcionário?
2. Existe necessidade de agregação?
3. Você precisará ordenar?
4. TOP faria sentido?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 22 — DEPARTAMENTOS COM MAIS FUNCIONÁRIOS
=========================================================

🎯 CENÁRIO:
A diretoria quer entender como os colaboradores
estão distribuídos entre os departamentos.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Identificar departamentos com maior número de funcionários ativos.

---------------------------------------------------------

📌 TABELAS SUGERIDAS:
- HumanResources.EmployeeDepartmentHistory
- HumanResources.Department

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O que deve ser contado?
2. Como identificar funcionários ativos?
3. GROUP BY entra?
4. HAVING faz sentido?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 23 — PRODUTOS COM MAIOR TEMPO DE FABRICAÇÃO
=========================================================

🎯 CENÁRIO:
A produção quer identificar produtos
com maior tempo médio de fabricação.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Analisar produtos mais caros operacionalmente em tempo produtivo.

---------------------------------------------------------

📌 TABELAS SUGERIDAS:
- Production.Product
- Production.WorkOrder

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Qual métrica representa esforço produtivo?
2. Você precisará somar ou calcular média?
3. GROUP BY será por:
   - produto?
   - ordem?
4. ORDER BY ajudará?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 24 — FORNECEDORES COM MAIS PRODUTOS
=========================================================

🎯 CENÁRIO:
O setor de compras quer identificar fornecedores estratégicos.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar fornecedores que abastecem maior quantidade de produtos.

---------------------------------------------------------

📌 TABELAS SUGERIDAS:
- Purchasing.ProductVendor
- Purchasing.Vendor

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O que define fornecedor estratégico?
2. COUNT DISTINCT entra?
3. GROUP BY será necessário?
4. HAVING ajudaria?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 25 — FUNCIONÁRIOS COM MUDANÇA DE DEPARTAMENTO
=========================================================

🎯 CENÁRIO:
O RH quer analisar movimentações internas da empresa.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar funcionários que passaram por múltiplos departamentos.

---------------------------------------------------------

📌 TABELAS SUGERIDAS:
- HumanResources.EmployeeDepartmentHistory

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O que caracteriza movimentação?
2. COUNT DISTINCT entra?
3. Granularidade final?
4. HAVING faz sentido?
5. ORDER BY ajudará?

========================================================= */



/* =========================================================
🧠 EX 26 — PRODUTOS SEM ORDEM DE PRODUÇÃO
=========================================================

🎯 CENÁRIO:
A produção quer revisar produtos sem fabricação registrada.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar produtos que nunca tiveram ordem de produção.

---------------------------------------------------------

📌 TABELAS SUGERIDAS:
- Production.Product
- Production.WorkOrder

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Isso é presença ou ausência?
2. EXISTS ou NOT EXISTS?
3. LEFT JOIN ajudaria?
4. Há risco de duplicidade?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 27 — ANÁLISE DE AUMENTOS SALARIAIS
=========================================================

🎯 CENÁRIO:
O RH quer identificar funcionários
com maior evolução salarial.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Comparar histórico salarial dos funcionários.

---------------------------------------------------------

📌 TABELAS SUGERIDAS:
- HumanResources.EmployeePayHistory

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Você analisará:
   - salário atual?
   - histórico?
2. MAX e MIN ajudam?
3. GROUP BY será necessário?
4. ORDER BY ajudará?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 28 — PRODUTOS COM MAIS COMPONENTES
=========================================================

🎯 CENÁRIO:
A engenharia quer identificar produtos mais complexos.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar produtos compostos por maior quantidade de componentes.

---------------------------------------------------------

📌 TABELAS SUGERIDAS:
- Production.BillOfMaterials
- Production.Product

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. O que representa complexidade?
2. COUNT ajuda?
3. DISTINCT será necessário?
4. GROUP BY será por:
   - produto?
   - componente?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 29 — LOJAS SEM PEDIDOS RECENTES
=========================================================

🎯 CENÁRIO:
O comercial quer identificar lojas parceiras inativas.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Encontrar lojas sem pedidos nos últimos 2 anos.

---------------------------------------------------------

📌 TABELAS SUGERIDAS:
- Sales.Store
- Sales.Customer
- Sales.SalesOrderHeader

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Isso envolve presença ou ausência?
2. DATEADD será necessário?
3. EXISTS ou NOT EXISTS?
4. Quantos relacionamentos existirão?
5. Granularidade final?

========================================================= */



/* =========================================================
🧠 EX 30 — ANÁLISE DE CUSTO DE PRODUTOS
=========================================================

🎯 CENÁRIO:
A diretoria quer entender produtos
com maior custo operacional.

---------------------------------------------------------

🎯 PROBLEMA DE NEGÓCIO:
Comparar custo padrão e preço de venda dos produtos.

---------------------------------------------------------

📌 TABELAS SUGERIDAS:
- Production.Product

---------------------------------------------------------

🧠 PERGUNTAS GUIADAS:

1. Quais colunas representam:
   - custo?
   - venda?
2. Você precisará calcular diferença?
3. CASE ajudaria na classificação?
4. ORDER BY será útil?
5. Granularidade final?

========================================================= */