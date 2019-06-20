    % Utente -----------------------------------------------------------------------
        
        %% Evolucao
        evolucao_utente_nome_incerto(Id,Idade,Morada):-
            insercao((excecao(utente(Id,Nome,Idade,Morada)):-utente(Id,incerto,Idade,Morada))),
            evolucao(utente(Id,incerto,Idade,Morada)).

        evolucao_utente_idade_incerto(Id,Nome,Morada):-
            insercao((excecao(utente(Id,Nome,Idade,Morada)):-utente(Id,Nome,incerto,Morada))),
            evolucao(utente(Id,Nome,incerto,Morada)).

        evolucao_utente_morada_incerto(Id,Nome,Idade):-
            insercao((excecao(utente(Id,Nome,Idade,Morada)):-utente(Id,Nome,Idade,incerto))),
            evolucao(utente(Id,Nome,Idade,incerto)).

        %% Involucao
        involucao_utente_nome_incerto(Id,Idade,Morada):-
            remocao((excecao(utente(Id,Nome,Idade,Morada)):-utente(Id,incerto,Idade,Morada))),
            involucao(utente(Id,incerto,Idade,Morada)).

        involucao_utente_idade_incerto(Id,Nome,Morada):-
            remocao((excecao(utente(Id,Nome,Idade,Morada)):-utente(Id,Nome,incerto,Morada))),
            involucao(utente(Id,Nome,incerto,Morada)).

        involucao_utente_morada_incerto(Id,Nome,Idade):-
            remocao((excecao(utente(Id,Nome,Idade,Morada)):-utente(Id,Nome,Idade,incerto))),
            involucao(utente(Id,Nome,Idade,incerto)).

%% Conhecimento Interdito

    % Utente -----------------------------------------------------------------------

        evolucao_utente_nome_interdito(Id,Idade,Morada):-
            insercao((excecao(utente(Id,Nome,Idade,Morada)):-utente(Id,interdito,Idade,Morada))),
            insercao(
                (+utente(I,Nome,A,M) :: (findall((I,Ns,A,M),(utente(Id,Ns,Idade,Morada), nao(interdito(Ns))),S ),comprimento( S,Num ), Num == 0))
            ),
            evolucao(utente(Id,interdito,Idade,Morada)).

        evolucao_utente_idade_interdito(Id,Nome,Morada):-
            insercao((excecao(utente(Id,Nome,Idade,Morada)):-utente(Id,Nome,interdito,Morada))),
            insercao(
                (+utente(I,N,Idade,M) :: (findall((I,N,Is,M),(utente(Id,Nome,Is,Morada), nao(interdito(Is))),S ),comprimento( S,Num ), Num == 0))
            ),
            evolucao(utente(Id,Nome,interdito,Morada)).

        evolucao_utente_morada_interdito(Id,Nome,Idade):-
            insercao((excecao(utente(Id,Nome,Idade,Morada)):-utente(Id,Nome,Idade,interdito))),
            insercao(
                (+utente(I,N,A,M) :: (findall((I,N,A,M),(utente(Id,Nome,Idade,Ms), nao(interdito(Ms))),S ),comprimento( S,Num ), Num == 0))
            ),
            evolucao(utente(Id,Nome,Idade,interdito)).


    % Prestador -----------------------------------------------------------------------

        %excecao(utente(2,maria,_,guimaraes)).
        %
        %utente(3,interdito,34,turim).
        %+utente(IdUt,Nome,Idade,Morada) :: (findall(
        %                        (IdUt,NS,Idade,Morada),
        %                        (utente(3,NS,34,turim), nao(interdito(NS))),
        %                        S ),
        %                    comprimento( S,N ), N == 0 
        %                  ).
        %excecao(utente(IdUt,Nome,Idade,Morada)):- utente(IdUt,interdito,Idade,Morada).

        %% prestador(idPrest,Nome,Especialidade,Instituicao)
        %evolucao_prestador_nome_incerto(Id,Nome,Morada):-
        %evolucao_prestador_especialidade_incerto(Id,Nome,Morada):-
        %evolucao_prestador_instituicao_incerto(Id,Nome,Morada):-
        %
        %evolucao_prestador_nome_interdito(Id,Nome,Morada):-
        %evolucao_prestador_especialidade_interdito(Id,Nome,Morada):-
        %evolucao_prestador_instituicao_interdito(Id,Nome,Morada):-
        %

    % Cuidado -----------------------------------------------------------------------
        %%% cuidado(Data,IdUt,IdPrest,Descricao,Custo)
        evolucao_cuidado_DataDia_impreciso(F,L,Mes,Ano,IdUt,IdPrest,Descricao,Custo):-
                    findall(Invariante, +excecao(prestador(_,Mes,Ano,IdUt,IdPrest,Descricao,Custo))::Invariante,Lista),
                    insercao((excecao(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo):- Dia>=F,Dia=<L).
                    
        evolucao_cuidado_DataMes_impreciso(Dia,F,L,Ano,IdUt,IdPrest,Descricao,Custo):- 
                    findall(Invariante, +excecao(prestador(Dia,_,Ano,IdUt,IdPrest,Descricao,Custo))::Invariante,Lista),
                    insercao((excecao(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo):- Mes>=F,Mes=<L).

        evolucao_cuidado_DataAno_impreciso(Dia,Mes,F,L,IdUt,IdPrest,Descricao,Custo):- 
                    findall(Invariante, +excecao(prestador(Dia,Mes,_,IdUt,IdPrest,Descricao,Custo))::Invariante,Lista),
                    insercao((excecao(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo):- Ano>=F,Ano=<L).
        
        evolucao_cuidado_Custo_impreciso(Dia,Mes,Ano,IdUt,IdPrest,Descricao,F,L):- 
                    findall(Invariante, +excecao(prestador(Dia,Mes,_,IdUt,IdPrest,Descricao,Custo))::Invariante,Lista),
                    insercao((excecao(Dia,Mes,Ano,IdUt,IdPrest,Descricao,Custo):- Ano>=F,Ano=<L).

        evolucaoIdadeIntervalo(Id,N,M,F,L) :- 
                    findall(Invariante, +excecao(utente(Id,N,_,M))::Invariante, Lista),
                    insercao((excecao(Id,N,I,M):- I>=F,I=<L)),
                    teste(Lista).

        %evolucao_cuidado_IdUt_impreciso(Id,Nome,Morada):-
        %evolucao_cuidado_IdPrest_impreciso(Id,Nome,Morada):-
        %evolucao_cuidado_Descricao_impreciso(Id,Nome,Morada):-
        %evolucao_cuidado_Custo_impreciso(Id,Nome,Morada):-
        %
        %evolucao_cuidado_DataDia_interdito(Id,Nome,Morada):-
        %evolucao_cuidado_DataMes_interdito(Id,Nome,Morada):-
        %evolucao_cuidado_DataAno_interdito(Id,Nome,Morada):-
        %evolucao_cuidado_IdUt_interdito(Id,Nome,Morada):-
        %evolucao_cuidado_IdPrest_interdito(Id,Nome,Morada):-
        %evolucao_cuidado_Descricao_interdito(Id,Nome,Morada):-
        %evolucao_cuidado_Custo_interdito(Id,Nome,Morada):-