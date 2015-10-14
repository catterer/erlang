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
    split(Line, Sep, [], []).

split([], _, Acc, []) -> Acc;
split([], _, Acc, LastWord) -> lists:append(Acc, [LastWord]);
split([A|T], Sep, Acc, LastWord) ->
    case {A, LastWord} of
    {Sep, []}   -> split(T, Sep, Acc, []);
    {Sep, _}    -> split(T, Sep, lists:append(Acc, [LastWord]), []);
    _           -> split(T, Sep, Acc, lists:append(LastWord, [A]))
    end.

