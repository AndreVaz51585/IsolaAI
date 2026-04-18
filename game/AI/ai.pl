:- module(ai, [play_ai/2]).
:- use_module('../../common/logic').
:- use_module('../../common/board').
:- use_module('../human/play', [human_turn/3]).

% The alpha-beta algorithm with Depth Limit

alphabeta( Pos, Alpha, Beta, GoodPos, Val, Level, MaxLevel) :-
	Level < MaxLevel,
	moves( Pos, PosList), !,
	NextLevel is Level + 1,
	boundedbest( PosList, Alpha, Beta, GoodPos, Val, NextLevel, MaxLevel)
	; % Or
	staticval( Pos, Val).       % Static value of Pos
	

boundedbest( [Pos | PosList], Alpha, Beta, GoodPos, GoodVal, Level, MaxLevel) :-
	alphabeta( Pos, Alpha, Beta, _, Val, Level, MaxLevel),
	goodenough( PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal, Level, MaxLevel).


goodenough( [], _, _, Pos, Val, Pos, Val, _, _) :- !.   % No other candidate


goodenough( _, Alpha, Beta, Pos, Val, Pos, Val, _, _) :-
	min_to_move( Pos), Val > Beta, !   % Maximizer attained upper bound
	; % Or
	max_to_move( Pos), Val < Alpha, !. % Minimizer attained lower bound


goodenough( PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal, Level, MaxLevel) :-
	newbounds( Alpha, Beta, Pos, Val, NewAlpha, NewBeta),     % Refine bounds
	boundedbest( PosList, NewAlpha, NewBeta, Pos1, Val1, Level, MaxLevel),
	betterof( Pos, Val, Pos1, Val1, GoodPos, GoodVal).


newbounds( Alpha, Beta, Pos, Val, Val, Beta) :-
	min_to_move( Pos), Val > Alpha, !.         % Maximizer increased lower bound



newbounds( Alpha, Beta, Pos, Val, Alpha, Val) :-
	max_to_move( Pos), Val < Beta, !.          % Minimizer decreased upper bound
	
	
	
newbounds( Alpha, Beta, _, _, Alpha, Beta). % Otherwise bounds unchanged


betterof( Pos, Val, Pos1, Val1, Pos, Val) :-   % Pos better than Pos1
	min_to_move( Pos), Val > Val1, !
	; % Or
	max_to_move( Pos), Val < Val1, !.


betterof( _, _, Pos1, Val1, Pos1, Val1). % Otherwise Pos1 better



% AI -> MAX -> 'o'
% Human -> MIN -> 'x'

max_to_move(pos(_, o, _)).
min_to_move(pos(_, x, _)).

moves(pos(Board, Player, _), PosList) :-
    findall(
        pos(NewBoard, NextPlayer, [MRow, MCol, RRow, RCol]),
        (
            valid_move(MRow, MCol, Player, Board),             
            apply_move(MRow, MCol, Player, Board, AfterMove),  
            valid_remove(RRow, RCol, AfterMove),               
            apply_remove(RRow, RCol, AfterMove, NewBoard),     
            opponent(Player, NextPlayer)                       
        ),
        PosList
    ),
    PosList \= [].

% Função heurística (avaliação estática)
staticval(pos(Board, Player, _), Val) :-
    % Usamos a diferença de mobilidade: Movimentos_do_MAX - Movimentos_do_MIN
    % MAX = 'o' , MIN = 'x'
    findall([R, C], valid_move(R, C, o, Board), MaxMoves),
    length(MaxMoves, MaxScore),
    findall([R, C], valid_move(R, C, x, Board), MinMoves),
    length(MinMoves, MinScore),
    
    (
        has_moves(Player, Board) ->
            Val is MaxScore - MinScore
        ;
            % Se não houver movimentos para o jogador atual, avalia quem ganha
            (Player == o -> Val = -100 ; Val = 100) % AI (o) perdeu -> -100 | AI (o) ganhou -> 100
    ).


% Human turn
play_ai(Board, Player)  :-
    Player == x, !,
    write('--- Player (x) turn ---'), nl,
    human_turn(Board, Player, BoardAfterRemove),
    !, % Impede que escolhas passadas do menu/humano sejam invocadas após turnos de interregno
    opponent(Player, NextPlayer),
    ( \+ has_moves(NextPlayer, BoardAfterRemove) ->
        printTable(BoardAfterRemove),
        write('Congratulion! You won!'), nl
    ;   
        printTable(BoardAfterRemove),
        play_ai(BoardAfterRemove, NextPlayer)
    ).



% AI turn
play_ai(Board, Player)  :-
    Player == o, !,
    write('--- AI (o) turn ---'), nl,
    
    InitialPos = pos(Board, o, []),
    MaxLevel = 2, 
    
    ( alphabeta(InitialPos, -9999, 9999, pos(_, _, BestMoveInfo), Value, 0, MaxLevel) ->
        true
    ;
        write('Congratulion! You won!'), nl,
        !, fail
    ),
    !, 
    
    BestMoveInfo = [MRow, MCol, RRow, RCol],
    write('AI moved to: '), write([MRow, MCol]), nl,
    write('AI removed at: '), write([RRow, RCol]), nl,
    write('Confidence (Value): '), write(Value), nl, nl,
    
    apply_move(MRow, MCol, o, Board, BoardAfterMove),
    apply_remove(RRow, RCol, BoardAfterMove, BoardAfterRemove),
    
    opponent(Player, NextPlayer),
    ( \+ has_moves(NextPlayer, BoardAfterRemove) ->
        printTable(BoardAfterRemove),
        write('The AI has beaten you! Better luck next time...'), nl
    ;
        printTable(BoardAfterRemove),
        play_ai(BoardAfterRemove, NextPlayer)   
    ).