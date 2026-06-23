/*
🏆 TESTE TÉCNICO SQL SERVER (2026)
Objetivo

Este teste simula um desafio técnico semelhante ao que poderia ser aplicado em um processo seletivo para:

	Analista de Sistemas
	Desenvolvedor SQL Server
	Analista de Banco de Dados

Utilize a base AdventureWorks.

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

• Quais métricas poderiam representar
essa importância?

• Existe apenas uma resposta correta?

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

2. Quais tabelas serão utilizadas?

3. Quais JOINs serão necessários?

4. Como provar que sua granularidade
está correta?

========================================================= */

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

• Como pretende comparar
agregado com agregado?

• CTE faz sentido?

========================================================= */

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

• Que perguntas precisam ser feitas?

• Você implementaria algo?

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