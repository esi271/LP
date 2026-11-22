-module(sieve).
-export([init/1]).

init(N) ->
    receive
	{who, From} -> From ! {who, N}, init(N);
	{One, Succ} -> 
	    loop(One, Succ, N)
    end.

loop(One, Succ, N) ->
    receive
	{new, Num} -> 
	    One ! {pass, Num}, loop(One, Succ, N);
	{pass, Num} ->
	    if
		(N >= Num) -> One ! {res, true}, loop(One, Succ, N);
		(Num rem N == 0) -> One ! {res, false}, loop(One, Succ, N);
		true -> Succ ! {pass, Num}, loop(One, Succ, N)
	    end;
	{res, B} ->
	    controller ! {res, B}, loop(One, Succ, N);
	Any -> io:format("Unknown msg received ~p~n", [Any]), loop(One, Succ, N)
    end.
