:- op( 900,xfy,'::' ).

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).


bool(true).
-bool(false).

isExcecao(excecao(T)).

comprimento( S,N ) :-
    length( S,N ).



:- dynamic excecao/1.
:- dynamic '::'/2.

% Predicados de identificação de Nulos
nulo(interdito).
nulo(incerto).
interdito(interdito).

% Caso de Estudo

%%--------------------------------------------------------------------------------------------------------------
%% Representar Conhecimento Positivo e Negativo
%%--------------------------------------------------------------------------------------------------------------


% Utente -----------------------------------------------------------------------

    %%  utente(IdUt,Nome,Idade,Morada)
    :- dynamic utente/4.

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
    -utente(2,maria,IDADE,guimaraes):- IDADE =< 40.


% Prestador -----------------------------------------------------------------------

    %% prestador(idPrest,Nome,Especialidade,Instituicao)
    :- dynamic prestador/4.

    %% Conhecimento Negativo
    -prestador(IdPrest,Nome,Especialidade,Instituicao):-
            nao(prestador(IdPrest,Nome,Especialidade,Instituicao)),
            nao(excecao(prestador(IdPrest,Nome,Especialidade,Instituicao))).

    %% Exemplos de Conhecimento Positivo
        %% O prestador juan especializa-se em ortopedia no hospital de braga
    prestador(1,juan,ortopedia,hospitalbraga).

    %% Exemplos de Conhecimento Negativo
        %% Sabe-se que o carlos não trabalha no hospital do porto
    -prestador(2,carlos,genecologista,hospitalporto).


% Cuidado -----------------------------------------------------------------------

    %% cuidado(Data,IdUt,IdPrest,Descricao,Custo)
    :- dynamic cuidado/7.

    %% Conhecimento Negativo
    -cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo):-
            nao(cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo)),
            nao(excecao(cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo))).

    %% Exemplos de Conhecimento Positivo
        %% No dia 18/6/2019, foi prestado um cuidado ao utente Jorge(1), pelo prestador Juan(1), 
        %% com a descrição "consulta ortopedia" e teve o custo de 20€ (2000 cêntimos)
    cuidado(18,6,2019,1,1,consultaOrtopedia,2000).

    %% Exemplos de Conhecimento Negativo
        %% O prestador Carlos(2) nunca participou num cuidado com o utente Jorge(1) no ano 2018.
    -prestador(_,_,2018,1,2,_,_).



%%--------------------------------------------------------------------------------------------------------------
%% Representar casos de conhecimento Imperfeito, pela utilização de valores nulos de todos os tipos estudados;
%%--------------------------------------------------------------------------------------------------------------


% Utente -----------------------------------------------------------------------

    %% Exemplo de conhecimento Incerto
    %% O utente 2 chama-se Maria e mora em guimaraes. A sua idade é incerta, uma vez que não se pergunta a idade a uma senhora
    utente(2,maria,incerto,guimaraes).
    excecao(utente(IdUt,Nome,Idade,Morada)):- utente(IdUt,Nome,incerto,Morada).

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

    %% Exemplo de conhecimento Impreciso em mais do que um atributo de utente
    %% O utente tinha um sotaque muito carregado e quando disse as suas informações ao funcionário ele ficou indeciso em relação ao nome
    %% e morada, por lapso o funcionário não registou a sua idade, mas pela aparência da pessoa deduziu que teria mais de 50 anos.
    excecao(utente(7,paco,Idade,la_paz)) :- Idade > 50. 
    excecao(utente(7,paulo,Idade,la_paz)) :- Idade > 50.
    excecao(utente(7,paco,Idade,lapas)) :- Idade > 50.
    excecao(utente(7,paulo,Idade,lapas)) :- Idade > 50.

    %% Mistura de conhecimento Impreciso+Incerto
    %% O utente numero 5 Joaquim tem a idade incerta e, devido a mudanças de habitação não se sabe se este mora em braga ou em guimaraes
    %% No caso de mistura de conhecimento incerto ou interdito este é representado na exceção com _ (uma variável não unificada).
    excecao(utente(5,joaquim,incerto,braga)).
    excecao(utente(5,joaquim,incerto,guimaraes)).

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

    /** Acho que até faz bastante sentido
    +(-utente(IdUt,Nome,Idade,Morada)) :: (
                        findall(
                            (IdUt,Nome,Idade,MS),
                            (-utente(6,gustavo,Idade,MS), nao(interdito(MS))),
                            S ),
                        comprimento( S,N ), N == 0 
                    ).
    */


