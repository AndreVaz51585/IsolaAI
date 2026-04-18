:- module(logic, [
	opponent/2,
    find_player/4,
    inside_board/2,
    cell/4,
    adjacent/4,
    valid_move/4,
    apply_move/5,
    has_moves/2,
    valid_remove/3,
    apply_remove/4
]).

:- use_module(board).

% retorna o oponente do jogador atual
opponent(x, o).
opponent(o, x).

%Procura onde esta o player no board e retorna as coordenadas do player
find_player(Player, Board, Col, Row ) :-	    
	nth0(Row,Board,Line),
	nth0(Col,Line,Player).


%Verifica se as coordenadas estao dentro do board, se são validas
inside_board(Row,Col) :-				
	between(0,5,Row),
	between(0,5,Col).

%Retorna em value o valor que consta naquela cell
cell(Row, Col, Board, Value) :-					
	inside_board(Row,Col),
	nth0(Row,Board,Line),
	nth0(Col,Line,Value).

%Verificar todas posições adjacentes de uma coordenada
adjacent(XRow, XCol, Row, Col) :-		
	between(0,5,Row),
	between(0,5,Col),	
    abs(XRow - Row) =< 1,
    abs(XCol - Col) =< 1,
    (XRow \= Row; XCol \= Col). % garante que as coordenadas não são as mesmas do jogador atual


%Valida o Move que o jogador que efetuar
valid_move(Row, Col, Player, Board) :-					
	find_player(Player, Board, PCol, PRow),				%Retorna a posição do jogador
	adjacent(PRow, PCol, Row, Col),
	cell(Row, Col, Board, '.').							%Verifica se a coordenada esta vazia, ou seja, se tem um '.'


% Função responsável por aplicar um movimento, substituindo a célula na posição especificada pelo jogador atual e retornando a nova tabela
apply_move(Row, Col, Player, Board, NewBoard) :-
	valid_move(Row, Col, Player, Board), % Primeiro valida o movimento
	find_player(Player, Board, PCol, PRow), % Encontra a posição atual do jogador
	replaceTable(PRow, PCol, Board, '.', TempBoard), % Remove o jogador
	replaceTable(Row, Col, TempBoard, Player, NewBoard). % Substitui a célula na posição especificada pelo jogador atual
	

%Função que verifica vitoria, se der false é porque perdeu
has_moves(Player, Board) :-     			
    findall([R, C], valid_move(R, C, Player, Board), Moves),
    Moves \= [].
	
% Função que valida a remoção de uma peça, verificando se a célula está vazia
valid_remove(Row,Col,Board) :-
	cell(Row, Col, Board, '.'). % Verifica se a célula está vazia (representada por '.')	


% Função que aplica a remoção de uma peça, substituindo a célula na posição especificada por '#' e retornando a nova tabela
apply_remove(Row, Col, Board, NewBoard) :-
	valid_remove(Row, Col, Board), % Primeiro valida a remoção
	replaceTable(Row, Col, Board, '#', NewBoard). % Substitui a célula na posição especificada por '#' e retorna a nova tabela

	
	






    