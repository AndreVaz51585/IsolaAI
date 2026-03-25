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

printTable(Table) :-
    write('  0 1 2'), nl,
    print_rows(Table, 0).

print_rows([], _).
print_rows([Row | Tail], RowIdx) :-
    write(RowIdx), write(' '),
    printList(Row),
    NextRowIdx is RowIdx + 1,
    print_rows(Tail, NextRowIdx).
