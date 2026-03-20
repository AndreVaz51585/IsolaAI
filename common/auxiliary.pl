replace(Idx, List, Value, NewList) :-
	replaceAux(0, Idx, List, Value, NewList).


replaceAux(Idx, Idx, [H | Tail], Value, [Value | Tail]). % Idx =:= Idx

replaceAux(Idx1, Idx, [H | Tail], Value, [H | NewTail]) :-
	Idx1 =\= Idx, % Idx1 != Idx 
	Idx2 is Idx1 + 1,
	replaceAux(Idx2, Idx, Tail, Value, NewTail).



createTable(Table) :- 
Table = [[., ., .], 
            [., ., .],
            [., ., .]]. 



% função responsável por substituir um elemento da tabela por um valor específico, retornando a nova tabela resultante

replaceTable(Row, Col, Table, Value, NewTable) :-
	nth0(Row, Table, Line),
	replace(Col, Line, Value, NewLine),
	replace(Row, Table, NewLine, NewTable).	
	



printList([]) :- nl.
		
printList([H | T]) :-
	write(H), write(' '),
	printList(T).	



% Função responsável por imprimir a tabela, linha por linha

printTable([]).

printTable([Row | Tail]) :-
	printList(Row), 
	printTable(Tail).


% Função responsável por alternar o jogador atual

opponent(x, o).

opponent(o, x).

% encontrar a posição do jogador atual na tabela

% nth0(Index, List, Element), ou seja element está na posição Index da List


player_position(Player, Table, Row, Col) :-
    nth0(Row, Table, Line),
    nth0(Col, Line, Player).


% ajustar tendo em conta o tamanho da tabela, ou seja, o número de linhas e colunas
inside_board(Row, Col) :-
    between(0, 2, Row),
    between(0, 2, Col).

% verificar se uma célula específica da tabela contém um valor específico, garantindo que a posição está dentro dos limites do tabuleiro
cell(Table, Row, Col, Value) :-
    inside_board(Row, Col),
    nth0(Row, Table, Line),
    nth0(Col, Line, Value).

adjacent(XRow, XCol, Row, Col) :-
    abs(XRow - Row) =< 1,
    abs(XCol - Col) =< 1,
    (XRow \= Row; XCol \= Col). % garante que as coordenadas não são as mesmas do jogador atual


% função responsável por validar um determinado movimento, as coordenadas tem de ser ajdacentes, estar dentro do tabuleiro e estar vazia.
valid_move(Player,Table, Row, Col) :-
    inside_board(Row, Col), % começa por verificar se as coordenadas estão dentro dos limites do tabuleiro
    player_position(Player, Table, PlayerRow, PlayerCol), % encontra a posição do jogador atual (x) na tabela
    adjacent(PlayerRow, PlayerCol, Row, Col), % verifica se as coordenadas estão adjacentes à posição atual do jogador
    cell(Table, Row, Col, .). % verifica se a célula na posição especificada está vazia (.)   


% função responsável por aplicar um movimento válido, primeiro valida o movimento e só depois aplica o movimento,começa por limpar a posição anterior e depois substitui a célula na posição especificada pelo símbolo do jogador atual (x ou o) e retornando a nova tabela 
apply_move(Player, Table, Row, Col, NewTable) :-
    valid_move(Player, Table, Row, Col), % primeiro valida o movimento e só depois aplica o movimento
    player_position(Player, Table, PlayerRow, PlayerCol), % encontra a posição do jogador atual (x) na tabela
    replaceTable(PlayerRow, PlayerCol, Table, ., TempTable), % Antes de fazer o movimento, primeiro limpa a peça.
    replaceTable(Row, Col, TempTable, Player, NewTable). % substitui a célula na posição especificada pelo símbolo do jogador atual (x ou o) e retorna a nova tabela



valid_remove(Player, Table, Row, Col) :-
    inside_board(Row, Col), % verifica se as coordenadas estão dentro dos limites do tabuleiro
    cell(Table, Row, Col, .). % verifica se a célula já foi removida


apply_remove(Player, Table, Row, Col, NewTable) :-
    valid_remove(Player, Table, Row, Col), % primeiro valida a remoção e só depois aplica a remoção
    replaceTable(Row, Col, Table, '#', NewTable). % substitui a célula na posição especificada por '#' e retorna a nova tabela


has_moves(Player, Table, Row, Col) :-
    player_position(Player, Table, PlayerRow, PlayerCol),
    inside_board(Row, Col),
    adjacent(PlayerRow, PlayerCol, Row, Col),
    cell(Table, Row, Col, .).

read_moves(MoveCor, RemoveCords) :-
    write('Move (linha/coluna, ex: 1/2): '),
    read(MoveCor),
    write('Remove uma casa (linha/coluna): '),
    read(RemoveCords).       
