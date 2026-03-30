
:- module(io, [
    read_turn/4,
    printWinningMessage/1,
    switchTurnPlayer/1,
    printTurnMessage/1
]).

% Função para ler as coordenadas do usuário, exibindo uma mensagem
read_coords(Message, X, Y) :-
    write(Message),
    write(' (linha/coluna, ex: 1/2): '),
    read(X/Y).

% Função generica para ler as coordenadas de movimento e remoção do utilizador
read_turn(XMove,YMove,XRemove,YRemove) :-
    read_coords('Move', XMove, YMove),
    read_coords('Remove uma casa', XRemove, YRemove).


printWinningMessage(Winner) :-
    write('JOGADOR '), write(Winner), write(' Venceu!'), nl.

printTurnMessage(Player) :-
    write('--------------------'), nl,
    write('Turno do Jogador: '), write(Player), nl.

switchTurnPlayer(NextPlayer) :-
     write('--- VEZ DO JOGADOR '), write(NextPlayer), write(' ---'), nl.