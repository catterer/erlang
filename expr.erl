-module(expr).
-export([lpri/1, simpleParse/1]).

lpri([]) -> ok;
lpri([A|T]) -> io:format("~c~n", [A]), lpri(T).

symbolType(S) ->
    case S of
        $+  -> {oper, plus};
        $-  -> {oper, minus};
        $/  -> {oper, divide};
        $*  -> {oper, mult};
        $   -> space;
        _   -> val
    end.

simpleParse([], Acc, Opcode) -> [Opcode|Acc];
simpleParse([A|T], Acc, OldOpcode) ->
    case symbolType(A) of
        {oper, Opcode}  -> simpleParse(T, Acc, Opcode);
        val             -> simpleParse(T, [A|Acc], OldOpcode);
        space           -> simpleParse(T, Acc, OldOpcode)
    end.

simpleParse(Str) -> list_to_tuple(simpleParse(Str, [], undefined)).
