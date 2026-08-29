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

1.Abordagem profissional
A implementação seria interrompida até que a empresa definisse a regra de negócio para classificar clientes como Ouro, Prata ou Bronze.
Seriam levantadas perguntas sobre critérios, finalidade da classificação, periodicidade de atualização e impacto dessa informação.

2.Abordagem pedagógica
O exercício não fornece elementos suficientes para construir uma hipótese consistente.
Qualquer classificação (por faturamento, frequência, ticket médio etc.) seria uma premissa arbitrária do desenvolvedor e não uma conclusão baseada no requisito.
Portanto, opto por não criar regras hipotéticas que possam induzir uma solução artificial.

3.Armazenar ou calcular
Essa decisão depende da finalidade da classificação.
Sem conhecer a regra de negócio, a frequência de atualização e o consumo dessa informação, não é possível decidir tecnicamente entre persistir o dado ou calculá-lo sob demanda.

========================================================= */


-- EX.6
/* =========================================================

Foi decidido armazenar
a classificação do cliente.

Agora desenvolva
uma solução segura.

Não execute nada.

Descreva:

• Ordem das operações.
Levantar e validar a regra de negócio.
Identificar a entidade correta para persistência.
Validar impacto da alteração.
Criar a estrutura necessária.
Validar os dados com SELECT.
Atualizar os registros.
Validar o resultado.
Confirmar a transação.

• Próximas questões
- Inicialmente eu solicitaria saber destes pontos:
	Qual é a regra utilizada para definir tal classificação?
	Qual fator ou métrica define essa regra?
	

• Validações.
- Para validações, levantaria estes pontos:
	Quais métricas definem o grau de classificação?
	Quais devem ser estas classificações?
	Essa classificação é mutável ou imutável?
	Em quais entidade faria sentido armazenar essa informação?

• Segurança.
- Pontos a considerar na segurança:
	Quais entidades receberão a classificação?
	Qual tipo de dado deve ser utilizado para armazenar a informação?
	A seleção dos dados devem ser analizadas obrigatoriamente antes da persistencia dos dados.
	Quem terá a permissão para selecionar, analizar, classificar e armazenar estes dados?
	Qual será a frequencia da classificação?

• Como faria rollback.
- Por fim:
Esse processo de armazenamento deve sempre ocorrer dentro de uma Transaction,
na qual deverá ter definida em sua contrução os tratamentos de erros, commit e rollback.

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

O requisito não possui informações suficientes para definir quais registros podem ser removidos com segurança.

• Quais riscos existem?

Nesse caso há o risco real de perda de informações, afetadndo diretamente o passado,
presente e futuro da empresa.

• Como responderia
ao solicitante?

"Caro sr.Diretor,
No momento, não dispomos dos critérios necessários para determinar quais pedidos podem ser removidos com segurança.
Ressalto que tal solicitação gera um efeito crítico, no qual impactará o histórico e dia a dia da empresa.
Caso deseje seguir com a operação, solicito o critério que deverá ser aplicado para a execução.
Sigo à disposição para esclarecimentos."


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
O modelo impede duplicidade da chave SalesOrderID, mas isso não é suficiente para determinar se existe duplicidade do ponto de vista do negócio.

• Existe conflito
entre requisito e modelo?

O conflito está justamente aqui:

Modelo

O banco garante algo como:

Um SalesOrderID não pode aparecer duas vezes como identificador do pedido.

Requisito

O negócio está dizendo:

"Existem pedidos duplicados."

Essas duas afirmações podem coexistir.

Porque estamos falando de conceitos diferentes.

• Como conduziria
essa demanda?
Faria alguns questionamentos, como por exemplo:
O que determina que um pedido está duplicado?
Onde foi identificada tal duplicidade?
Qual a informação obtida está levantando este cenário?
Quais evidencias justificam que há duplicidades e onde se mostram?

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
Inicialmente eu questionaria: o que define um historico comercial?
Quais informações são relevantes para estarem visiveis no relatório/historico do cliente?
Alguma regra de negócio deve ser considerada?
Há algum status do cliente que devo considerar?
Como deve ser exibido este historico? Em qual formato?

• Como organizaria
a procedure?

Organizaria pelo parametro que o gerente deseja informar (CustomerID).
Exemplo:

CREATE OR ALTER PROCEDURE NomeProcedure
    @CustomerID INT
AS
BEGIN

    SET NOCOUNT ON;

    -- Comandos SQL...

END;


• Que validações faria?
Inicialmente o cenário deve estar bem definido. Após eu faria algo como validação dos parametros,
validação de exixtencia, etc.



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

RELATÓRIO TÉCNICO - Por Paulo Peter

Este documento tem a finalidade de descrever as considerações e conclusões dos cenários apresentados nos
10 exercícios propostos.

Exercício 1:
Aqui o diretor comercial solicitou conhecer os 15 clientes mais importantes da empresa.
Neste cenário o requisito que define um cliente como "importante" não foi apresentado,
tornando a solicitação do gerente incompleta.(Requisitos incompletos)

Exercício 2:
Neste cenário o caso anterior evoluiu, onde o diretor definiu que o cliente a ser considerado importante seria o
cliente que mais faturou.
Aqui foi apresentada a solução exibindo e classificando o cliente conforme seu faturamento.(Requisitos corretos)

Exercício 3:
No cenário do exercício 3 foi solicitado identificar clientes que possuem faturamento acima
da média geral da empresa.
Neste ponto foi apresentada a solução comparando o faturamento de cada cliente com a media de faturamento 
da empresa.(Requisitos corretos)

Exercício 4:
Neste cenário o financeiro afirmou que alguns clientes reduziram muito o
faturamento, porém não definiu o requisito que determinou a redução do faturamento e nem
quais clientes apresentaram o caso. Aqui o requisito se fez incompleto.

Exercício 5:
Aqui a empresa desejou classificar os clientes como Ouro, Prata e Bronze.
Conforme análise, se faz necessária a definição da regra que embasa tal classificação,
portanto, o requisito está incompleto para a apresentação de uma solução.

Exercício 6:
Seguindo o cenário do exercício 5, aqui a empresa desejou armazenar a classificação do cliente.
Conforme análise realizada, a descrição do cenário foi aplicada contendo:
ordem das Operações;
questionamentos;
validações;
segurança;
persistencia.
Aqui o cenário apresentou uma condução descritiva.

Exercício 7:
No exercício 7 o diretor solicitou a remoção de pedidos antigos.
Este caso apresentou riscos e recusa a implementação na primeira abordagem pois não foi
informado pelo diretor um critério para a aplicação da operação.

Exercício 8:
Neste cenário a equipe suspeitou na duplicidade dos pedidos.
Conforme análise, o modelo impede duplicidade da chave SalesOrderID, mas isso não é suficiente para determinar se existe duplicidade do ponto de vista do negócio.
Aqui minha sugestão se fez presente para uma melhor definição do cenário, auxiliando na tomada de decisão.

Exercício 9:
O gerente pediu uma Stored Procedure para consultar o histórico comercial de um cliente, porém não 
apresentou uma definição ou regras para a contrução de uum histórico comercial para o cliente.
Aqui questionei uma melhor definição do cenário, com o objetivo de aplicar uma construção segura para a solução.

Exercício 10:
Vide as respostas anteriores.
Teste Técnico CONCLUÍDO.

========================================================= */