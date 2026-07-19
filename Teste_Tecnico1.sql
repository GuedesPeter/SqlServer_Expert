USE AdventureWorks
GO

/*
🏆 TESTE TÉCNICO SQL SERVER (2026)
Objetivo

Este teste simula um desafio técnico semelhante ao que poderia ser aplicado em um processo seletivo para:

	Analista de Sistemas
	Desenvolvedor SQL Server
	Analista de Banco de Dados

Utilize a base AdventureWorks [Comando disponível nas linhas 1 e 2].

⚠️ REGRAS DO TESTE
Durante o teste

	✔ Analise primeiro.

	✔ Questione regras de negócio quando necessário.

	✔ Explique seu raciocínio.

	✔ Depois escreva SQL.

Não faça

	❌ Não escreva SQL imediatamente.

	❌ Não assuma regras de negócio sem justificar.

	❌ Não altere dados sem validar previamente.

O que será avaliado
	Lógica
	Granularidade
	Modelagem
	Clareza
	Organização
	Segurança
	Legibilidade
	Uso correto dos recursos do SQL Server

Muito mais do que "acertar a query".

*/
--************************************************************
					-- TESTE TÉCNICO --
--************************************************************


/* =========================================================
🧠 TESTE TÉCNICO SQL SERVER (2026)

EMPRESA:
TechCommerce Solutions

CENÁRIO:

A empresa deseja criar um painel estratégico
para acompanhar a saúde da operação comercial.

Você deverá analisar os requisitos,
questionar possíveis lacunas
e somente então construir as soluções.

Todas as consultas deverão utilizar
AdventureWorks.

========================================================= */

-- Ex.1
/* =========================================================

O diretor comercial deseja conhecer
os 15 clientes mais importantes da empresa.

Porém ele não definiu o significado
de "mais importante".

---------------------------------------------------------

Sua tarefa NÃO é escrever SQL.

Sua tarefa é analisar o requisito.

Explique:

• Quais perguntas faria ao solicitante?
Qual métrica ou requisito determinará que o cliente se enquadre no status de "mais importante"?
Após a definição de uma métrica para os clientes com este status, quais informações relacionadas
a eles gostaria de visualizar ou seriam mais interessantes para uma possível análise?

• Quais métricas poderiam representar
essa importância?
Posso citar algumas como faturamente, volume de compras, frequencia ao longo do tempo, etc.

• Existe apenas uma resposta correta?
Inicialmente o cenário apresenta várias possibilidades ou caminhos a serem seguidos, o que não
garante uma única resposta correta ou solução direta/imediata.
========================================================= */

-- Ex.2
/* =========================================================

Após reunião,
o diretor respondeu:

"Para nós,
cliente importante
é quem mais faturou."

Agora sim desenvolva a solução.

---------------------------------------------------------

PERGUNTAS GUIADAS

1. Qual será a granularidade?

1 Linha = 1 Cliente

2. Quais tabelas serão utilizadas?

Conforme analisei, a tabela [Sales].[SalesOrderHeader] contém as informações necessárias
para obter o cliente e seu faturamento.

3. Quais JOINs serão necessários?
Seguindo como base a resposta anterior, apenas a tabela [Sales].[SalesOrderHeader] será necessária
neste momento, pois já contem as informações necessárias.Isso elimina o uso de Joins neste momento.

4. Como provar que sua granularidade
está correta?

Neste momento eu preciso exibir o cliente com seu faturamento, então cada linha irá conter um cliente com sua 
respectiva métrica(Faturamento).

========================================================= */
-- Solução a ser aplicada em um ambiente de produção
SELECT TOP 15
	CustomerID AS IdCliente,
	SUM(TotalDue) AS Faturamento
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY Faturamento DESC;
-- Solução para apresentação/relatório para a diretoria
SELECT TOP 15
	CustomerID AS IdCliente,
	FORMAT(SUM(TotalDue),'C','pt-BR') AS Faturamento
FROM [Sales].[SalesOrderHeader]
GROUP BY CustomerID
ORDER BY SUM(TotalDue) DESC;


-- Ex.3
/* =========================================================

A empresa agora deseja identificar clientes
que possuem faturamento acima
da média geral da empresa.

Não existe limitação
de quantidade de clientes.

---------------------------------------------------------

Antes da SQL responda:

• Quantos níveis de agregação existem?
Pela ótica inicial posso observar dois níveis: Faturamento do cliente e média geral da empresa.
• Como pretende comparar
agregado com agregado?

Obtendo inicialmente o faturamente de cada cliente.
Em seguida obtenho a média geral da empresa.
Por fim realizo a comparação para identificar os clientes com o faturamento acima da média geral da empresa.

• CTE faz sentido?
Sim.
A CTE é útil para organizar o cenário segregando cada agragação a serem comparadas.

Observação:
Como o Ex.3 sugere "Antes da SQL responda", da a entender que devo realizar a query e diante disso
irei aplicá-la na sequencia após considerar minha análise inicial das questões acima.

========================================================= */
-- Produção
WITH FaturamentoCliente AS (
	SELECT
		CustomerID AS IdCliente,
		SUM(TotalDue) AS Faturamento
	FROM [Sales].[SalesOrderHeader]
	GROUP BY CustomerID

),
MediaEmpresa AS (
	SELECT
		AVG(Faturamento) AS FaturamentoEmpresa
	FROM FaturamentoCliente
)
SELECT 
	FC.IdCliente,
	FC.Faturamento,
	ME.FaturamentoEmpresa