% Prestador -----------------------------------------------------------------------

%% Exemplo de conhecimento Incerto
    %% O prestador 2 carlos presta consultas de nutrição, não se sabe no entanto em que instituicao
    prestador(2,carlos,nutricao,incerto).
    excecao(prestador(IdPrest,Nome,Especialidade,Instituicao)):- prestador(IdPrest,Nome,Especialidade,incerto).

%% Exemplo de conhecimento Interdito
    %% Por motivos judiciais é impossivel aceder ao nome do prestador 3
        %% Este prestador especializa-se em cirurgia geral no hospital da beira
    prestador(3,interdito,cirurgiageral,hospitalbeira).
    +prestador(IdPrest,Nome,Especialidade,Instituicao) :: (
                        findall(
                            (IdPres,NS,Especialidade,Instituicao),
                            (utente(3,NS,Especialidade,Instituicao), nao(interdito(NS))),
                            S ),
                        comprimento( S,N ), N == 0 
                    ).
    excecao(prestador(IdPrest,Nome,Especialidade,Instituicao)):- prestador(IdPrest,interdito,Especialidade,Instituicao).

%% Exemplo de conhecimento Impreciso
    %% Houve uma corrupção no sistema de dados.
    %% Por causa disto é impossivel determinar se o prestador antonio se especializa em Oncologia ou Oftalmologia.
    %% Sabe-se que o prestador é do hospital de lisboa. 
    excecao(prestador(4,antonio,oncologia,hospitallisboa)).
    excecao(prestador(4,antonio,oftalmologia,hospitallisboa)).

%% Exemplo de conhecimento Incerto+Impreciso
    %% Foi requisitado um médico de urgência para prestar assistência numa intervenção cirurgica a um coração, ficou indefinida qual
    %% a sua instituição de trabalho e, por outro lado, não há certeza se o prestador era um cardiologista ou um cirurgiao_cardiovascular.
    %% Sabe-se que o prestador chama-se jorge.
    excecao(prestador(5,jorge,cardiologista,_)).
    excecao(utente(5,jorge,cirurgiao_cardiovascular,_)).

%%Exemplo de conhecimento Incerto+Interdito
    %% Houve uma falha no sistema
    %% Não é possível determinar o nome do prestador, sendo que são interditas a sua especialidade e instituição 
    excecao(prestador(6,_,_,_)).
    +prestador(IdPrest,Nome,Especialidade,Instituicao) :: (
                        findall(
                            (IdPrest,NS,Especialidade,Instituicao),
                            (prestador(6,NS,Especialidade,Instituicao), nao(interdito(Especialidade)), nao(interdito(Instituicao))),
                            S ),
                        comprimento( S,N ), N == 0 
                    ).


% Cuidado -----------------------------------------------------------------------

%% Exemplo de conhecimento Incerto
    %% O valor pago na consulta administrada pelo prestador 2 ao utente 1 no dia 3 de junho de 2019
    cuidado(3,6,2019,1,2,"utente perdeu 2 kilos desde a ultima consulta",incerto).
    excecao(cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo)):- cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,incerto).

%% Exemplo de conhecimento Interdito
    %% A descrição do cuidado ... é interdita
    cuidado(25,4,2018,2,3,interdito,250).
    +cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo) :: (
                        findall(
                            (Dia,Mes,Ano,IdUt,IdPrest,DS,Custo),
                            (cuidado(25,4,2018,2,3,DS,250), nao(interdito(DS))),
                            S ),
                        comprimento( S,N ), N == 0 
                    ).
    excecao(cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo)):- cuidado(Dia,Mes,Ano,IdUt,IdPrest,interdito,Custo).

%% Exemplo de conhecimento Impreciso
    %% A pessoa responsável pelo registo dos cuidados não percebeu qual o cuidado que ia ser administrado ao utente
    %% Por causa disto não se sabe se o cuidado administrado no dia 5 de agosto de 2017 foi do prestador 1 ou 3
    excecao(cuidado(5,8,2018,2,3,descricao,300)).
    excecao(cuidado(5,8,2018,2,1,descricao,300)).

%% TODO mais alguns exemplos



