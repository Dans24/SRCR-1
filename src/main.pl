% Primeiro exercicio
% Grupo 1
:- op( 900,xfy,'::' ).

% utente(IdUt, Nome, Idade, Cidade)
%UTENTES-------------------------------------
:- dynamic utente/4.
utente(1, carlos, 20, braga).
utente(2, marco, 22, viana).
utente(3, daniel, 21, porto).
utente(4, ze, 25, barcelos).
utente(5, cesar, 20, terceira).
utente(6, luis, 29, porto).
utente(7, angelo, 27, madeira).
utente(8, miguel, 31, porto).
utente(9, luis, 29, braga).
utente(10, rui, 20, viana).

%SERVICOS------------------------------------

% servico(IdServico, Descricao, Instituicao, Cidade)
:- dynamic servico/4.
servico(1, examePulmoes, hospitaldeBraga, braga).
servico(2, exameRins, hospitaldeBraga, braga).
servico(3, exameTesta, motijeiro, porto).
servico(4, fisioterapia, hospitaldoPorto, porto).
servico(5, examePulmoes, hospitaldeBraguinha, braga).
servico(6, exameCabeca, hospitaldeBraguinha, braga).
servico(7, exameProstata, hospitaldeBraga, braga).

%CONSULTA------------------------------------
%consulta(Data, IdUt, IdServico, Custo)
% +consulta(Data, IdUt, IdServico, Custo)::(string(Data), utente(IdUt, _, _, _), servico(IdServico, _, _, _), rational(Custo)). % falta comparar a data
:- dynamic consulta/4.
% date(9,maio,1998)
consulta(20/10/1998, 1, 1, 10.0).
consulta(20/10/1998, 2, 1, 10.0).
consulta(21/10/1998, 3, 2, 10.0).
consulta(20/10/1998, 4, 3, 10.0).
consulta(20/10/1998, 5, 7, 10.0).
% Um serviço pode ter vários utentes?

%DATA---------------------------------------
%data(Dia, Mes, Ano)
data(D,M,A) :- natural(D), D =< 31, natural(M), M =< 12, natural(A).

% Um serviço pode ter vários utentes?

%INVARIANTES---------------------------------
% Utente
% Utente tem de ter IdUt e idade um número natutal e não pode haver repetidos
+utente(IdUt, _, Idade, _) :: (natural(IdUt), natural(Idade), findall(IdUt,(utente(IdUt, _, _, _)),L),comprimento(L,1)).
-utente(IdUt, _, _, _) :: (findall(IdUt,(consulta(_, IdUt, _, _)),L),comprimento(L,0)).

% Servico
% Servico tem de ter IdServico um número natural e não pode haver repetidos
+servico(IdServico, _, _, _) :: (natural(IdServico), findall(IdServico,(servico(IdServico, _, _, _)),L),comprimento(L,1)).
-servico(IdServico, _, _, _) :: (findall(IdServico,(consulta(_, _, IdServico, _)),L),comprimento(L,0)).

% Consulta
% Consulta tem de apontar para utentes e servicos que existem.
+consulta(_, IdUt, IdServico, _) :: (utente(IdUt, _, _, _), servico(IdServico, _, _, _)).

% Registar utentes, serviços e consultas
% Caso id seja igual, remove a ocorrência anterior
% Apenas permite o registo de ids e idade em número natural
registarUtente(IdUt, Nome, Idade, Cidade) :- evolucao(utente(IdUt, Nome, Idade, Cidade)).

registarServico(IdServico, Descricao, Instituicao, Cidade) :- evolucao(servico(IdServico, Descricao, Instituicao, Cidade)). 
                                
registarConsulta(Data, IdUt, IdServico, Custo) :- evolucao(consulta(Data, IdUt, IdServico, Custo)).

%% Remover utentes, serviços e consultas
removerUtente(IdUt) :- 
    involucao(utente(IdUt, _, _, _)).

removerServico(IdServico) :- 
    involucao(servico(IdServico, _, _, _)).

removerConsulta(IdUt, IdServico) :- 
    involucao(consulta(_, IdUt, IdServico, _)).


