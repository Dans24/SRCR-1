:- op( 900,xfy,'::' ).

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

nao(T):- T,!,fail.
nao(T).

si(T,verdadeiro):- T.
si(T,falso):- -T.
si(T,desconhecido):- nao(T),nao(-T).

bool(true).
-bool(false).

teste([]).
teste([I|T]):- I,teste(T).

remocao(T):- retract(T).
remocao(T):- assert(T), !, fail.

insercao(T):- assert(T).
insercao(T):- retract(T),!,fail.

evolucao(excecao(T)):- 
            findall(Invariante, +T::Invariante, Lista),
            insercao(excecao(T)),
            teste(Lista).

isExcecao(excecao(T)).

evolucao(T):-
            nao(isExcecao(T)),
            findall(Invariante, +T::Invariante, Lista),
            insercao(T),
            teste(Lista).

involucao(T):- findall(Invariante, -T :: Invariante, Lista),
              remocao(T),
              teste(Lista).



ou(T1,T2):- T1.
ou(T1,T2):- T2. 
-ou(T1,T2):- -T1,-T2.

e(T1,T2):- T1, T2.
-e(T1,T2):- T1,-T2.
-e(T1,T2):- -T1,T2.

xor(T1,T2):- T1,-T2.
xor(T1,T2):- -T1,T2.
-xor(T1,T2):- T1,T2.
-xor(T1,T2):- -T1,-T2.


:- dynamic excecao/1.
:- dynamic utente/4.


nulo(interdito).
nulo(incerto).
interdito(interdito).


%Utente
%%  utente(IdUt,Nome,Idade,Morada)

%% Conhecimento Negativo
-utente(IdUt,Nome,Idade,Morada):-
        nao(utente(IdUt,Nome,Idade,Morada)),
        nao(excecao(utente(IdUt,Nome,Idade,Morada))).


%% Invariantes
%%% Inserção de Conhecimento
+utente(IdUt,Nome,Idade,Morada) :: (
    ou(
        (
            integer(Idade),
            Idade \= 10
        ),
        nulo(Idade)
    )
).
%% Não é possivel a inserção de conhecimento se esse conhecimento for interdito
+utente(IdUt,Nome,Idade,Morada)::nao(interdito(Nome)), nao(utente(IdUt,interdito,Idade,Morada)).
+utente(IdUt,Nome,Idade,Morada)::nao(interdito(Idade)),nao(utente(IdUt,Nome,interdito,Morada)).
+utente(IdUt,Nome,Idade,Morada)::nao(interdito(Morada)),nao(utente(IdUt,Nome,Idade,interdito)).
%% Conhecimento positivo não pode ser negativo. 
+utente(IdUt,Nome,Idade,Morada)::nao(-utente(IdUt,Nome,Idade,Morada)).

%%% Remoção de Conhecimento
-(utente(IdUt,Nome,Idade,Morada))::nao(interdito(Nome)),nao(interdito(Idade)),nao(interdito(Morada)).

%% Exemplos de Conhecimento 
utente(1,ray,3,incerto).
utente(2,interdito,3,incerto).

+(excecao(utente(Id,N,I,M))) :: (integer(I),I\=10).

interdito(interdito).

%% Excecoes
%%  excecao(Utente(IdUt,Nome,Idade,Morada))
excecao(utente(Id,N,I,M)):-
        utente(Id,NUL,I,M), nulo(NUL).
excecao(utente(Id,N,I,M)):-
        utente(Id,N,I,NUL), nulo(NUL).
excecao(utente(Id,N,I,M)):-
        utente(Id,NUL1,I,NUL2), nulo(NUL1), nulo(NUL2).