%% Exemplo de imprecisão na data da consulta.
    %% No dia em que a consulta foi registada o sistema estava com graves falhas, levando a que haja uma grande incerteza
    %% em relação à data da consulta e o seu custo.
    %% Sabe-se que deve ter ocorrido em abril ou junho, sendo que só pode ter ocorrido entre o dia 10 e o 30,
    %% porém é sabido que se ocorreu em abril não pode ter sido no dia 25 e se foi em junho não pode ter sido no dia 10, pois são feriados. 
    %% O ano foi 2019.
    %% O custo foi inferior a 500 euros, mas não pode ter sido de graça.
    excecao(cuidado(Dia,Mes,2017,2,3,"",Custo)) :- Mes =:= 4, Dia >= 10, Dia =< 30, Dia \= 25, Custo < 500, Custo \= 0.
    excecao(cuidado(Dia,Mes,2017,2,3,"",Custo)) :- Mes =:= 6, Dia > 10, Dia =< 30, Custo < 500, Custo \= 0.

%% TODO Mistura de conhecimento

%% !! Não me lembro se podemos ter tipos de conhecimentos diferentes na PK
%% Exemplo de Mistura de conhecimento Incerto+Interdito+Impreciso
    %% Foi realizada um intervenção de urgência a uma figura muito relevante na sociedade portuguesa e a pedido
    %% dessa mesma ela não pode estar associada a este registo de consulta.
    %% Sabe-se que o custo ou foi de 500 euros ou então está entre os 1000 e os 2000 euros.
    %% A consulta foi realizada no mes de janeiro em 2009. O dia da consulta é incerto.
    excecao(cuidado(_,1,2009,_,2, "utente mostra sinais de abuso", Custo)) :- Custo =:= 500. 
    excecao(cuidado(_,1,2009,_,2, "utente mostra sinais de abuso", Custo)) :- Custo >= 1000, Custo =< 2000.
    +cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo) :: (
                        findall(
                            (Dia,Mes,Ano,IdUt,IdPrest,DS,Custo),
                            (cuidado(Dia,1,2009,IdUt,2,"utente mostra sinais de abuso",Custo), nao(interdito(IdUt))),
                            S ),
                        comprimento( S,N ), N == 0 
                    ).



%%--------------------------------------------------------------------------------------------------------------
%% Manipular invariantes que designem restrições à inserção e à remoção de conhecimento do sistema;
%%--------------------------------------------------------------------------------------------------------------

% Utente -----------------------------------------------------------------------

%% Inserção de Conhecimento

    %% O valor do id tem de ser inteiro e nao pode ser nao nulo
    +utente(IdUt,Nome,Idade,Morada) :: (nao(nulo(IdUt)),integer(IdUt)).

    %% Conhecimento positivo não pode ser negativo. 
    +utente(IdUt,Nome,Idade,Morada)::nao(-utente(IdUt,Nome,Idade,Morada)).
    +(-utente(IdUt,Nome,Idade,Morada))::nao(utente(IdUt,Nome,Idade,Morada)).


%% Remoção de Conhecimento

    %% 
    -(utente(IdUt,Nome,Idade,Morada))::(nao(interdito(Nome)),nao(interdito(Idade)),nao(interdito(Morada))).

    %% Não se pode adicionar conhecimento negativo com nulos. 
    +(-utente(IdUt,Nome,Idade,Morada))::(nao(nulo(Nome))).

    %% A idade tem de ser um inteiro.
    +(-utente(IdUt,Nome,Idade,Morada))::(nao(nulo(Idade)),integer(Idade)).
    +(-utente(IdUt,Nome,Idade,Morada))::(nao(nulo(Morada))).

    %% Por motivos legais não podem ser atendidos utentes das ilhas da madeira e dos açores
    ilhas(madeira).
    ilhas(acores).
    +utente(IdUt,Nome,Idade,Morada)::(nao(ilhas(Morada))).