FROM FaturamentoCliente FC
CROSS JOIN MediaEmpresa ME
WHERE FC.Faturamento > ME.FaturamentoEmpresa
ORDER BY FC.Faturamento DESC;

-- Análise da diretoria ou utilização de outros agentes (BI,CRM,etc.)
WITH FaturamentoCliente AS (
	SELECT
		CustomerID AS IdCliente,
		SUM(TotalDue) AS Faturamento
	FROM [Sales].[SalesOrderHeader]
	GROUP BY CustomerID

),
MediaEmpresa AS (
	SELECT
		AVG(Faturamento) AS FaturamentoEmpresa
	FROM FaturamentoCliente
)
SELECT 
	FC.IdCliente,
	FORMAT(FC.Faturamento,'C','pt-BR') AS FaturamentoDoCliente,
	FORMAT(ME.FaturamentoEmpresa,'C','pt-BR') AS MediaFaturamentoEmpresa
FROM FaturamentoCliente FC
CROSS JOIN MediaEmpresa ME
WHERE FC.Faturamento > ME.FaturamentoEmpresa
ORDER BY FC.Faturamento DESC;

-- Ex.4
/* =========================================================

O financeiro afirma:

"Alguns clientes reduziram muito
o faturamento."

Não existe definição
de "reduzir muito".

---------------------------------------------------------

Sua tarefa NÃO é escrever SQL.

Faça uma análise técnica.

Explique:

• O requisito é suficiente?
Pela ótica inicial, é um cenário muito vago.
Isso torna a análise insuficiente.
Para mensurar certa redução no faturamento, ao menos o setor financeiro deveria apresentaruma ou
algumas métricas que corroborem com sua afirmação.

• Que perguntas precisam ser feitas?
Posso sugerir como exemplo as seguintes perguntas:
Com base em qual métrica o setor identificou esta redução?
De qual modo a redução no faturamento ocorreu?
Quais clientes apresentam este cenário?
Em qual período tal cenário ocorreu ou ficou evidente?

• Você implementaria algo?
Não. Aguardaria informações concretas ou um direcionamento quanto ao cenário informado pelo setor financeiro

========================================================= */

-- Ex.5
/* =========================================================

A empresa deseja classificar clientes:

OURO
PRATA
BRONZE

---------------------------------------------------------

Nenhuma regra foi fornecida.

Sua missão é:

1) Definir qual seria
a abordagem profissional.

2) Deflicar qual seria
a abordagem pedagógica.

3) Explicar
quando armazenaria essa classificação
e quando apenas a calcularia.

========================================================= */
 -- CENARIO FINALIZADO INTERNAMENTE

-- EX.6
/* =========================================================

Foi decidido armazenar
a classificação do cliente.

Agora desenvolva
uma solução segura.

Não execute nada.

Descreva:

• Ordem das operações.

• Validações.

• Segurança.

• Como faria rollback.

========================================================= */


-- EX.7
/* =========================================================

O diretor deseja remover
pedidos antigos.

Nenhum critério foi informado.

---------------------------------------------------------

Não escreva SQL.

Explique:

• Por que este requisito
não pode ser implementado?

• Quais riscos existem?

• Como responderia
ao solicitante?

========================================================= */


-- EX.8
/* =========================================================

A equipe suspeita
de pedidos duplicados.

A tabela analisada
é Sales.SalesOrderHeader.

---------------------------------------------------------

Analise a modelagem.

Sem escrever SQL,
explique:

• O cenário faz sentido?

• Existe conflito
entre requisito e modelo?

• Como conduziria
essa demanda?

========================================================= */


-- EX.9
/* =========================================================

O gerente pediu
uma Stored Procedure
para consultar
o histórico comercial
de um cliente.

Ele deseja informar
o CustomerID.

---------------------------------------------------------

Não escreva código.

Explique:

• Quais informações retornaria?

• Como organizaria
a procedure?

• Que validações faria?

========================================================= */


-- EX.10
/* =========================================================

Agora imagine
que você foi contratado.

Você recebeu
todos os exercícios anteriores.

Escreva um pequeno documento técnico
(aproximadamente 1 página).

Explique:

• quais requisitos estavam corretos;

• quais estavam incompletos;

• quais apresentavam riscos;

• quais recusaria implementar;

• quais sugestões daria
para melhorar a qualidade
das futuras solicitações.

========================================================= */

/* =========================================================

🎯 O QUE ESTE TESTE REALMENTE AVALIA

Perceba que, dos 10 exercícios:

apenas 2 exigem necessariamente SQL;
os demais exigem análise, comunicação e tomada de decisão.

Isso foi intencional.

Depois das últimas semanas, ficou claro para mim que você já está desenvolvendo a sintaxe de forma consistente. 
O próximo passo é fortalecer uma competência que diferencia bons profissionais: saber quando não escrever SQL.

Há uma frase que resume muito bem esse teste e que gostaria que você levasse para a carreira:

"A melhor consulta SQL do mundo continua sendo a solução errada quando resolve um requisito mal definido."

Essa frase sintetiza praticamente tudo o que construímos ao longo das duas baterias.

========================================================= */