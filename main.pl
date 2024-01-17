% Define the triangle levels
triangleLevel([1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5]).
isEmpty([false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]).

% Predicate to check the difference between two numbers levels
levelDifference(Cur, Nxt, Diff) :-
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
    levelDifference(Cur, Nxt, LevelDiff),  
(
    (Nxt =:= Cur - 2*LevelCur + 1, LevelDiff = 2);  %arriba a la izq
    (Nxt =:= Cur - 2*LevelCur + 3, LevelDiff = 2); %arriba a la derecha
    (Nxt =:= Cur - 2, LevelDiff = 0); % izquierda
    (Nxt =:= Cur + 2, LevelDiff = 0); % derecha
    (Nxt =:= Cur + 2*LevelCur + 1, LevelDiff = 2); % abajo a la izquierda
    (Nxt =:= Cur + 2*LevelCur + 3, LevelDiff = 2) % abajo a la derecha
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

    
%canBeSolved([],_):- false.
%canBeSolved([CurPos, NxtPos], Puzzle) :-
    %allValidMoves(CurPos, ValidMoves),
    %(
        %canBeSolved(ValidMoves)
        %;
        %canBeSolved(NxtPos)
    %).