% Prestador -----------------------------------------------------------------------

    %% Inserção de Conhecimento
    
        %
        +prestador(IdPrest,Nome,Especialidade,Instituicao) :: (nao(nulo(IdPrest)),integer(IdPrest)).

        %% Conhecimento positivo não pode ser negativo. 
        +prestador(IdPrest,Nome,Especialidade,Instituicao)::nao(-prestador(IdPrest,Nome,Especialidade,Instituicao)).
        +(-prestador(IdPrest,Nome,Especialidade,Instituicao))::nao(prestador(IdPrest,Nome,Especialidade,Instituicao)).
        %% Não se pode adicionar conhecimento negativo com nulos. 
        +(-prestador(IdPrest,Nome,Especialidade,Instituicao))::(nao(nulo(Nome))).
        +(-prestador(IdPrest,Nome,Especialidade,Instituicao))::(nao(nulo(Especialidade)),integer(Idade)).
        +(-prestador(IdPrest,Nome,Especialidade,Instituicao))::(nao(nulo(Instituicao))).
        
        %%TODO invariantes negativos
        -prestador(IdPrest,Nome,Especialidade,Instituicao)::(
                                                nao(interdito(Nome)),
                                                nao(interdito(Especialidade)),
                                                nao(interdito(Instituicao))
                                                ).


    %% Remoção de Conhecimento
    
        % Não se pode remover conhecimento com algum atributo interdito.
        -(prestador(IdPrest,Nome,Especialidade,Instituicao))::(nao(interdito(Nome)),nao(interdito(Especialidade)),nao(interdito(Instituicao))).

        %% Não se pode adicionar conhecimento negativo com nulos. 
        +(-prestador(IdPrest,Nome,Especialidade,Instituicao))::(nao(nulo(Nome))).
        +(-prestador(IdPrest,Nome,Especialidade,Instituicao))::nao(nulo(Especialidade)).
        +(-prestador(IdPrest,Nome,Especialidade,Instituicao))::nao(nulo(Instituicao)).


% Cuidado -----------------------------------------------------------------------

    %% Conhecimento positivo não pode ser negativo. 
    +cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo)::nao(-cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo)).
    +(-cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo))::nao(cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo)).

    %% Não se pode adicionar conhecimento negativo com nulos. 
    +(-cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo))::nao(nulo(Dia)).
    +(-cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo))::nao(nulo(Mes)).
    +(-cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo))::nao(nulo(Ano)).
    +(-cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo))::nao(nulo(IdUt)).
    +(-cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo))::nao(nulo(IdPrest)).
    +(-cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo))::nao(nulo(Descricao)).
    +(-cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo))::nao(nulo(Custo)).

    %% O custo de um cuidado tem de ser positivo

    positivo(N):- integer(N), N>0.
    positivo(incerto).
    positivo(interdito).
    +cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo)::(positivo(Custo)).



%%--------------------------------------------------------------------------------------------------------------
%% Lidar com a problemática da evolução do conhecimento, criando os procedimentos adequados;
%%--------------------------------------------------------------------------------------------------------------


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
                nao(T),
                findall(Invariante, +excecao(T)::Invariante, Lista),
                insercao(excecao(T)),
                teste(Lista).

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

    involucaoAll([X|T]):- involucao(X), involucaoAll(T).
    involucaoAll([]).

