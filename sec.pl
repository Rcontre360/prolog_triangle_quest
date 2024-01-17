
triangleLevel([1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5]).
isEmpty([false,true,false,false,false,false,false,false,false,false,false,false,false,false,false]).

% Predicate to check the difference between two numbers levels
isLevelDifference(Cur, Nxt, Diff) :-
    triangleLevel(Levels),  
    nth1(Cur, Levels, LevelCur),  
    nth1(Nxt, Levels, LevelNxt),  
    (
        LevelCur >= LevelNxt, 
        CurDiff is LevelCur - LevelNxt,
        Diff = CurDiff
        ;
        LevelCur < LevelNxt, 
        CurDiff is LevelNxt - LevelCur,
        Diff = CurDiff
    ).

% Predicate to check if a move from Cur to Nxt is valid
isValidMove(Cur, Nxt,Puzzle) :- 
    isIntermediate(Cur,Nxt,Inter),

    nth1(Cur, Puzzle, false),
    nth1(Nxt, Puzzle, true),
    nth1(Inter, Puzzle, false), %check if intermediate is full

    triangleLevel(Levels),  
    nth1(Cur, Levels, LevelCur),  
    isLevelDifference(Cur, Nxt, LevelDiff),  
(
    (Nxt =:= Cur - 2*LevelCur + 1, LevelDiff = 2);  %arriba a la izq
    (Nxt =:= Cur - 2*LevelCur + 3, LevelDiff = 2); %arriba a la derecha
    (Nxt =:= Cur - 2, LevelDiff = 0); % izquierda
    (Nxt =:= Cur + 2, LevelDiff = 0); % derecha
    (Nxt =:= Cur + 2*LevelCur + 1, LevelDiff = 2); % abajo a la izquierda
    (Nxt =:= Cur + 2*LevelCur + 3, LevelDiff = 2) % abajo a la derecha
).

isIntermediate(Cur, Nxt, Inter) :- 
    triangleLevel(Levels),  
    nth1(Cur, Levels, LevelCur),  
    isLevelDifference(Cur, Nxt, LevelDiff),  
(
    (Nxt =:= Cur - 2*LevelCur + 1, LevelDiff = 2, Calc is Cur - LevelCur, Inter = Calc);  %arriba a la izq
    (Nxt =:= Cur - 2*LevelCur + 3, LevelDiff = 2, Calc is Cur - LevelCur + 1, Inter = Calc); %arriba a la derecha
    (Nxt =:= Cur - 2, LevelDiff = 0, Calc is Cur - 1, Inter = Calc); % izquierda
    (Nxt =:= Cur + 2, LevelDiff = 0, Calc is Cur + 1, Inter = Calc); % derecha
    (Nxt =:= Cur + 2*LevelCur + 1, LevelDiff = 2, Calc is Cur + LevelCur, Inter = Calc); % abajo a la izquierda
    (Nxt =:= Cur + 2*LevelCur + 3, LevelDiff = 2, Calc is Cur + LevelCur + 1, Inter = Calc) % abajo a la derecha
).

modifyAtIndex([], _, _, []).
modifyAtIndex([_|Rest], 1, Value, [Value|Rest]).
modifyAtIndex([X|Rest], Index, Value, [X|ResTail]) :-
    Index > 1,
    NewIndex is Index - 1,
    modifyAtIndex(Rest, NewIndex, Value, ResTail).


isValidTransition(Puzzle, NxtPuzzle,From,To) :-
    isValidMove(From,To,Puzzle),
    isIntermediate(From,To,Inter),

    modifyAtIndex(Puzzle, From, true, FirstChange),
    modifyAtIndex(FirstChange, To, false, SecondChange),
    modifyAtIndex(SecondChange, Inter, true, NxtPuzzle).

makeAllMoves(_, [], []).
makeAllMoves(Puzzle, [(From,To)|Others], [NxtRes | Final]) :-
    isValidTransition(Puzzle, NxtRes, From,To),
    makeAllMoves(NxtRes,Others,Final).

main(Final) :- 
    isEmpty(Puzzle),
    length(AllMoves, 13),
    makeAllMoves(Puzzle, AllMoves, Final),
    printList(Final).







