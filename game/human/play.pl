:- module(play, [play/2, human_turn/3]).
:- use_module('../../common/board').
:- use_module('../../common/logic').
:- use_module('../../common/io').

% Pede e valida o turno de um jogador humano, retornando o tabuleiro resultante
human_turn(Board, Player, BoardAfterRemove) :-
    read_turn(XMove, YMove, XRemove, YRemove),
    ( \+ valid_move(XMove, YMove, Player, Board) ->
        write('Invalid move. Try again.'), nl,  
        human_turn(Board, Player, BoardAfterRemove)
    ;
        apply_move(XMove, YMove, Player, Board, BoardAfterMove),
        ( \+ valid_remove(XRemove, YRemove, BoardAfterMove) ->
            write('Invalid removal. Try again.'), nl,  
            human_turn(Board, Player, BoardAfterRemove)
        ;
            apply_remove(XRemove, YRemove, BoardAfterMove, BoardAfterRemove)
        )
    ).

% Ciclo principal do jogo play(Board Atual, Jogador Atual)
play(Board, Player) :-
    human_turn(Board, Player, BoardAfterRemove),
    opponent(Player, NextPlayer),
    ( \+ has_moves(NextPlayer, BoardAfterRemove) ->
        printTable(BoardAfterRemove),
        printWinningMessage(Player)
    ;
        printTable(BoardAfterRemove),
        switchTurnPlayer(NextPlayer),
        play(BoardAfterRemove, NextPlayer)   
    ).
