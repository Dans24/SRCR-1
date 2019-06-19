:- op( 900,xfy,'::' ).

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).


bool(true).
-bool(false).

isExcecao(excecao(T)).

comprimento( S,N ) :-
    length( S,N ).

%% Sistema de evolução de conhecimento
teste([]).
teste([I|T]):- I,teste(T).

remocao(T):- retract(T).
remocao(T):- assert(T), !, fail.

insercao(T):- assert(T).
insercao(T):- retract(T),!,fail.



%% Improved Evolucao
%% Os termos dentro da exceção tem de respeitar os invariantes 
evolucaoExcecao(T):-
            findall(Invariante, +excecao(T)::Invariante, Lista),
            findall(Invariante, +T::Invariante, Lista2),
            insercao(excecao(T)),
            teste(Lista),
            teste(Lista2).

evolucao(T):-
            findall(Invariante, +T::Invariante, Lista),
            insercao(T),
            teste(Lista).

%% Os termos dentro da exceção tem de respeitar os invariantes
involucao(excecao(T)):- 
            findall(Invariante, -T :: Invariante, Lista),
            remocao(excecao(T)),
            teste(Lista).

involucao(T):- 
            nao(isExcecao(T)),
            findall(Invariante, -T :: Invariante, Lista),
            remocao(T),
            teste(Lista).



:- dynamic excecao/1.

%Predicados de identificação de Nulos
nulo(interdito).
nulo(incerto).
interdito(interdito).

%Caso de Estudo

%% Representar Conhecimento Positivo e Negativo

%Utente
:- dynamic utente/4.
%%  utente(IdUt,Nome,Idade,Morada)

%% Conhecimento Negativo
-utente(IdUt,Nome,Idade,Morada):-
        nao(utente(IdUt,Nome,Idade,Morada)),
        nao(excecao(utente(IdUt,Nome,Idade,Morada))).

%% Exemplos de Conhecimento Positivo
    %% O utente jorge tem 25 anos e mora em braga
utente(1,jorge,25,braga).

%% Exemplos de Conhecimento Negativo
    %% Sabe-se que a utente numero 2, Maria tem mais do que 40 anos
        %% Logo a Maria não pode ter 40 ou menos anos
-utente(2,maria,IDADE,Morada):- IDADE =< 40.

%Prestador
    %% prestador(idPrest,Nome,Especialidade,Instituicao)

:- dynamic prestador/4.

%% Conhecimento Negativo
-prestador(IdPrest,Nome,Especialidade,Instituicao):-
        nao(prestador(IdPrest,Nome,Especialidade,Instituicao)),
        nao(excecao(prestador(IdPrest,Nome,Especialidade,Instituicao))).

%Cuidado
    %% cuidado(Data,IdUt,IdPrest,Descricao,Custo)
:- dynamic cuidado/5.

%% Descrição não pode ser nula. Pode ser vazia.

%%--------------------------------------------------------------------------------------------------------

%% Representar casos de conhecimento Imperfeito, pela utilização de valores nulos de todos os tipos estudados;

%% Exemplo de conhecimento Incerto
    %% O utente 2 chama-se Maria e mora em guimaraes. A sua idade é incerta, uma vez que não se pergunta a idade a uma senhora
utente(2,maria,incerto,guimaraes).
excecao(utente(2,maria,_,guimaraes)).

%% Exemplo de conhecimento Interdito
    %% Por motivos confidencais o nome do utente 3 não pode ser acedido
        %% Este utente tem 34 anos e mora atualmente em Turim.
utente(3,interdito,34,turim).
+utente(IdUt,Nome,Idade,Morada) :: (
                    findall(
                        (IdUt,NS,Idade,Morada),
                        (utente(3,NS,34,turim), nao(interdito(NS))),
                        S ),
                    comprimento( S,N ), N == 0 
                  ).
excecao(utente(IdUt,Nome,Idade,Morada)):- utente(IdUt,interdito,Idade,Morada).

%% Exemplo de conhecimento Impreciso
    %% Houve uma corrupção no sistema de dados.
    %% Por causa disto é impossivel determinar se o utente 4 se chama marco ou mario.
    %% Neste caso representamos o conhecimento por duas excecoes.
    %% Sabe-se que o utente habita em braga e tem 21 anos. 
excecao(utente(4,marco,braga,21)).
excecao(utente(4,mario,braga,21)).

%% Mistura de conhecimento Impreciso+Incerto
    %% O utente numero 5 Joaquim tem a idade incerta e, devido a mudanças de habitação não se sabe se este mora em braga ou em guimaraes
    %% No caso de mistura de conhecimento incerto ou interdito este é representado na exceção com _ (uma variável não unificada).
