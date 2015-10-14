-module(indx).
-export([readfile/1, split/2]).

lines(Dev, Acc) ->
    case io:get_line(Dev, "") of
        eof -> Acc;
        Line -> lines(Dev, lists:append(Acc, [Line]))
    end.
    
readfile(FName) ->
    Dev = file:open(FName, read),
    lines(Dev, []).

split(Line, Sep) when is_integer(Sep) ->
    split(Line, Sep, []).

split([], _, Acc) -> Acc;
split([A|T], Sep, Acc) ->
    case A of
        Sep -> split(T, Sep, lists:append(Acc, [[]]));
        _   -> split(T, Sep, modlast(Acc, A))
    end.
    
modlast([], A) -> [[A]];
modlast([Last|T], A) -> [lists:append(Last, [A])|T].
