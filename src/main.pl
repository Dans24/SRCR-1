% Primeiro exercicio
% Grupo 1


% utente(IdUt, Nome, Idade, Cidade)
:- dynamic utente/4.
utente(1, carlos, 20, braga).

% servico(IdServico, Descricao, Instituicao, Cidade)
:- dynamic servico/4.
servico(1, exame1, hospitaldeBraga, braga).
servico(2, exame2, hospitaldeBraga, braga).
servico(3, exame3, hospitaldoPorto, porto).
servico(4, exame4, hospitaldoPorto, porto).

% consulta(Data, IdUt, IdServico, Custo)
:- dynamic consulta/4.
consulta(9/03/2019, 1, 1, 10.0).



% Registar utentes, serviços e consultas
registarUtente(IdUt, Nome, Idade, Cidade) :- 
    assert(utente(IdUt, Nome, Idade, Cidade)).

registarServico(IdServico, Descricao, Instituicao, Cidade) :- 
    assert(servico(IdServico, Descricao, Instituicao, Cidade)).

registarConsulta(Data, IdUt, IdServico, Custo) :- 
    assert(consulta(Data, IdUt, IdServico, Custo)).


% Remover utentes, serviços e consultas
removerUtente(IdUt) :- 
    retract(utente(IdUt, _, _, _)).

removerServico(IdServico) :- 
    retract(servico(IdServico, _, _, _)).

removerConsulta(IdUt, IdServico) :- 
    retract(consulta(_, IdUt, IdServico, _)).


% Identificar as instituições prestadoras de serviços;
instituicoesComServicos(Z) :-
    findall(X, servico(_, _, X, _), Z). % tirar repetidos


% Identificar utentes/serviços/consultas por critérios de seleção


% Identificar serviços prestados por instituição/cidade/datas/custo
servicosInstituicao(Instituicao, Z) :-
    findall(Id, servico(Id, _, Instituicao, _), Z). 

servicosCidade(Cidade, Z) :-
    findall(Id, servico(Id, _, Cidade, _), Z). 


% Identificar os utentes de um serviço/instituição
utentesServico(IdSer, Z) :- 
    findall(IdUt, consulta(_, IdUt, IdSer, _), Z).

utentesInstituicao(Inst, Z) :- 
    findall(IdUt, (servico(IdSer, _, Inst, _), consulta(_, IdUt, IdSer, _)), Z).
    

% Identificar serviços realizados por utente/instituição/cidade

% Calcular o custo total dos cuidados de saúde por utente/serviço/instituição/data



% Extras