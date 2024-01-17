triangle_level([1, 2, 2, 3, 3, 3, 4, 4, 4, 4,5,5,5,5,5])
is_empty([false,false,false,false,false,false,false,false,false,false,false,false,false,false,false])

is_valid_move(cur, nxt) :- 
    nxt == cur - triangle_level[cur - 1] 
    ;
    nxt == cur - triangle_level[cur - 1] + 1
    ;
    nxt == cur - 1
    ;
    nxt == cur + 1
    ;
    nxt == cur + triangle_level[cur - 1]
    ;
    nxt == cur + triangle_level[cur - 1] + 1


is_solved([], is_one_active) :- is_one_active
is_solved([cur | nxt], is_one_active) :- 
    (
        cur == false,
        is_solved(nxt,is_one_active)
    )
    ;
    (
        cur == true,
        is_one_active == false,
        is_solved(nxt,true)
    )
    
is_valid_path(cur, is_empty_arr) :-
    is_solved(is_empty_arr)
    ;
    (
        is_valid_path(cur - triangle_level[cur]),
    )
    ;
    (
        is_valid_path(cur - triangle_level[cur] + 1),
    )
    ;
    (
        is_valid_path(cur - triangle_level[cur] + 1),
    )
    ;
    (
        is_valid_path(nxt == cur - 1),
    )
    ;
    (
        is_valid_path(nxt == cur + 1),
    )
    ;
    (
        is_valid_path(cur + triangle_level[cur]),
    )
    ;
    (
        is_valid_path(cur + triangle_level[cur] + 1)
    )









