:- use_module('../../common/logic').
:- use_module('../../common/board').

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


% ==========================================
% FUNÇÕES DO JOGO (Isola)
% ==========================================

% Representamos a posição como: pos(Board, JogadorAtual, MovimentoQueOriginou)
% Assumimos que o AI é o 'o' (MAX) e o Humano é o 'x' (MIN)
max_to_move(pos(_, o, _)).
min_to_move(pos(_, x, _)).

% Gerador de jogadas
moves(pos(Board, Player, _), PosList) :-
    findall(
        pos(NewBoard, NextPlayer, [MRow, MCol, RRow, RCol]),
        (
            valid_move(MRow, MCol, Player, Board),             % Move válido
            apply_move(MRow, MCol, Player, Board, AfterMove),  % Aplica movimento
            valid_remove(RRow, RCol, AfterMove),               % Remove válida
            apply_remove(RRow, RCol, AfterMove, NewBoard),     % Aplica remoção
            opponent(Player, NextPlayer)                       % Alterna o turno
        ),
        PosList
    ).

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


% ==========================================
% INTERFACE / LOOP DA IA 
% ==========================================

play_ai(Board, Player)  :-
    % Turno do humano (Player 'x')
    Player == x, !,
    write('--- TEU TURNO (x) ---'), nl,
    read_turn(XMove, YMove, XRemove, YRemove),
    ( \+ valid_move(XMove, YMove, Player, Board) ->
        write('Movimento falso. Tente novamente.'), nl,  
        play_ai(Board, Player)
    ;
        apply_move(XMove, YMove, Player, Board, BoardAfterMove),
        ( \+ valid_remove(XRemove, YRemove, BoardAfterMove) ->
            write('Remoção falsa. Tente novamente.'), nl,  
            play_ai(Board, Player)
        ;
            apply_remove(XRemove, YRemove, BoardAfterMove, BoardAfterRemove),
            opponent(Player, NextPlayer),
            ( \+ has_moves(NextPlayer, BoardAfterRemove) ->
                printTable(BoardAfterRemove),
                write('PARABÉNS! GANHASTE AO BOT!'), nl
            ;
                printTable(BoardAfterRemove),
                play_ai(BoardAfterRemove, NextPlayer)   
            )
        )
    ).

play_ai(Board, Player)  :-
    % Turno da IA (Player 'o')
    Player == o, !,
    write('--- TURNO DA IA (o) a pensar... ---'), nl,
    
    % Inicializa o estado. Level = 0, MaxLevel = 2 (podes alterar para 3 caso queiras que veja mais à frente)
    InitialPos = pos(Board, o, []),
    MaxLevel = 3,
    
    alphabeta(InitialPos, -9999, 9999, pos(_, _, BestMoveInfo), Value, 0, MaxLevel),
    
    BestMoveInfo = [MRow, MCol, RRow, RCol],
    write('IA moveu para: '), write([MRow, MCol]), nl,
    write('IA removeu em: '), write([RRow, RCol]), nl,
    write('Confiança (Value): '), write(Value), nl, nl,
    
    apply_move(MRow, MCol, o, Board, BoardAfterMove),
    apply_remove(RRow, RCol, BoardAfterMove, BoardAfterRemove),
    
    opponent(Player, NextPlayer),
    ( \+ has_moves(NextPlayer, BoardAfterRemove) ->
        printTable(BoardAfterRemove),
        write('O BOT GANHOU-TE! MAIS SORTE PARA A PRÓXIMA...'), nl
    ;
        printTable(BoardAfterRemove),
        play_ai(BoardAfterRemove, NextPlayer)   
    ).