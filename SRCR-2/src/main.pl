?- consult(['inv.pl','si.pl']).

nuloInterdito(nuloInterdito).

nulo(nulo).
nulo([H|T]).
nulo(nuloInterdito).

nuloGenerico(nulo).
nuloGenerico(nuloInterdito).

:- dynamic excecao/1.
:- dynamic '-'/1.

%DATA---------------------------------------
%data(Mora, Minutos, Dia, Mes, Ano)
%data(D,M,A) :- natural(D), D =< 31, natural(M), M =< 12, integer(A).


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
update(utente(IdUt, _, _, _)) :: utente(IdUt, _, _, _).

%% Exceções de utente
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, ListaDeNome, ListaDeIdade, ListaDeMorada),
                                            ou(contem(Nome, ListaDeNome), nuloGenerico(ListaDeNome), verdadeiro),
                                            ou(contem(Idade, ListaDeIdade), nuloGenerico(ListaDeIdade), verdadeiro),
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

update(prestador(IdPrest, nuloIntedito, _, _))  :: prestador(IdPrest, nuloInterdito,_,_).
update(prestador(IdPrest, _, nuloIntedito, _))  :: prestador(IdPrest, _,nuloInterdito,_).
update(prestador(IdPrest, _, _, nuloInterdito)) :: prestador(IdPrest, _,_,nuloInterdito).
update(prestador(IdPrest, _, _, _)) :: prestador(IdPrest, _,_,_).


 
%% Excecoes de Prestador 
excecao(prestador(IdPrest, Nome, Especialidade, Instituicao)) :- prestador(IdPrest, ListaDeNome, ListaDeEspecialidade, ListaDeInstituicao),
                                                                 ou(contem(Nome, ListaDeNome), nuloGenerico(ListaDeNome),verdadeiro),
                                                                 ou(contem(Especialidade, ListaDeEspecialidade), nuloGenerico(ListaDeEspecialidade),verdadeiro),
                                                                 ou(contem(Instituicao, ListaDeInstituicao), nuloGenerico(ListaDeInstituicao),verdadeiro).


% CUIDADO--------------------------------------------------------------------------------------------
% cuidado(#IdUt, #IdPrest, Descricao, Custo)
:- dynamic cuidado/6.

%% Invariantes de Cuidados 

% O prestador e o utente tem de existir para poder haver cuidado.
+cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: (utente(IdUt,_,_,_), prestador(IdPrest,_,_,_)).

% Não pode haver cuidados repetidos.
+cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: (
                                                            findall(IdCuid, cuidado(IdCuid, _, _, _, _, _), L1),
                                                            comprimento(L1, 1) % Não pode haver repetidos
                                                         ).

% Um prestador não pode ter mais do que 8 cuidados por dia 
+cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: (
                                                            findall(Data, cuidado(_, Data, _, _, _, _), L1),
                                                            comprimento(L1, S), S=<8
                                                         ).


%find(cuidado(IdUt, Nome, Idade, Morada),R) :- findall((IdUt, Nome, Idade, Morada), -utente(IdUt, Nome, Idade, Morada), R).

+cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: nao(nulo(IdUt)).
+cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: nao(nulo(IdPrest)).
+cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :: nao(nulo(Descricao)).

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
update(cuidado(IdCuid, _, _, _, _, _))  :: cuidado(IdCuid, _, _, _, _, _).

%% Excecoes de Cuidado
excecao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdCuid, ListaDeData, ListaDeIdUt, ListaDeIdPrest, ListaDeDescricao, ListaDeCusto),
                                            ou(contem(Data, ListaDeData), nuloGenerico(ListaDeData), verdadeiro),
                                            ou(contem(IdUt, ListaDeIdUt), nuloGenerico(ListaDeIdUt), verdadeiro),
                                            ou(contem(IdPrest, ListaDeIdPrest), nuloGenerico(ListaDePrest), verdadeiro),
                                            ou(contem(Descricao, ListaDeDescricao), nuloGenerico(ListaDeDescricao), verdadeiro),
                                            ou(contem(Custo, ListaDeCusto), nuloGenerico(ListaDeCusto), verdadeiro).

% Manipulacao da Base de Conhecimento----------------------------------------------------------------

%% Inserção de conhecimento positivo no Sistema --------------------------------------
% Adiciona Utente ao sistema
addUtentePos(IdUt, Nome, Idade, Morada) :- evolucao(utente(IdUt, Nome, Idade, Morada)).
% Adiciona Prestador ao sistema
addPrestadorPos(IdPrest, Nome, Especialidade, Instituicao) :- evolucao(prestador(IdPrest, Nome, Especialidade, Instituicao)).
% Adiciona Cuidados ao Sistema
addCuidadoPos(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :- evolucao(cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)).

%% Inserção de conhecimento negativo no Sistema --------------------------------------
% Adiciona Utente ao sistema
addUtenteNeg(IdUt, Nome, Idade, Morada) :- evolucao(-utente(IdUt, Nome, Idade, Morada)).
% Adiciona Prestador ao sistema
addPrestadorNeg(IdPrest, Nome, Especialidade, Instituicao) :- evolucao(-prestador(IdPrest, Nome, Especialidade, Instituicao)).
% Adiciona Cuidados ao Sistema
addCuidadoNeg(IdCuid, Data, IdUt, IdPrest, Descricao, Custo) :- evolucao(-cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)).

