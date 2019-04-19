?- consult(['inv.pl','si.pl']).

nuloInterdito(nuloInterdito).
nuloIncerto(nuloIncerto).
nulo(nulo).
nulo([H|T]).
nulo(nuloInterdito).

nuloGenerico(nulo).
nuloGenerico(nuloInterdito).

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

+utente(IdUt, Nome, Idade, Morada) :: nao(nulo(IdUt)).

-utente(IdUt, Nome, Idade, Morada) :: nao(nuloInterdito(Idade)).
-utente(IdUt, Nome, Idade, Morada) :: nao(nuloInterdito(Nome)).
-utente(IdUt, Nome, Idade, Morada) :: nao(nuloInterdito(Morada)).

%% Uma entrada de utente so pode ser removida se:
%%%  -não existir utentes
%%%  -existirem mais do que uma entrada com o mesmo id 
-utente(IdUt, Nome, Idade, Morada) :: (
                                        findall(IdCuid, cuidado(IdCuid,_,IdUt,_,_,_),L1),
                                        comprimento(L1, 0)
                                      ).

%% Invariante de atualização
%% Termo antigo, teste no novo
% update(Tantigo) :: Invariante.
update(utente(IdUt,nuloInterdito, _, _))  :: utente(IdUt, nuloInterdito, _, _).
update(utente(IdUt, _, nuloInterdito, _)) :: utente(IdUt, _, nuloInterdito, _).
update(utente(IdUt, _, _, nuloInterdito)) :: utente(IdUt, _, _, nuloInterdito).

%% Exceções de utente
excecao(utente(IdUt,Nome,Idade, Morada)) :- utente(IdUt, ListaDeNome, ListaDeIdade, ListaDeMorada),
                                            ou(contem(Nome, ListaDeNome), nuloGenerico(ListaDeNome), verdadeiro).
excecao(utente(IdUt,Nome,Idade, Morada)) :- utente(IdUt, ListaDeNome, ListaDeIdade, ListaDeMorada),
                                            ou(contem(Idade, ListaDeIdade), nuloGenerico(ListaDeIdade), verdadeiro).
excecao(utente(IdUt,Nome,Idade, Morada)) :- utente(IdUt, ListaDeNome, ListaDeIdade, ListaDeMorada),
                                            ou(contem(Morada, ListaDeMorada), nuloGenerico(ListaDeMorada), verdadeiro).


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

+prestador(IdPrest, Nome, Especialidade, Instituicao) :: nao(nulo(IdPrest)).
  
-prestador(IdPrest, Nome, Especialidade, Instituicao) :: (
                                                            findall(IdCuid, cuidado(IdCuid,_,_,IdPrest,_,_),L1),
                                                            comprimento(L1, 0)
                                                         ).

-prestador(IdPrest, Nome, Especialidade, Instituicao) :: nao(nuloIntedito(Nome)).
-prestador(IdPrest, Nome, Especialidade, Instituicao) :: nao(nuloIntedito(Especialidade)).
-prestador(IdPrest, Nome, Especialidade, Instituicao) :: nao(nuloIntedito(Instituicao)).

update(prestador(IdPrest, nuloIntedito, _, _))  :: nao(prestador(IdPrest, nuloInterdito,_,_)).
update(prestador(IdPrest, _, nuloIntedito, _))  :: nao(prestador(IdPrest, _,nuloInterdito,_)).
update(prestador(IdPrest, _, _, nuloInterdito)) :: nao(prestador(IdPrest, _,_,nuloInterdito)).

 
%% Excecoes de Prestador 

excecao(prestador(IdPrest, Nome, Especialidade, Instituicao)) :- prestador(IdPrest, ListaDeNome, ListaDeEspecialidade, ListaDeInstituicao),
                                                                 ou(contem(Instituicao, ListaDeInstituicao), nuloGenerico(ListaDeInstituicao),verdadeiro).
excecao(prestador(IdPrest, Nome, Especialidade, Instituicao)) :- prestador(IdPrest, ListaDeNome, ListaDeEspecialidade, ListaDeInstituicao),
                                                                 ou(contem(Especialidade, ListaDeEspecialidade), nuloGenerico(ListaDeEspecialidade),verdadeiro).
