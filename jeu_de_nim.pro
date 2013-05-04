% Piles initiales
piles([1,3,5,7]).

% Début
start(Gagnant, jvj) :- piles(Piles), play(j1, Piles, Gagnant).
start(Gagnant, jvo) :- piles(Piles), play(j, Piles, Gagnant).
start(Gagnant, ovj) :- piles(Piles), play(o, Piles, Gagnant).

% Conditions de victoire jvj.
play(j2, [0,0,0,0], j1).
play(j1, [0,0,0,0], j2).
% Conditions de victoire jvo.
play(j, [0,0,0,0], o).
play(o, [0,0,0,0], j).

% Jouer un coup
play(o, Piles, Gagnant) :- 
  display_game(Piles), display_player(o), best_move(Piles, NoPile, NoAlu),
  change(Piles, NewPiles, NoPile, NoAlu), display_move(NoPile, NoAlu), play(j, NewPiles, Gagnant),!.
play(Joueur, Piles, Gagnant) :- 
  display_game(Piles), display_player(Joueur), next(Joueur, Next),
  change(Piles, NewPiles), play(Next, NewPiles, Gagnant),!.

% Suivant jvj
next(j1, j2).
next(j2, j1).
% Suivant jvo
next(j, o).

get_input(Piles, NoPile, NoAlu) :- 
    write('Quelle pile ?'), nl, read_number(NoPile),
    write('Quel nombre ?'), nl, read_number(NoAlu),
    RealPile is (NoPile mod 4),
    possible(Piles, RealPile, NoAlu),!;get_input(Piles, NoPile, NoAlu).

change(Piles, NewPiles) :- 
  get_input(Piles, NoPile, NoAlu),
  change(Piles, NewPiles, NoPile, NoAlu),!.

change([A,B,C,D], NewPiles, 0, NoAlu) :- NewA is A-NoAlu, FixedA is max(0, NewA), append([FixedA, B, C, D], [], NewPiles),!.
change([A,B,C,D], NewPiles, 1, NoAlu) :- NewB is B-NoAlu, FixedB is max(0, NewB), append([A, FixedB, C, D], [], NewPiles),!.
change([A,B,C,D], NewPiles, 2, NoAlu) :- NewC is C-NoAlu, FixedC is max(0, NewC), append([A, B, FixedC, D], [], NewPiles),!.
change([A,B,C,D], NewPiles, 3, NoAlu) :- NewD is D-NoAlu, FixedD is max(0, NewD), append([A, B, C, FixedD], [], NewPiles),!.

% Afichage
display_game([A,B,C,D]) :- 
  write('Tas 0 => '), display_game(A), nl,
  write('Tas 1 => '), display_game(B), nl,
  write('Tas 2 => '), display_game(C), nl,
  write('Tas 3 => '), display_game(D), nl,!.

display_game(0).
display_game(X) :- X > 0, write('|'), X1 is dec(X), display_game(X1),!.

display_player(j1) :- write('Tour du joueur 1'), nl.
display_player(j2) :- write('Tour du joueur 2'), nl.
display_player(j) :- write('Tour du joueur'), nl.
display_player(o) :- write('Tour de l''ordinateur'), nl.

display_move(NoPile, NoAlu) :- 
  write('L''ordinateur a retire  '), write(NoAlu),
  write(' alumettes du tas '), write(NoPile), write('.'), nl,!.

% Possibilities
possible([A,_,_,_], 0, NoAlu) :- A >= NoAlu, NoAlu > 0,!.
possible([_,B,_,_], 1, NoAlu) :- B >= NoAlu, NoAlu > 0,!.
possible([_,_,C,_], 2, NoAlu) :- C >= NoAlu, NoAlu > 0,!.
possible([_,_,_,D], 3, NoAlu) :- D >= NoAlu, NoAlu > 0,!.


% Détection d'une position favorable
good_position([A,B,C,D]) :- X is xor(xor(xor(A, B), C), D), X = 0.

% Meilleur coup possible
best_move(Piles, NoPile, NoAlu) :- best_move(Piles, NoPile, NoAlu, 0, 1).

best_move(Piles, NoPile, NoAlu, 0, 8) :- any_move(Piles, NoPile, NoAlu, 0, 1),!.

best_move(Piles, NoPile, NoAlu, TryPile, TryAlu) :-
  possible(Piles, TryPile, TryAlu), change(Piles, NewPiles, TryPile, TryAlu),
  good_position(NewPiles), NoPile is TryPile, NoAlu is TryAlu,!;
  NewPile is inc(TryPile) mod 4, NewAlu is (TryAlu + truncate(inc(TryPile) / 4)),
  best_move(Piles, NoPile, NoAlu, NewPile, NewAlu),!.

any_move(Piles, NoPile, NoAlu, TryPile, TryAlu) :- 
  possible(Piles, TryPile, TryAlu), NoPile is TryPile, NoAlu is TryAlu,!;
  NewPile is inc(TryPile) mod 4, NewAlu is (TryAlu + truncate(inc(TryPile) / 4)),
  any_move(Piles, NoPile, NoAlu, NewPile, NewAlu),!.


