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

isExcecao(excecao(T)).


%% Sistema de evolução de conhecimento
teste([]).
teste([I|T]):- I,teste(T).

remocao(T):- retract(T).
remocao(T):- assert(T), !, fail.

insercao(T):- assert(T).
insercao(T):- retract(T),!,fail.



%% Improved Evolucao
evolucao(excecao(T)):- 
            findall(Invariante, +T::Invariante, Lista),
            insercao(excecao(T)),
            teste(Lista).

evolucao(T):-
            nao(isExcecao(T)),
            findall(Invariante, +T::Invariante, Lista),
            insercao(T),
            teste(Lista).

%% TODO: INVOLUCAO IMPROVED
involucao(T):- findall(Invariante, -T :: Invariante, Lista),
              remocao(T),
              teste(Lista).


%% Predicados Lógicos
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

%Predicados de identificação de Nulos
nulo(interdito).
nulo(incerto).
interdito(interdito).

%Caso de Estudo

%Utente
:- dynamic utente/4.
%%  utente(IdUt,Nome,Idade,Morada)

%% Conhecimento Negativo
-utente(IdUt,Nome,Idade,Morada):-
        nao(utente(IdUt,Nome,Idade,Morada)),
        nao(excecao(utente(IdUt,Nome,Idade,Morada))).


%% Invariantes
%%% Inserção de Conhecimento
%% O valor do id tem de ser inteiro e nao pode ser nao nulo
+utente(IdUt,Nome,Idade,Morada) :: (nao(nulo(IdUt)),integer(IdUt)).

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
+utente(IdUt,Nome,Idade,Morada)::nao(interdito(Idade)), nao(utente(IdUt,Nome,interdito,Morada)).
+utente(IdUt,Nome,Idade,Morada)::nao(interdito(Morada)), nao(utente(IdUt,Nome,Idade,interdito)).

%% TODO: se o conhecimento for interdito na exceção não pode inserir valor como no caso de cima ^
%% Ideia predicados nomeIncerto(Id), idadeIncerto(Id), moradaIncerto(Id) para todos os atributos
    %%  nomeIncerto(IdUt):-utente(IdUt,interdito,Idade,Morada).
    %%  +nomeIncerto(Id)::nao(nulo(Id)). 
    %%  -nomeIncerto(Id). Para não ser possivel remover o predicado
    %%  Invariante passa a +utente(IdUt,Nome,Idade,Morada)::nao(nomeIncerto(IdUt)),nao(idadeIncerto(IdUt)),nao(moradaIncerto(IdUt)).


%% Conhecimento positivo não pode ser negativo. 
+utente(IdUt,Nome,Idade,Morada)::nao(-utente(IdUt,Nome,Idade,Morada)).

%%% Remoção de Conhecimento
-(utente(IdUt,Nome,Idade,Morada))::nao(interdito(Nome)),nao(interdito(Idade)),nao(interdito(Morada)).


%% Excecoes
%% excecao(Utente(IdUt,Nome,Idade,Morada))
%% As exceções que permitem várias combinações conhecimento interdito e incerto
excecao(utente(Id,N,I,M)):-
        utente(Id,NUL1,I,M), nulo(NUL1).
excecao(utente(Id,N,I,M)):-
        utente(Id,N,NUL2,M), nulo(NUL2).
excecao(utente(Id,N,I,M)):-
        utente(Id,N,I,NUL3), nulo(NUL3).
excecao(utente(Id,N,I,M)):-
        utente(Id,NUL1,NUL2,M), nulo(NUL1), nulo(NUL2).
excecao(utente(Id,N,I,M)):-
        utente(Id,NUL1,I,NUL3), nulo(NUL1), nulo(NUL3).
excecao(utente(Id,N,I,M)):-
        utente(Id,N,NUL2,NUL3), nulo(NUL2), nulo(NUL3).
excecao(utente(Id,N,I,M)):-
        utente(Id,NUL1,NUL2,NUL3), nulo(NUL1),nulo(NUL2),nulo(NUL3).


%% Exemplos de Conhecimento Positivo
    %% O utente jorge tem 25 anos e mora em braga
utente(1,jorge,25,braga).

%% Exemplos de Conhecimento Negativo
    %% Sabe-se que a utente numero 2, Maria tem mais do que 40 anos
        %% Logo a Maria não pode ter 40 ou menos anos
-utente(2,maria,IDADE,_):- IDADE =< 40.


%%Exemplos de Utente
%% Exemplo de conhecimento Incerto
    %% O utente 2 chama-se Maria e mora em guimaraes. A sua idade é incerta, uma vez que não se pergunta a idade a uma senhora
utente(2,maria,incerto,guimaraes).

%% Exemplo de conhecimento Interdito
    %% Por motivos confidencais o nome do utente 3 não pode ser acedido
        %% Este utente tem 34 anos e mora atualmente em Turim.
utente(3,interdito,34,turim).

%% Exemplo de conhecimento Impreciso
    %% Houve uma corrupção no sistema de dados.
    %% Por causa disto é impossivel determinar se o utente 4 se chama marco ou mario.
    %% Neste caso representamos o conhecimento por duas excecoes.
    %% Sabe-se que o utente habita em braga e tem 21 anos. 
utente(4,marco,braga,21).
utente(4,mario,braga,21).

%% Mistura de conhecimento Impreciso+(Interdito/Incerto)
    %% O utente numero 5 Joaquim tem a idade incerta e, devido a mudanças de habitação não se sabe se este mora em braga ou em guimaraes
    %% No caso de mistura de conhecimento incerto ou interdito este é representado na exceção com _ (uma variável não unificada).
excecao(utente(5,joaquim,_,braga)).
excecao(utente(5,joaquim,_,guimaraes)).
    %% TODO: No caso da idade ser interdita representamos da seguinte forma:
        %% idadeInterdita(5)
    %% Isto serve para, quando for feita uma atualização, prevenir a substituíção de valores interditos.