excecao(prestador(IdPrest, Nome, Especialidade, Instituicao)) :- prestador(IdPrest, ListaDeNome, ListaDeEspecialidade, ListaDeInstituicao),
                                                                 ou(contem(Instituicao, ListaDeInstituicao), nuloGenerico(ListaDeInstituicao),verdadeiro).

% CUIDADO--------------------------------------------------------------------------------------------
% cuidado(#IdUt, #IdPrest, Descricao, Custo)
:- dynamic cuidado/6.

%% Invariantes de Cuidados 
+cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: nao(nulo(IdUt)).

-cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :- nao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)),
                                             nao(excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo))).

-cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: nao(nuloInterdito(Data)).
-cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: nao(nuloInterdito(IdUt)).
-cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: nao(nuloInterdito(IdPrest)).
-cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: nao(nuloInterdito(Descricao)).
-cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: nao(nuloInterdito(Custo)).

update(cuidado(IdCuid, _, nuloIntedito, _, _, _))  :: cuidado(IdCuid, _, nuloIntedito, _, _, _).
update(cuidado(IdCuid, _, _, nuloIntedito, _, _))  :: cuidado(IdCuid, _, _, nuloInterdito, _, _).
update(cuidado(IdCuid, _, _, _, nuloIntedito, _))  :: cuidado(IdCuid, _, _, _, nuloInterdito, _).
update(cuidado(IdCuid, _, _, _, _, nuloIntedito))  :: cuidado(IdCuid, _, _, _, _, nuloInterdito).


%% Excecoes de Cuidado
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, ListaDeData, ListaDeIdUt, ListaDeIdPrest, ListaDeDescricao, ListaDeCusto),
                                                                    ou(contem(Data, ListaDeData), nuloGenerico(ListaDeData), verdadeiro).
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, ListaDeData, ListaDeIdUt, ListaDeIdPrest, ListaDeDescricao, ListaDeCusto),
                                                                    ou(contem(IdUt, ListaDeIdUt), nuloGenerico(ListaDeIdUt), verdadeiro).
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, ListaDeData, ListaDeIdUt, ListaDeIdPrest, ListaDeDescricao, ListaDeCusto),
                                                                    ou(contem(IdPrest, ListaDeIdPrest), nuloGenerico(ListaDePrest), verdadeiro).
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, ListaDeData, ListaDeIdUt, ListaDeIdPrest, ListaDeDescricao, ListaDeCusto),
                                                                    ou(contem(Custo, ListaDeCusto), nuloGenerico(ListaDeCusto), verdadeiro).
% Manipulacao da Base de Conhecimento----------------------------------------------------------------

%% Inserção no Sistema --------------------------------------
addUtente(IdUt, Nome, Idade, Morada) :- evolucao(utente(IdUt, Nome, Idade, Morada)).
% Adiciona Prestador ao sistema
addPrestador(IdPrest, Nome, Especialidade, Instituicao) :- evolucao(prestador(IdPrest, Nome, Especialidade, Instituicao)).
% Adiciona Cuidados ao Sistema
addCuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :- evolucao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)).

contem(M, [M|T]).
contem(M, [(range(L,H))|T]) :- M >= L, M =< H..
contem(M, [_|T]) :- contem(M, T).

%% Remoção do Sistema --------------------------------
utente(4,[jorge,manuel],[12,13],aveiro).

test(1):- addUtente(2,[dan,mig],[range(12,20)],braga).
test(2):- addPrestador(2,mig,[pediatria,obstetricia],hospitalBraga).
test(3):- addCuidado(2,marco,2,nulo,texto,nuloInterdito).
test(4):- atualizacao(utente(2,dan,nuloIncerto,braga),utente(2,dan,20,braga)).
test(5):- atualizacao(utente(1, daniel, nuloInterdito, nuloInterdito),utente(1, marcoDantas, nuloInterdito, nuloInterdito)).
utente(1, daniel, nuloInterdito, nuloInterdito).
prestador(1, miguel, nulo, nulo).