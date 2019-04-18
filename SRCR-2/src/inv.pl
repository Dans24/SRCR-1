:- op( 900,xfy,'::' ).

evolucao(T) :- findall(Invariante, +T :: Invariante, Lista),
               insercao(T),
               teste(Lista).

involucao(T) :- findall(Invariante, -T :: Invariante, Lista),
              remocao(T),
              teste(Lista).

insercao(T) :- assert(T).
insercao(T) :- retract(T),!,fail.

teste([]).
teste([I|T]) :- I,teste(T).

remocao(T) :- retract(T).
remocao(T) :- assert(T), !, fail.

comprimento([], 0).
comprimento([_|T], R) :- comprimento(T, R1), R is R1 + 1.