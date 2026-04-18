:- use_module('../../common/board').
:- use_module('../human/play').
:- use_module('../AI/ai').


% Ponto de entrada p/ um jogo 1v1
start_game :-
    createTable(EmptyBoard),

    replaceTable(0, 0, EmptyBoard, x, Board1),
    replaceTable(5, 5, Board1, o, InitialBoard),
    
    write('--- WELCOME TO ISOLA ---'), nl,
    printTable(InitialBoard),
    read_game_mode(InitialBoard, x).


read_game_mode(Board,Player) :-
    write('Do you want to play against the AI? (y/n):'), nl,
    read(Answer),
    ( Answer == y ->
        play_ai(Board, Player)
    ; Answer == n ->
        play(Board, Player)
    ;   
        write('Invalid answer. Please respond with y. or n.'), nl,
        read_game_mode(Board, Player)
    ).