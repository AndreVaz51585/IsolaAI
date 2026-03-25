

%Procura onde esta o player no board e retorna as coordenadas do player
find_player(Player, Board, Col, Row ) :-	    
	nth0(Row,Board,Line),
	nth0(Col,Line,Player).


%Verifica se as coordenadas estao dentro do board, se são validas
inside_board(Row,Col) :-				
	between(0,4,Row),
	between(0,4,Col).

%Retorna em value o valor que conta naquela cell
cell(Row, Col, Board, Value) :-					
	inside_board(Row,Col),
	nth0(Row,Board,Line),
	nth0(Col,Line,Value).

%Verificar as todas posições adjacentes de uma coordenada
adjacent(XRow, XCol, Row, Col) :-		
	between(0,4,Row),
	between(0,4,Col),	
    abs(XRow - Row) =< 1,
    abs(XCol - Col) =< 1,
    (XRow \= Row; XCol \= Col). % garante que as coordenadas não são as mesmas do jogador atual


%Valida o Move que o jogador que efetuar
valid_move(Row, Col, Player, Board) :-					
	find_player(Player, Board, PCol, PRow),				%Retorna a posição do jogador
	adjacent(PRow, PCol, Row, Col),
	cell(Row, Col, Board, '.').							%Verifica se a coordenada esta vazia, ou seja, se tem um '.'


%Função que verifica vitoria, se der false é porque perdeu
has_moves(Player, Board) :-     			
	valid_move(_, _, Player, Board), !.
	






    