registarUtente(IdUt, Nome, Idade, Cidade) :- assert(utente(IdUt, Nome, Idade, Cidade)).
registarServico(IdServico, Descricao, Instituicao, Cidade) :- assert(servico(IdServico, Descricao, Instituicao, Cidade)).
registarConsulta(Data, IdUt, IdServico, Custo) :- assert(consulta(Data, IdUt, IdServico, Custo)).

removerUtente(IdUt) :- retract(utente(IdUt, _, _, _)).
removerServico(IdServico) :- retract(servico(IdServico, _, _, _)).
removerConsulta(IdUt, IdServico) :- retract(consulta(_, IdUt, IdServico, _)).

uniq([], []).
uniq([H|T], [H|R]) :- \+(pertence(H,T)), uniq(T, R)
instituicoesPrestadorasDeServico([X|T]) :- servico(_, _, X, _), instituicoesPrestadorasDeServico(T).