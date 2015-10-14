-module(db).
-export([new/0]).

new() ->
	{ok, File} = file:open("./data", [read, write]),
	Header = "hdrmagic",
	case file:read(File, length(Header)) of
		{ok, Header} -> {File};
		eof ->
			ok = file:write(File, Header),
			{File}
	end.
