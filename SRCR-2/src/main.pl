?- consult(['inv.pl','si.pl']).

nuloInterdito(nuloInterdito).
nuloIncerto(nuloIncerto).
nulo(nulo).
nulo(nuloIncerto).
nulo(nuloInterdito).
:- dynamic excecao/1.

% UTENTE--------------------------------------------------------------------------------------------
% utente(#IdUt, Nome, Idade, Morada)
:- dynamic utente/4.

-utente(IdUt, Nome, Idade, Morada) :- nao(utente(IdUt, Nome, Idade, Morada)),
                                      nao(excecao(utente(IdUt, Nome, Idade, Morada))).

%% Invariantes de Utente
%% A idade de um utente só pode ser nula ou um inteiro positivo
+utente(IdUt, Nome, Idade, Morada) :: (
                                        findall(IdUt, utente(IdUt, _, _, _), L1),
                                        comprimento(L1, 1), % Não pode haver repetidos
                                        ou( 
                                            e( integer(Idade), Idade >= 0, verdadeiro), 
                                            nulo(Idade), 
                                            verdadeiro
                                        ) % Idade é um inteiro positivo ou é um nulo.
                                      ).

-utente(IdUt, Nome, Idade, Morada) :: (
                                        ou(
                                          nao(nuloInterdito(Idade)) ,
                                          utente(IdUt, _, nuloInterdito, _),
                                          verdadeiro
                                        )
).
%% Uma entrada de utente so pode ser removida se:
%%%  -não existir utentes
%%%  -existirem mais do que uma entrada com o mesmo id 
-utente(IdUt, Nome, Idade, Morada) :: (
                                        findall(IdCuid, cuidado(IdCuid,_,IdUt,_,_,_),L1),
                                        comprimento(L1, 0)
                                      ).

%% Invariante de atualização
update(utente(IdUt,Nome,nuloInterdito,Morada)) :: utente(IdUt, _, nuloInterdito, _).

%% Exceções de utente
% O nome do utente pode ser nulo
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, nulo, Idade, Morada).
% O nome do utente pode ser nulo interdito
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, nuloInterdito, Idade, Morada).
% A idade do utente pode ser nulo
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, Nome, nulo, Morada).
% A idade do utente pode ser nulo interdito
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, Nome, nuloInterdito, Morada).
% A idade do utente pode ser nulo interdito
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, Nome, Idade, nuloInterdito).
% A morada do utente pode ser nulo
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, Nome, Idade, nulo).


%recursividade feita em primeiro para não fazer asserts caso algum invariante falhe.
%Gera exceções de incertezas para utentes e Nomes
genUtNomeExcecoes(Id,[]).
genUtNomeExcecoes(Id,[X|T]):- genUtNomeExcecoes(Id,T) ,evolucao(excecao(utente(Id, X, _, _))).
%Gera exceções de incertezas para utentes e Idades
genUtIdadeExcecoes(Id,[]).
genUtIdadeExcecoes(Id,[X|T]):- genUtIdadeExcecoes(Id,T) ,evolucao(excecao(utente(Id, _, X, _))).
%Gera exceções de incertezas para utentes e Moradas
genUtMoradaExcecoes(Id,[]).
genUtMoradaExcecoes(Id,[X|T]):- genUtMoradaExcecoes(Id,T) ,evolucao(excecao(utente(IdUt, _, _, X))).

%%%--------------------------------------------------------------------------------------------------

