nuloInterdito(nuloInterdito).

% utente(#IdUt, Nome, Idade, Morada)
:- dynamic utente/4.
+utente(IdUt, Nome, Idade, Morada) :: (findall(IdUt, utente(IdUt, Nome, Idade, Morada), L1),
                                        comprimento(L1, 1), % Não pode haver repetidos
                                        findall((Nome2, Idade2, Morada2), utente(IdUt, Nome2, Idade2, Morada2), L2),
                                        IdUt >= 1, integer(IdUt), % Id é um número natural
                                        Idade >= 0, integer(Idade)). % Idade é um número natural ou 0
+utente(IdUt, Nome, nulo, Morada) :: (findall(IdUt, utente(IdUt, Nome, Idade, Morada), L),
                                        comprimento(L, 1),
                                        IdUt >= 1, integer(IdUt)).
+utente(IdUt, Nome, nuloInterdito, Morada) :: (findall(IdUt, utente(IdUt, Nome, Idade, Morada), L),
                                        comprimento(L, 1),
                                        IdUt >= 1, integer(IdUt)).
-utente(IdUt, Nome, Idade, Morada) :- nao(utente(IdUt, Nome, Idade, Morada)),
                                      nao(excecao(utente(IdUt, Nome, Idade, Morada))).
% O nome do utente pode ser nulo
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, nulo, Idade2, Morada2).
% O nome do utente pode ser nulo interdito
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, nuloInterdito, Idade2, Morada2).
% A idade do utente pode ser nulo
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, Nome2, nulo, Morada2).
% A idade do utente pode ser nulo interdito
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, Nome2, Idade2, nuloInterdito).
% A morada do utente pode ser nulo
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, Nome2, Idade2, nulo).
% A morada do utente pode ser nulo interdito
excecao(utente(IdUt, Nome, Idade, Morada)) :- utente(IdUt, Nome2, Idade2, nuloInterdito).

% prestador(#IdPrest, Nome, Especialidade, Instituicao)
:- dynamic prestador/4.
-prestador(IdPrest, Nome, Especialidade, Instituicao) :- nao(prestador(IdPrest, Nome, Especialidade, Instituicao)),
                                                         nao(excecao(prestador(IdPrest, Nome, Especialidade, Instituicao))).
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

% cuidado(#IdUt, #IdPrest, Descricao, Custo)
:- dynamic cuidado/4.
-cuidado(IdUt, IdPrest, Descricao, Custo) :- nao(cuidado(IdUt, IdPrest, Descricao, Custo)),
                                             nao(excecao(cuidado(IdUt, IdPrest, Descricao, Custo))).
% A descrição do cuidado pode ser nulo
excecao(cuidado(IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdUt, IdPrest, nulo, Custo).
% A descrição do cuidado pode ser nulo interdito
excecao(cuidado(IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdUt, IdPrest, nuloInterdito, Custo).
% O custo do cuidado pode ser nulo
excecao(cuidado(IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdUt, IdPrest, Descricao, nulo).
% O custo do cuidado pode ser nulo interdito
excecao(cuidado(IdUt, IdPrest, Descricao, Custo)) :- cuidado(IdUt, IdPrest, Descricao, nuloInterdito).

utente(1, daniel, nuloInterdito, nuloInterdito).
prestador(1, miguel, nulo, nulo).
cuidado(1, 1, nulo, nulo).