% Define the triangle levels
triangleLevel([1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5]).
isEmpty([false,false,false,false,true,false,false,false,false,false,false,false,false,false,false]).

modifyAtIndex([], _, _, []).
modifyAtIndex([_|Rest], 1, Value, [Value|Rest]).
modifyAtIndex([X|Rest], Index, Value, [X|ResTail]) :-
    Index > 1,
    NewIndex is Index - 1,
    modifyAtIndex(Rest, NewIndex, Value, ResTail).

modifyPuzzle(Index, Value, X):-
    triangleLevel(Levels),  
    modifyAtIndex(Levels,Index,Value, X).

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
isValidMove(Cur, Nxt) :- 
    %isEmpty(IsEmpty),  
    %nth1(Cur, IsEmpty, false),
    %nth1(Nxt, IsEmpty, true),

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

% Predicate to find all valid moves
allValidMoves(Cur, ValidMoves) :-
    findall(Nxt, isValidMove(Cur, Nxt), ValidMoves).

% Predicate to check if the puzzle is solved
isSolved([], IsOneFilled) :- IsOneFilled.
isSolved([Cur | Rest],IsOneFilled) :-
    (
        Cur = false, isSolved(Rest,IsOneFilled)
    )
    ;
    (
        Cur = true, IsOneFilled = false, isSolved(Rest,true)
    ).

move(From,To, Puzzle, NxtPuzzle) :-
    isValidMove(From,To),
    isIntermediate(From,To,Inter),
    modifyAtIndex(Puzzle, From, true, FirstChange),
    modifyAtIndex(FirstChange, To, false, SecondChange),
    modifyAtIndex(SecondChange, Inter, true, NxtPuzzle).
    
canBeSolved([],_):- false.
canBeSolved([CurPos, NxtPos], Puzzle) :-
    allValidMoves(CurPos, ValidMoves),
    modifyAtIndex(Puzzle, CurPos, true, NxtPuzzle),
    (
        canBeSolved(ValidMoves,NxtPuzzle)
        ;
        canBeSolved(NxtPos, NxtPuzzle)
    ).

main(From,To,X) :-
    isEmpty(Puzzle),
    move(From,To,Puzzle,X).