% Não se pode adicionar conhecimento negativo que seja verdade.
+(-T) :: nao(T).

% Não se pode adicionar conhecimento negativo repetido, ou seja, todas as variáveis iguais.
+(-utente(IdUt, Nome, Idade, Morada)) :: (findall(IdUt, -utente(IdUt, Nome, Idade, Morada), L),
                                          comprimento(L,2)).

+(-prestador(IdPrest, Nome, Especialidade, Instituicao)) :: (findall(IdPrest, -prestador(IdPrest, Nome, Especialidade, Instituicao), L),
                                          comprimento(L,2)).

+(-cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo)) :: (findall(IdCuid, -cuidado(IdCuid, Data, IdUt, IdPrest, Descricao, Custo), L),
                                          comprimento(L,2)).


%% Alteração de conhecimento positivo no Sistema --------------------------------------
alterUtenteNome(IdUt,Nome):- utente(IdUt,N,I,M), atualizacao(utente(IdUt,N,I,M), utente(IdUt,Nome,I,M)).
alterUtenteIdade(IdUt,Idade):- utente(IdUt,N,I,M), atualizacao(utente(IdUt,N,I,M), utente(IdUt,N,Idade,M)).
alterUtenteMorada(IdUt,Morada):- utente(IdUt,N,I,M), atualizacao(utente(IdUt,N,I,M), utente(IdUt,N,I,Morada)).

alterPrestadorNome(IdPrest,Nome):- prestador(IdPrest, N, E, I), atualizacao(prestador(IdPrest, N, E, I),prestador(IdPrest, Nome, E, I)).
alterPrestadorEspecialidade(IdPrest,Esp):- prestador(IdPrest, N, E, I), atualizacao(prestador(IdPrest, N, E, I),prestador(IdPrest, N, Esp, I)).
alterPrestadorInstituicao(IdPrest,Inst):- prestador(IdPrest, N, E, I), atualizacao(prestador(IdPrest, N, E, I),prestador(IdPrest, N, E, Inst)).

alterCuidadoData(IdCuid,Data) :- cuidado(IdCuid, D, IU, IP, De, C), atualizacao(cuidado(IdCuid, D, IU, IP, De, C),cuidado(IdCuid, Data, IU, IP, De, C)).
alterCuidadoUtente(IdCuid,Ut) :- cuidado(IdCuid, D, IU, IP, De, C), atualizacao(cuidado(IdCuid, D, IU, IP, De, C),cuidado(IdCuid, D, Ut, IP, De, C)).
alterCuidadoPrest(IdCuid,Pret) :- cuidado(IdCuid, D, IU, IP, De, C), atualizacao(cuidado(IdCuid, D, IU, IP, De, C),cuidado(IdCuid, D, IU, Pret, De, C)).
alterCuidadoDesc(IdCuid,Desc) :- cuidado(IdCuid, D, IU, IP, De, C), atualizacao(cuidado(IdCuid, D, IU, IP, De, C),cuidado(IdCuid, D, IU, IP, Desc, C)).
alterCuidadoCust(IdCuid,Custo) :- cuidado(IdCuid, D, IU, IP, De, C), atualizacao(cuidado(IdCuid, D, IU, IP, De, C),cuidado(IdCuid, D, IU, IP, De, Custo)).

contem(M, M).
contem(M, [M|T]).
contem(M, [(range(L, H))|T]) :- M >= L, M =< H.
contem(M, [_|T]) :- contem(M, T).

%Cálculo da quantidade de gastos de um utente.
% CC -> CustoCerto -- quanto paga de certeza
% II -> IncertezaInferior -- valor minimo que é incerto pagar
% IS -> IncertezaSuperior -- valor máximo que é incerto pagar
gastosTotaisCliente(IdUt, CC, II, IS) :- findall(C, consulta(_, _, IdUt, _, _, C), L), soma(L,CC,II,IS).


soma([], 0, 0, 0).
soma([[H|T1]|T2], Total, IITotal, ISTotal) :- soma(T2, Total, RestoI, RestoS), somaI([H|T1], AuxI, AuxS), 
                                                                               IITotal is RestoI + AuxI, 
                                                                               ISTotal is RestoS + AuxS.  
soma([H|T], Total, II, IS) :- soma(T, Resto, II, IS), Total is H + Resto.

somaI([], 0, 0).
somaI([(range(X, Y))|T], IITotal, ISTotal) :- somaI(T, RestoI, RestoS), IITotal is RestoI + X, ISTotal is RestoS + Y.
somaI([H|T], IITotal, ISTotal) :- somaI(T, RestoI, RestoS), IITotal is RestoI + H, ISTotal is RestoS + H.

%% Remoção do Sistema --------------------------------
utente(4,[jorge,manuel],[12,13],aveiro).

test(1):- addUtentePos(2,[dan,mig],[range(12,20)],braga).
test(2):- addPrestadorPos(2,mig,[pediatria,obstetricia],hospitalBraga).
test(3):- addCuidadoPos(2,marco,2,nulo,texto,nuloInterdito).
test(4):- atualizacao(utente(2,dan,[14],braga),utente(2,dan,20,braga)).
test(5):- atualizacao(utente(1, daniel, nuloInterdito, nuloInterdito),utente(1, marcoDantas, nuloInterdito, nuloInterdito)).
utente(1, daniel, nuloInterdito, nuloInterdito).
prestador(1, miguel, nulo, nulo).