%% Conhecimento Impreciso

    % Utente -----------------------------------------------------------------------

        %% Exemplo de predicado que adiciona várias exceções de utentes
        evolucaoUtentesImprecisos(Id,impreciso([X|T]),I,M):- evolucaoUtentesImprecisos(Id,X,I,M),evolucaoUtentesImprecisos(Id,impreciso(T),I,M).

        evolucaoUtentesImprecisos(Id,impreciso([]),I,M).

        evolucaoUtentesImprecisos(Id,N,impreciso([X|T]),M):- evolucaoUtentesImprecisos(Id,N,X,M),evolucaoUtentesImprecisos(Id,N,impreciso(T),M).

        evolucaoUtentesImprecisos(Id,N,impreciso([]),M).

        evolucaoUtentesImprecisos(Id,N,I,impreciso([X|T])):- evolucaoUtentesImprecisos(Id,N,I,X),evolucaoUtentesImprecisos(Id,N,I,impreciso(T)).

        evolucaoUtentesImprecisos(Id,N,I,impreciso([])).
        
        evolucaoUtentesImprecisos(Id,N,I,M):- evolucaoExcecao((Id,N,I,M)).

        remocaoUtentesImprecisos(Id):- findall(excecao(utentes(Id,N,I,M)),excecao(utentes(Id,N,I,M)),S), involucaoAll(S).


    % Prestador -----------------------------------------------------------------------

        %% Exemplo de predicado que adiciona várias exceções de prestadores
        evolucaoPrestadoresImprecisos(Id,impreciso([X|T]),E,I):- evolucaoPrestadoresImprecisos(Id,X,E,I),evolucaoPrestadoresImprecisos(Id,impreciso(T),E,I).

        evolucaoPrestadoresImprecisos(Id,impreciso([]),E,I).

        evolucaoPrestadoresImprecisos(Id,N,impreciso([X|T]),I):- evolucaoPrestadoresImprecisos(Id,N,X,I),evolucaoPrestadoresImprecisos(Id,N,impreciso(T),I).

        evolucaoPrestadoresImprecisos(Id,N,impreciso([]),M).

        evolucaoPrestadoresImprecisos(Id,N,E,impreciso([X|T])):- evolucaoPrestadoresImprecisos(Id,N,E,X),evolucaoPrestadoresImprecisos(Id,N,E,impreciso(T)).

        evolucaoPrestadoresImprecisos(Id,N,E,impreciso([])).

        evolucaoPrestadoresImprecisos(Id,N,E,I):- evolucaoExcecao(prestador(Id,N,E,I)).


    % Cuidado -----------------------------------------------------------------------

        evolucaoCuidadoImprecisos(Dia,Mes,Ano,impreciso([X|T]),IdPrest,Descricao,Custo):- 
            evolucaoCuidadoImprecisos(Dia,Mes,Ano,X,IdPrest,Descricao,Custo),
            evolucaoCuidadoImprecisos(Dia,Mes,Ano,impreciso(T),IdPrest,Descricao,Custo).

        evolucaoCuidadoImprecisos(Dia,Mes,Ano,impreciso([]),IdPrest,Descricao,Custo).

        evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,impreciso([X|T]),Descricao,Custo):-
            evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,X,Descricao,Custo),
            evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,impreciso(T),Descricao,Custo).

        evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,impreciso([]),Descricao,Custo).

        evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,IdPrest,impreciso([X|T]),Custo):-
            evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,IdPrest,X,Custo),
            evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,IdPrest,impreciso(T),Custo).

        evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,IdPrest,impreciso([]),Custo).

        evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,IdPrest,Descricao,impreciso([X|T])):-
            evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,IdPrest,Descricao,X),
            evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,IdPrest,Descricao,impreciso(T)).

        evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,IdPrest,Descricao,impreciso([])).

        evolucaoCuidadoImprecisos(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo):- evolucaoExcecao(cuidado(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo)).


%% Conhecimento Incerto
    evolucaoUtente(Id,Nome,Idade,Morada):-
        seNomeIncertoRemove(Nome),
        seIdadeIncertoRemove(Idade),
        seMoradaIncertaRemove(Morada),
        removeDesconhecido(Id,Nome,Idade,Morada),
        evolucao(Utente).
        
    involucaoUtente(Id,Nome,Idade,Morada):- 
        seNomeIncertoRemove(Nome),
        seIdadeIncertoRemove(Idade),
        seMoradaIncertaRemove(Morada),
        involucao(Utente).


%%--------------------------------------------------------------------------------------------------------------
%% Desenvolver um sistema de inferência capaz de implementar os mecanismos de raciocínio inerentes a estes sistemas
%%--------------------------------------------------------------------------------------------------------------

    nao(T):- T,!,fail.
    nao(T).

    si(T,verdadeiro):- T.
    si(T,falso):- -T.
    si(T,desconhecido):- nao(T),nao(-T).

    siConj([],verdadeiro).
    siConj([X|T],verdadeiro):- siConj(T,verdadeiro), X.
    siConj([X|T],desconhecido):- siConj(T,desconhecido), X.
    siConj([X|T],desconhecido):- siConj(T,verdadeiro), nao(X), nao(-X).
    siConj([X|T],falso):- siConj(T,falso), X.
    siConj([X|T],falso):- siConj(T,falso), nao(X), nao(-X).
    siConj([X|T],falso):- siConj(T,desconhecido),-X.
    siConj([X|T],falso):- siConj(T,verdadeiro),-X.

    siDisj([],falso).
    siDisj([X|T],falso):- siDisj(T,falso), -X.
    siDisj([X|T],desconhecido):- siDisj(T,desconhecido), -X.
    siDisj([X|T],desconhecido):- siDisj(T,falso), nao(X), nao(-X).
    siDisj([X|T],verdadeiro):- siDisj(T,verdadeiro), -X.
    siDisj([X|T],verdadeiro):- siDisj(T,verdadeiro), nao(X), nao(-X).
    siDisj([X|T],verdadeiro):- siDisj(T,desconhecido), X.
    siDisj([X|T],verdadeiro):- siDisj(T,falso), X.