% PRESTADOR------------------------------------------------------------------------------------------
% prestador(#IdPrest, Nome, Especialidade, Instituicao)
:- dynamic prestador/4.

-prestador(IdPrest, Nome, Especialidade, Instituicao) :- nao(prestador(IdPrest, Nome, Especialidade, Instituicao)),
                                                         nao(excecao(prestador(IdPrest, Nome, Especialidade, Instituicao))).

%% Invariantes de Prestador
+prestador(IdPrest, Nome, Especialidade, Instituicao) :: (
                                                            findall(IdUt, prestador(IdPrest, _, _, _), L1),
                                                            comprimento(L1, 1) % Não pode haver repetidos
                                                         ).
-prestador(IdPrest, Nome, Especialidade, Instituicao) :: (
                                                            findall(IdCuid, cuidado(IdCuid,_,_,IdPrest,_,_),L1),
                                                            comprimento(L1, 0)
                                                         ).
%% Excecoes de Prestador 
% O nome do prestador pode ser nulo
excecao(prestador(IdPrest, Nome, Especialidade, Instituicao)) :- prestador(IdPrest, nulo, Especialidade2, Instituicao2).
% O nome do prestador pode ser nulo interdito
excecao(prestador(IdPrest, Nome, Especialidade, Instituicao)) :- prestador(IdPrest, nuloInterdito, Especialidade2, Instituicao2).
% A idade do prestador pode ser nulo
excecao(prestador(IdPrest, Nome, Especialidade, Instituicao)) :- prestador(IdPrest, Nome2, nulo, Instituicao2).
% A idade do prestador pode ser nulo interdito
excecao(prestador(IdPrest, Nome, Especialidade, Instituicao)) :- prestador(IdPrest, Nome2, nuloInterdito, Instituicao2).
% A morada do prestador pode ser nulo
excecao(prestador(IdPrest, Nome, Especialidade, Instituicao)) :- prestador(IdPrest, Nome2, Especialidade2, nulo).
% A morada do prestador pode ser nulo interdito
excecao(prestador(IdPrest, Nome, Especialidade, Instituicao)) :- prestador(IdPrest, Nome2, Especialidade2, nuloInterdito).

%Gera exceções de incertezas para prestadores e Nomes
genPresNomeExcecoes(Id,[]).
genPresNomeExcecoes(Id,[X|T]):- genPresNomeExcecoes(Id,T) ,evolucao(excecao(prestador(Id, X, _, _))).
%Gera exceções de incertezas para Prestadores e especialidades
genPresEspecialidadeExcecoes(Id,[]).
genPresEspecialidadeExcecoes(Id,[X|T]):- genPresEspecialidadeExcecoes(Id,T) ,evolucao(excecao(prestador(Id, _, X, _))).
%Gera exceções de incertezas para prestadores e Instituições
genPresInstituicaoExcecoes(Id,[]).
genPresInstituicaoExcecoes(Id,[X|T]):- genPresInstituicaoExcecoes(Id,T) ,evolucao(excecao(prestador(Id, _, _, X))).
%%%--------------------------------------------------------------------------------------------------

% CUIDADO--------------------------------------------------------------------------------------------
% cuidado(#IdUt, #IdPrest, Descricao, Custo)
:- dynamic cuidado/6.

-cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :- nao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)),
                                             nao(excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo))).

%% Invariantes de Cuidados 



%% Excecoes de Cuidado
% A data do cuidado pode ser nulo
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, nulo, IdUt, IdPrest, Descricao, Custo).
% A data do cuidado pode ser nulo interdito
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, nuloInterdito, IdUt, IdPrest, Descricao, Custo).
% O id do utente do cuidado pode ser nulo
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, Data, nulo, IdPrest, Descricao, Custo).
% A id do utente  do cuidado pode ser nulo interdito
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, Data, nuloInterdito, IdPrest, Descricao, Custo).
% A id do prestador do cuidado pode ser nulo
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, Data, IdUt, nulo, Descricao, Custo).
% A id do prestador do cuidado pode ser nulo interdito
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, Data, IdUt, nuloInterdito, Descricao, Custo).
% A descrição do cuidado pode ser nulo
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, Data, IdUt, IdPrest, nulo, Custo).
% A descrição do cuidado pode ser nulo interdito
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, Data, IdUt, IdPrest, nuloInterdito, Custo).
% O custo do cuidado pode ser nulo
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, nulo).
% O custo do cuidado pode ser nulo interdito
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, nuloInterdito).

%Gera exceções de incertezas para consultas de Datas
genCuidadoDataExcec(IdCuid,[]).
genCuidadoDataExcec(IdCuid,[X|T]) :- genCuidadoDataExcec(IdCuid,T), evolucao(excecao(cuidado(IdCuid, X, _, _, _, _))).
%Gera exceções de incertezas para consultas de Utentes
genCuidadoUtExcec(IdCuid,[]).
genCuidadoUtExcec(IdCuid,[X|T]) :- genCuidadoUtExcec(IdCuid,T), evolucao(excecao(cuidado(IdCuid, _, X, _, _, _))).
%Gera exceções de incertezas para consultas de Prestadores
genCuidadoPresExcec(IdCuid,[]).
genCuidadoPresExcec(IdCuid,[X|T]) :- genCuidadoPresExcec(IdCuid,T), evolucao(excecao(cuidado(IdCuid, _, _, X, _, _))).
%Gera exceções de incertezas para consultas de Custos
genCuidadoCustoExcec(IdCuid,[]).
genCuidadoCustoExcec(IdCuid,[X|T]) :- genCuidadoCustoExcec(IdCuid,T), evolucao(excecao(cuidado(IdCuid, _, _, _, _, X))).
%%%--------------------------------------------------------------------------------------------------

