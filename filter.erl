-module(filter).
-export([reverse/1, concatenate/1, qsort/1, mergeD/2]).

filterless([], _) -> [];
filterless([A|T], N) when N >= A -> [A|filterless(T, N)];
filterless([A|T], N) when N <  A -> filterless(T, N).

filtermore([], _) -> [];
filtermore([A|T], N) when N <  A -> [A|filtermore(T, N)];
filtermore([A|T], N) when N >= A -> filtermore(T, N).

reverse([], Acc) -> Acc;
reverse([A|T], Acc) -> reverse(T, [A|Acc]).

reverse(List) when is_list(List)->reverse(List, []);
reverse(A) -> A.

concatenate([], Big) -> concatenate(Big);
concatenate([A|T],Big) -> concatenate(T, [A|Big]);
concatenate(A, Big) -> [A|concatenate(Big)].

concatenate([])->[];
concatenate([A|T]) -> concatenate(reverse(A), T).

qsort([])->[];
qsort([A|T])->lists:append([filterless(qsort(T), A), [A], filtermore(qsort(T), A)]).

mergeD([], [], Acc)    -> Acc;
mergeD([], [A|T], Acc) -> mergeD([], T, [A|Acc]);
mergeD([A|T], [], Acc) -> mergeD([], T, [A|Acc]);
mergeD([A|Ta], [B|Tb], Acc) ->
    if
        A < B   -> mergeD(Ta, [B|Tb], [A|Acc]);
        A >= B  -> mergeD([A|Ta], Tb, [B|Acc])
    end.
mergeD(A, B) -> reverse(mergeD(qsort(A), qsort(B), [])).
