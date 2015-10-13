-module(expr).
-export([lpri/1, simpleParse/1]).

lpri([]) -> ok;
lpri([A|T]) -> io:format("~c~n", [A]), lpri(T).

symbolType(S) ->
    if
        S =:= $+  -> {oper, plus};
        S =:= $-  -> {oper, minus};
        S =:= $/  -> {oper, divide};
        S =:= $*  -> {oper, mult};
        S =:= $   -> space;
        S >= 16#30, S =< 16#39  -> {val, S - 16#30}
    end.

addOrInc(Acc, V, Ndig) when Ndig =:= 0 -> [V|Acc];
addOrInc([Old|Acc], V, Ndig) when Ndig > 0 -> [Old*10 + V|Acc].

simpleParse([], Acc, Opcode, _) -> [Opcode|Acc];
simpleParse([A|T], Acc, OldOpcode, Ndig) ->
    case symbolType(A) of
        {oper, Opcode}  -> simpleParse(T, Acc, Opcode, 0);
        {val, V}        -> simpleParse(T, addOrInc(Acc, V, Ndig), OldOpcode, Ndig+1);
        space           -> simpleParse(T, Acc, OldOpcode, Ndig)
    end.

simpleParse(Str) -> list_to_tuple(simpleParse(Str, [], undefined, 0)).