excecao(utente(5,joaquim,_,braga)).
excecao(utente(5,joaquim,_,guimaraes)).

%% Mistura de conhecimento Impreciso+Interdito
    %% Sabe-se que a idade do utente 6 Gustavo está entre o intervalo [30,40[
    %% Por motivos alheios a sua morada está interdita
excecao(utente(6,gustavo,Idade,_)):- Idade<40, Idade>=30.
+utente(IdUt,Nome,Idade,Morada) :: (
                    findall(
                        (IdUt,Nome,Idade,MS),
                        (utente(6,gustavo,Idade,MS), nao(interdito(MS))),
                        S ),
                    comprimento( S,N ), N == 0 
                  ).
+(-utente(IdUt,Nome,Idade,Morada)) :: (
                    findall(
                        (IdUt,Nome,Idade,MS),
                        (-utente(6,gustavo,Idade,MS), nao(interdito(MS))),
                        S ),
                    comprimento( S,N ), N == 0 
                  ).

%%--------------------------------------------------------------------------------------------------------

%% Manipular invariantes que designem restrições à inserção e à remoção de conhecimento do sistema;

%% Invariantes
%%% Inserção de Conhecimento
%% O valor do id tem de ser inteiro e nao pode ser nao nulo
+utente(IdUt,Nome,Idade,Morada) :: (nao(nulo(IdUt)),integer(IdUt)).


%% Conhecimento positivo não pode ser negativo. 
+utente(IdUt,Nome,Idade,Morada)::nao(-utente(IdUt,Nome,Idade,Morada)).

%%% Remoção de Conhecimento
-(utente(IdUt,Nome,Idade,Morada))::(nao(interdito(Nome)),nao(interdito(Idade)),nao(interdito(Morada))).

%% Não se pode adicionar conhecimento negativo com nulos. 
+(-utente(IdUt,Nome,Idade,Morada))::(nao(nulo(Nome))).
%% A idade tem de ser um inteiro.
+(-utente(IdUt,Nome,Idade,Morada))::(nao(nulo(Idade)),integer(Idade)).
+(-utente(IdUt,Nome,Idade,Morada))::(nao(nulo(Morada))).

%% Invariante
    %% Por motivos legais não podem ser atendidos utentes das ilhas da madeira e dos açores
ilhas(madeira).
ilhas(acores).
+utente(IdUt,Nome,Idade,Morada)::(nao(ilhas(Morada))).

%%TODO Exemplos
%% Exemplos de Conhecimento Positivo
    %% O prestador juan especializa-se em ortopedia no hospital de braga
prestador(1,juan,ortopedia,hospitalbraga).

%% Exemplos de Conhecimento Negativo
    %% Sabe-se que o carlos não trabalha no hospital do porto
-prestador(2,carlos,_,hospitalporto).

%% Exemplo de conhecimento Incerto
    %% O prestador 2 carlos presta consultas de nutrição, não se sabe no entanto em que local
prestador(2,carlos,nutricao,incerto).
excecao(prestador(IdUt,Nome,Especialidade,Local)):- prestador(IdUt,Nome,Especialidade,incerto).

%% Exemplo de conhecimento Interdito
    %% Por motivos judiciais é impossivel aceder ao nome do prestador 3
        %% Este prestador especializa-se em cirurgia geral no hospital da beira
prestador(3,interdito,cirurgiageral,hospitalbeira).

%% Exemplo de conhecimento Impreciso
    %% Houve uma corrupção no sistema de dados.
    %% Por causa disto é impossivel determinar se o prestador antonio se especializa em Oncologia ou Oftalmologia.
    %% Sabe-se que o servico é prestado em lisboa. 
excecao(prestador(4,antonio,oncologia,hospitallisboa)).
excecao(prestador(4,antonio,oftalmologia,hospitallisboa)).

%% Invariantes
%%% Inserção de Conhecimento
+prestador(IdPrest,Nome,Especialidade,Instituicao) :: (nao(nulo(IdPrest)),integer(IdPrest)).

%% Conhecimento positivo não pode ser negativo. 
+prestador(IdPrest,Nome,Especialidade,Instituicao)::nao(-prestador(IdPrest,Nome,Especialidade,Instituicao)).

%% Não se pode adicionar conhecimento negativo com nulos. 
+(-prestador(IdPrest,Nome,Especialidade,Instituicao))::(nao(nulo(Nome))).
%% A idade tem de ser um inteiro.
+(-prestador(IdPrest,Nome,Especialidade,Instituicao))::(nao(nulo(Especialidade)),integer(Idade)).
+(-prestador(IdPrest,Nome,Especialidade,Instituicao))::(nao(nulo(Instituicao))).

    %%TODO Excecao interdito coisas
%%TODO invariantes negativos
-prestador(IdPrest,Nome,Especialidade,Instituicao)::(
                                        nao(interdito(Nome)),
                                        nao(interdito(Especialidade)),
                                        nao(interdito(Instituicao))
                                        ).

%% Conhecimento positivo não pode ser negativo. 
+prestador(IdPrest,Nome,Especialidade,Instituicao)::nao(-prestador(IdPrest,Nome,Especialidade,Instituicao)).

%%% Remoção de Conhecimento
-(prestador(IdPrest,Nome,Especialidade,Instituicao))::(nao(interdito(Nome)),nao(interdito(Especialidade)),nao(interdito(Instituicao))).

%% Não se pode adicionar conhecimento negativo com nulos. 
+(-prestador(IdPrest,Nome,Especialidade,Instituicao))::(nao(nulo(Nome))).
+(-prestador(IdPrest,Nome,Especialidade,Instituicao))::nao(nulo(Especialidade)).
+(-prestador(IdPrest,Nome,Especialidade,Instituicao))::nao(nulo(Instituicao)).

%% Conhecimento positivo não pode ser negativo. 
+cuidado(Data,IdUt,IdPrest,Descricao,Custo)::nao(-cuidado(Data,IdUt,IdPrest,Descricao,Custo)).

%% Não se pode adicionar conhecimento negativo com nulos. 
+(-cuidado(Data,IdUt,IdPrest,Descricao,Custo))::nao(nulo(Data)).
+(-cuidado(Data,IdUt,IdPrest,Descricao,Custo))::nao(nulo(IdUt)).
+(-cuidado(Data,IdUt,IdPrest,Descricao,Custo))::nao(nulo(IdPrest)).
+(-cuidado(Data,IdUt,IdPrest,Descricao,Custo))::nao(nulo(Descricao)).
+(-cuidado(Data,IdUt,IdPrest,Descricao,Custo))::nao(nulo(Custo)).

%%--------------------------------------------------------------------------------------------------------

%% Lidar com a problemática da evolução do conhecimento, criando os procedimentos adequados;

%% Exemplo de predicado que adiciona várias exceções
addUtentesImprecisos(Id,impreciso([X|T]),I,M):- addUtentesImprecisos(Id,X,I,M),addUtentesImprecisos(Id,impreciso(T),I,M).
addUtentesImprecisos(Id,impreciso([]),I,M).
addUtentesImprecisos(Id,N,impreciso([X|T]),M):- addUtentesImprecisos(Id,N,X,M),addUtentesImprecisos(Id,N,impreciso(T),M).
addUtentesImprecisos(Id,N,impreciso([]),M).
addUtentesImprecisos(Id,N,I,impreciso([X|T])):- addUtentesImprecisos(Id,N,I,X),addUtentesImprecisos(Id,N,I,impreciso(T)).
addUtentesImprecisos(Id,N,I,impreciso([])).
addUtentesImprecisos(Id,N,I,M):- evolucaoExcecao(utente(Id,N,I,M)).

%%--------------------------------------------------------------------------------------------------------

%% Desenvolver um sistema de inferência capaz de implementar os mecanismos de raciocínio inerentes a estes sistemas

nao(T):- T,!,fail.
nao(T).

si(T,verdadeiro):- T.
si(T,falso):- -T.
si(T,desconhecido):- nao(T),nao(-T).


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

siList([],verdadeiro).
siList([X|T],verdadeiro):- siList(T,verdadeiro), X.
siList([X|T],desconhecido):- siList(T,desconhecido), X.
siList([X|T],desconhecido):- siList(T,verdadeiro), nao(X), nao(-X).
siList([X|T],falso):- siList(T,falso), X.
siList([X|T],falso):- siList(T,falso), nao(X), nao(-X).
siList([X|T],falso):- siList(T,desconhecido),-X.
siList([X|T],falso):- siList(T,verdadeiro),-X.

siConj([],falso).
siConj([X|T],falso):- siConj(T,falso), -X.
siConj([X|T],desconhecido):- siConj(T,desconhecido), -X.
siConj([X|T],desconhecido):- siConj(T,falso), nao(X), nao(-X).
siConj([X|T],verdadeiro):- siConj(T,verdadeiro), -X.
siConj([X|T],verdadeiro):- siConj(T,verdadeiro), nao(X), nao(-X).
siConj([X|T],verdadeiro):- siConj(T,desconhecido), X.
siConj([X|T],verdadeiro):- siConj(T,falso), X.
