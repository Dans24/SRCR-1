%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Programacao em logica estendida

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado si: Questao,Resposta -> {V,F}
%                            Resposta = { verdadeiro,falso,desconhecido }

si( Questao,verdadeiro ) :-
    Questao.
si( Questao,falso ) :-
    -Questao.
si( Questao,desconhecido ) :-
    nao( Questao ),
    nao( -Questao ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).

%e predicado conjunção
e(T1,T2,verdadeiro):- si(T1,verdadeiro),si(T2,verdadeiro).
e(T1,T2,falso):- si(T1,falso).
e(T1,T2,falso):- si(T2,falso).
e(T1,T2,desconhecido).

%ou predicado conjunção
ou(T1,T2,verdadeiro):- si(T1,verdadeiro).
ou(T1,T2,verdadeiro):- si(T2,verdadeiro).
ou(T1,T2,falso):- si(T1,falso),si(T2,falso).
ou(T1,T2,desconhecido).

%xor
xor(T1,T2,verdadeiro):- si(T1,verdadeiro),si(T2,falso).
xor(T1,T2,verdadeiro):- si(T1,falso),si(T2,verdadeiro).
xor(T1,T2,falso):- si(T1,verdadeiro),si(T2,verdadeiro).
xor(T1,T2,falso):- si(T1,falso),si(T2,falso).
xor(T1,T2,desconhecido).