% Manipulacao da Base de Conhecimento----------------------------------------------------------------

%% Inserção no Sistema --------------------------------------
% Adiciona Utentes ao sistema
%% Gera exceçoes de moradas se valor for incerto
addUtente(Id,[X|T],I,M):-addUtente(Id,nuloIncerto,I,M),genUtNomeExcecoes(Id,[X|T]).
%% Gera excecoes de idade se valor for incerto
addUtente(Id,NOME,[X|T],M):-addUtente(Id,NOME,nuloIncerto,M),genUtIdadeExcecoes(Id,[X|T]).
%% Gera excecoes de morada se valor for incerto
addUtente(Id,NOME,I,[X|T]):-addUtente(Id,NOME,I,nuloIncerto),genUtMoradaExcecoes(Id,[X|T]).
addUtente(Id,N,I,M):-evolucao(utente(Id,N,I,M)).
% Adiciona Prestador ao sistema
addPrestador(prestador(IdPrest, [X|T], Especialidade, Instituicao)):- addPrestador(prestador(IdPrest, nuloIncerto, Especialidade, Instituicao)), genPresNomeExcecoes(IdPrest,[X|T]).
addPrestador(prestador(IdPrest, Nome, [X|T], Instituicao)):- addPrestador(prestador(IdPrest, Nome, nuloIncerto, Instituicao)), genPresEspecialidadeExcecoes(IdPrest,[X|T]).
addPrestador(prestador(IdPrest, Nome, Especialidade, [X|T])):- addPrestador(prestador(IdPrest, Nome, Especialidade, nuloIncerto)), genPresInstituicaoExcecoes(IdPrest,[X|T]).
addPrestador(prestador(IdPrest, Nome, Especialidade, Instituicao)):- evolucao(prestador(IdPrest, Nome, Especialidade, Instituicao)).
% Adiciona Cuidados ao Sistema
%% As descrições não podem ser incertas, não faz sentido
addCuidado(cuidado(IdCuid, [X|T], IdUt, IdPrest, Descricao, Custo)):- addCuidado(cuidado(IdCuid, nuloIncerto, IdUt, IdPrest, Descricao, Custo)), genCuidadoDataExcec(IdCuid,[X|T]).
addCuidado(cuidado(IdCuid, Data, [X|T], IdPrest, Descricao, Custo)):- addCuidado(cuidado(IdCuid, Data, nuloIncerto, IdPrest, Descricao, Custo)), genCuidadoUtExcec(IdCuid,[X|T]).
addCuidado(cuidado(IdCuid, Data, IdUt, [X|T], Descricao, Custo)):- addCuidado(cuidado(IdCuid, Data, IdUt, nuloIncerto, Descricao, Custo)), genCuidadoPresExcec(IdCuid,[X|T]).
addCuidado(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, [X|T])):- addCuidado(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, nuloIncerto)), genCuidadoCustoExcec(IdCuid,[X|T]).
addCuidado(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)):- evolucao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)).

%% Remoção do Sistema --------------------------------

test(1):- addUtente(2,dan,[12,20],braga).
test(2):- addPrestador(2,mig,[pediatria,obstetricia],hospitalBraga).
test(3):- addCuidado(2,marco,2,nulo,texto,nuloInterdito).
test(4):- atualizacao(utente(2,dan,nuloIncerto,braga),utente(2,dan,20,braga)).
test(5):- atualizacao(utente(1, daniel, nuloInterdito, nuloInterdito),utente(1, marcoDantas, nuloInterdito, nuloInterdito)).
utente(1, daniel, nuloInterdito, nuloInterdito).
prestador(1, miguel, nulo, nulo).