:- use_module('../../common/board').
:- use_module('../../common/logic').
:- use_module('../../common/io').
:- consult('../../game/AI/ai.pl').


% Ponto de entrada p/ um jogo 1v1
start_game :-
    createTable(EmptyBoard),

    replaceTable(0, 0, EmptyBoard, x, Board1),
    replaceTable(5, 5, Board1, o, InitialBoard),
    
    write('--- BEM VINDO AO ISOLA ---'), nl,
    printTable(InitialBoard),
    ask_game_mode(InitialBoard, x).
    
    
    

% Pergunta ao jogador o modo de jogo
ask_game_mode(Board, Player) :-
    write('Deseja jogar contra a IA? (s/n): '),
    read(Choice),
    ( Choice == s ->
        play_ai(Board, Player) 
    ; Choice == n ->
        play(Board, Player)
    ;
        write('Opção inválida. Por favor escolhe s ou n.'), nl,
        ask_game_mode(Board, Player)
    ).

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
