:- use_module('../../common/board').
:- use_module('../../common/logic').
:- use_module('../../common/io').

% Ponto de entrada p/ um jogo 1v1
start_game :-
    createTable(EmptyBoard),

    replaceTable(0, 0, EmptyBoard, x, Board1),
    replaceTable(5, 5, Board1, o, InitialBoard),
    
    write('--- BEM VINDO AO ISOLA ---'), nl,
    printTable(InitialBoard),
    
    play(InitialBoard, x).


% Ciclo principal do jogo play(Board Atual, Jogador Atual)

play(Board, Player) :-
    read_turn(XMove, YMove, XRemove, YRemove),

   ( \+ valid_move(XMove, YMove, Player, Board) ->
        write('Movimento inválido. Tente novamente.'), nl,  
        play(Board, Player)
    ;
        apply_move(XMove, YMove, Player, Board, BoardAfterMove),
        
        ( \+ valid_remove(XRemove, YRemove, BoardAfterMove) ->
            write('Remoção inválida. Tente novamente.'), nl,  
            play(Board, Player)
        ;
            apply_remove(XRemove, YRemove, BoardAfterMove, BoardAfterRemove),
            opponent(Player, NextPlayer),

            ( \+ has_moves(NextPlayer, BoardAfterRemove) ->
                printTable(BoardAfterRemove),
                printWinningMessage(Player)
            ;
                printTable(BoardAfterRemove),
                switchTurnPlayer(NextPlayer),
                play(BoardAfterRemove, NextPlayer)   
            )
        )
   ).
