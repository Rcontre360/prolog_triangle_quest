% Define the triangle levels
triangleLevel([1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5]).
isEmpty([false,true,false,false,false,false,false,false,false,false,false,false,false,false,false]).

printList([]).
printList([H|T]) :-
    write(H), nl,  % Write the current element and a newline
    printList(T). % Recursively print the rest of the list

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
isValidMove(Cur, Nxt,Puzzle) :- 
    nth1(Cur, Puzzle, false),
    nth1(Nxt, Puzzle, true),

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
allValidMoves(Cur, ValidMoves,Puzzle) :-
    findall(Nxt, isValidMove(Cur, Nxt, Puzzle), ValidMoves).

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

isValidTransition(Puzzle, NxtPuzzle,From,To) :-
    isValidMove(From,To,Puzzle),
    isIntermediate(From,To,Inter),
    modifyAtIndex(Puzzle, From, true, FirstChange),
    modifyAtIndex(FirstChange, To, false, SecondChange),
    modifyAtIndex(SecondChange, Inter, true, NxtPuzzle).

isSolutionInTransitionList([],_) :- false.
isSolutionInTransitionList([CurTransition | Transitions],Movements) :-
    canBeSolved(CurTransition,Movements)
    ;
    isSolutionInTransitionList(Transitions,Movements).
    
canBeSolved(Puzzle,[]) :- isSolved(Puzzle,false).
canBeSolved(Puzzle,Movements) :-
    isSolved(Puzzle, false)
    ;
    (
    areAllValidTransitions(Puzzle,Transitions, Movements),
    isSolutionInTransitionList(Transitions,Movements)
    ).

areAllValidTransitions(Puzzle, Transitions, Movements) :-
    findall((From,To, Solution), isValidTransition(Puzzle, Solution, From, To) ,Transitions),
    areMovementsCorrect(Movements,Transitions).

areMovementsCorrect([],[]).
areMovementsCorrect(_,[]) :- false.
areMovementsCorrect([],_) :- false.
areMovementsCorrect([CurMov|NxtMoves],[CurTrans|NxtTrans]) :- 
    nth1(0, CurTrans, FromTrans),  
    nth1(1, CurTrans, ToTrans),  

    nth1(0, CurMov, FromMov),  
    nth1(1, CurMov, ToMov),  

    FromTrans = FromMov,
    ToTrans = ToMov,
    areMovementsCorrect(NxtMoves, NxtTrans).
    

main(X,Y) :-
    isEmpty(Puzzle),
    areAllValidTransitions(Puzzle, X,Y).
    %canBeSolved(Puzzle).
