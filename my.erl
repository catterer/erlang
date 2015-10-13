-module(my).
-export([trythis/1]).

trythis(Value) ->
    case Value of
        "My"  -> ok;
        "His" -> error
    end.
