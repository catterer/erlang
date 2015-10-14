-module(exs).
-export([sum/1, sum/2, reverse_create/1, create/1]).

sum(0)->0;
sum(Int) when Int > 0 -> Int + sum(Int-1).

sum(N, N) -> N;
sum(N, M) when M > N -> M + sum(N, M-1).

reverse_create(0) -> [];
reverse_create(N) when N > 0 -> [N|reverse_create(N-1)].

create(N) -> lists:reverse(reverse_create(N)).

