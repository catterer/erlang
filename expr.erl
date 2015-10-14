-module(expr).
-export([lpri/1, simpleParse/1, eval/1, calc/1]).

lpri([]) -> ok;
lpri([A|T]) -> io:format("~c~n", [A]), lpri(T).

symbolType(S) ->
    if
        S =:= $+  -> {oper, plus};
        S =:= $-  -> {oper, minus};
        S =:= $/  -> {oper, divide};
        S =:= $*  -> {oper, mult};
        S =:= $   -> space;
        S =:= $(  -> braceOpen;
        S =:= $)  -> braceClose;
        S >= 16#30, S =< 16#39  -> {val, S - 16#30}
    end.

addOrInc(Acc, V, Ndig) when Ndig =:= 0 -> [V|Acc];
addOrInc([Old|Acc], V, Ndig) when Ndig > 0 -> [Old*10 + V|Acc].

simpleParse([], Acc, Opcode, _) -> list_to_tuple([Opcode|Acc]);
simpleParse([A|T], Acc, OldOpcode, Ndig) ->
    case symbolType(A) of
        {oper, Opcode}  -> simpleParse(T, Acc, Opcode, 0);
        space           -> simpleParse(T, Acc, OldOpcode, Ndig);
        braceOpen       ->
            {NewTail, Parsed} = simpleParse(T, [], nil, 0),
            simpleParse(NewTail, lists:append(Acc, [Parsed]), OldOpcode, 0);
        braceClose      -> {T, simpleParse([], Acc, OldOpcode, 0)};
        {val, V}        -> simpleParse(T, addOrInc(Acc, V, Ndig), OldOpcode, Ndig+1)
    end.

simpleParse(Str) -> simpleParse(Str, [], nil, 0).

eval(A) when is_number(A) -> A;
eval({Action, A, B}) ->
    case Action of
        plus    -> eval(A) + eval(B);
        minus   -> eval(A) - eval(B);
        divide  -> eval(A) / eval(B);
        mult    -> eval(A) * eval(B)
    end.

calc(Str) -> eval(simpleParse(Str)).