%% Identificar as instituições prestadoras de serviços;
instituicoesComServicos(Z) :-
    setof(X, A^B^C^servico(A, B, X, C), Z). % tirar repetidos


%% Identificar utentes/serviços/consultas por critérios de seleção
% search(quem,como,info,lista final)
search(utente,id,ID,RES):-findall((ID,NOME,I,C) , utente(ID,NOME,I,C) ,RES).
search(utente,nome,NOME,RES):-findall((ID,NOME,I,C) , utente(ID,NOME,I,C) ,RES).
search(utente,idade,AGE,RES):-findall((ID,NOME,AGE,C) , utente(ID,NOME,AGE,C) ,RES).
search(utente,cidade,C,RES):-findall((ID,NOME,I,C) , utente(ID,NOME,I,C) ,RES).

search(servico,id,ID,RES):-findall((ID,NOME,C),servico(ID,NOME,_,C),RES).
search(servico,intituicao,I,RES):-findall((ID,NOME,C),servico(ID,NOME,I,C),RES).
search(servico,cidade,C,RES):-findall((ID,NOME,C),servico(ID,NOME,_,C),RES).

search(consultas,idUt,IdUt,RES):-findall((Data, IdUt, IdServico, Custo),consulta(Data, IdUt, IdServico, Custo),RES).
search(consultas,data,Data,RES):-findall((Data, IdUt, IdServico, Custo),consulta(Data, IdUt, IdServico, Custo),RES).

% Identificar serviços(/consultas) prestados por instituição/cidade/datas/custo

apagaAndJoin((Id,I),[],[],([Id],I)).
apagaAndJoin((Id,I),[(X,I)|T],R,([X|J],Y)) :- apagaAndJoin((Id,I),T,R,(J,Y)).
apagaAndJoin((Id,I),[(X,Y)|T],[(X,Y)|R],J) :- I\=Y,apagaAndJoin((Id,I),T,R,J).

joinAll([],[]).
joinAll([H|T],[J|Res]) :- apagaAndJoin(H,T,R,J), joinAll(R,Res).  

servicosPorInstituicao(Z) :- findall((Id,Inst), (servico(Id, _, Inst, _)), R), joinAll(R,Z).

consultasPorInstituicao(Inst, R) :- findall((A,B,IdServico,D), (servico(IdServico,_,Inst,_), consulta(A,B,IdServico, D)), R).

consultasPorCidade(Inst, R) :- findall((A,B,IdServico,D), (servico(IdServico,_,Inst,_), consulta(A,B,IdServico, D)), R).

%servicosCidade(R) :-
 %   findall((Id,Cidade), servico(Id,_,_,Cidade),Z),joinAll(Z,R).

%servicosCidade(Cidade, Z) :-
 %   findall(Id, servico(Id, _, _, Cidade), Z). 

% consultas 
servicosPrestadosPorDatas(R) :-
    findall((IdServico,Data), consulta(Data, _, IdServico, _),Z),joinAll(Z,R).

%% Identificar os utentes de um serviço/instituição
utentesServico(IdSer, Z) :- 
    findall((IdUt,N,I,C), (consulta(_, IdUt, IdSer, _),utente(IdUt,N,I,C)), Z).

utentesInstituicao(Inst, Z) :- 
    findall((IdUt,N,I,C), (servico(IdSer, _, Inst, _), consulta(_, IdUt, IdSer, _),utente(IdUt,N,I,C)), Z).
    
%% Identificar serviços realizados por utente/instituição/cidade

% Realizados:- Serviço para o qual foi executado uma consulta
% realizados na instituicao/cidade X
realizadosInstituicao(IdInst,Z):-
    findall(IdSer, (servico(IdSer, _, IdInst, _), consulta(_, _, IdSer, _)), Z).
realizadosCidade(IdCid,Z):-
    findall(IdSer, (servico(IdSer, _, _, IdCid), consulta(_, _, IdSer, _)), Z).

% realizados ao utente X na instituição/cidade Y
realizadosUtenteInstituicao(IdUt,IdInst,Z):-
    findall(IdSer, (servico(IdSer, _, IdInst, _), consulta(_, IdUt, IdSer, _)), Z).
realizadosUtenteCidade(IdUt,IdCid,Z):-
    findall(IdSer, (servico(IdSer, _, _, IdCid), consulta(_, IdUt, IdSer, _)), Z).

