-module(sort).
-export([sort/1]).

swap(A, B) ->
    if
        A > B   -> [A|[B]];
        A <= B  -> [B|[A]];
    end;
sortingswap(A) -> [A];

sort([]) -> [];
onesort([A,B|T]) -> swap(A, B) ++ onesort(T)

