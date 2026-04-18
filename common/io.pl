
:- module(io, [
    read_turn/4,
    printWinningMessage/1,
    switchTurnPlayer/1,
    printTurnMessage/1
]).

% Função para ler as coordenadas do usuário, exibindo uma mensagem
read_coords(Message, X, Y) :-
    write(Message),
    write(' (line/col, ex: 1/2): '),
    read(X/Y).

% Função generica para ler as coordenadas de movimento e remoção do utilizador
read_turn(XMove,YMove,XRemove,YRemove) :-
    read_coords('Move', XMove, YMove),
    read_coords('Remove a spot', XRemove, YRemove).


printWinningMessage(Winner) :-
    write('PLAYER '), write(Winner), write(' WINS!'), nl.

printTurnMessage(Player) :-
    write('--------------------'), nl,
    write('PLAYER '), write(Player), write('\'s TURN'), nl.

    
switchTurnPlayer(NextPlayer) :-
     write('--- PLAYER '), write(NextPlayer), write('\'s TURN ---'), nl.