% Calcular o custo total dos cuidados de saúde por utente/serviço/instituição/data

custoTotalUtente(IdUt,Custo) :- findall(X,consulta(_,IdUt,_,X),Custos) , soma(Custos,Custo).
custoTotalServico(IdServ,Custo) :- findall(X,consulta(_,_,IdServ,X),Custos) , soma(Custos,Custo).
custoTotalData(Data,Custo) :- findall(X,consulta(Data,_,_,X),Custos) , soma(Custos,Custo).
custoTotalServicos([],0).
custoTotalServicos([X|T],Custo) :- custoTotalServico(X,CustoSing), custoTotalServicos(T,Resto), Custo is CustoSing + Resto.
custoTotalInst(Inst,Custo) :- servicosInstituicao(Inst,Servs), custoTotalServicos(Servs,Custo).

natural(X) :- integer(X), X >= 1.
% inteiro(X) :- X =:= round(X).



%AUXILIARES -------------------------------------------------------
soma([],0).
soma([H|T],Total) :- soma(T,Resto), Total is H + Resto.

evolucao(T):- findall(Invariante, +T :: Invariante, Lista),
              insercao(T),
              teste(Lista).

insercao(T) :- assert(T).
insercao(T) :- retract(T),!,fail.

teste([]).
teste([I|T]) :- I,teste(T).

involucao(T) :-
    findall(Invariante, -T :: Invariante, Lista),
    remocao(T),
    teste(Lista).

remocao(T) :- retract(T).
remocao(T) :- assert(T), !, fail.

involucaoLista([]).
involucaoLista([H|T]) :- involucao(H), involucaoLista(T).

% checkString(S,R) :- atom_codes(S,R).
comprimento([],0).
comprimento([_|T],R1) :- comprimento(T,R), R1 is R + 1.

% Extras
% Retorna o histórico do cliente (Data, Descricao, Instituicao, Custo)
historicoUtente(IdUt, RES) :- findall((Data, Descricao, Instituicao, Custo),(
                                consulta(Data, IdUt, IdServico, Custo),
                                servico(IdServico, Descricao, Instituicao, _)),RES).

% Retorna a lista de Instituições ordenada da com mais a menos lucro
topInstituicoesLucrativas(RES) :- findall((Instituicao, Custo),(
                                    servico(IdServico, _, Instituicao, _),
                                    consulta(_, _, IdServico, Custo)), L),
                                top(L, RES).

% Base de conhecimento que guarda o par instituição e lucro.
:- dynamic topTemp/2.

% Ordena a lista de pares instituições e lucro, pelo seu lucro
top([],RES) :- findall(topTemp(A,V),(topTemp(A,V)),L), sort(L, RES), involucaoLista(L).

top([(A,B)|T],RES) :- topTemp(A,V),
                    N is V + B,
                    evolucao(topTemp(A,N)),
                    involucao(topTemp(A,V)), top(T, RES).

top([(A,B)|T], RES) :- \+topTemp(A,_), evolucao(topTemp(A,B)), top(T, RES).

% QuickSort
% Menor de 2 números
menor(A, B) :- number(A), number(B), A < B.
% Menor de 2 datas
menor(data(_,_,A1), data(_,_,A2)) :- A1 < A2.
menor(data(_,M1,A1), data(_,M2,A2)) :- A1 =:= A2, M1 < M2.
menor(data(D1,M1,A1), data(D2,M2,A2)) :- A1 =:= A2, M1 >= M2, D1 =< D2.
% Menor de dois topTemp
menor(topTemp(_,V1), topTemp(_,V2)) :- V1 < V2.

% Ordena uma lista
quickSort([], []).
quickSort([H|T], S) :- part(H, T, L1, R1), quickSort(L1, L), quickSort(R1, R), concat(L, [H|R], S).
part(_, [], [], []).
part(X, [H|T], [H|L], R) :- menor(H,X), part(X, T, L, R).
part(X, [H|T], L, [H|R]) :- \+menor(H,X), part(X, T, L, R).
concat([],L,L).
concat([H|T], L, [H|R1]) :- concat(T, L, R1).
