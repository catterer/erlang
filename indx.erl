-module(indx).
-export([readfile/1, split/2, splitfile/1]).

lines(Dev, Acc) ->
    case io:get_line(Dev, []) of
        eof -> Acc;
        Line -> lines(Dev, lists:append(Acc, [string:strip(Line, right, $\n)]))
    end.
    
readfile(FName) ->
    {ok, Dev} = file:open(FName, read),
    lines(Dev, []).

split(Line, SepFunc) when is_function(SepFunc) ->
    split(Line, SepFunc, [], []).

split([], _, Acc, []) -> Acc;
split([], _, Acc, LastWord) -> lists:append(Acc, [LastWord]);
split([A|T], SepFunc, Acc, LastWord) ->
    case {SepFunc(A), LastWord} of
    {true, []}   -> split(T, SepFunc, Acc, []);
    {true, _}    -> split(T, SepFunc, lists:append(Acc, [LastWord]), []);
    {false, _}   -> split(T, SepFunc, Acc, lists:append(LastWord, [A]))
    end.

splitlines(Lines, IsSep) -> splitlines(Lines, [], IsSep).
splitlines([], Acc, _) -> Acc;
splitlines([A|T], Acc, IsSep) ->
    SplitLine = split(A, IsSep),
    splitlines(T, lists:append(Acc, [SplitLine]), IsSep).

splitfile(FName) ->
    splitlines(readfile(FName), fun ($ )-> true; (_)->false end).
    
