-module(controller).
-export([start/1]).

start(N) -> register(controller, spawn(fun() -> init_ring(N) end)).

init_ring(N) -> 
    loop(N, connect([spawn_link(sieve, init, [X]) || X <- lists:seq(2, N), 
	(length([Y || Y <- lists:seq(2, trunc(math:sqrt(X))), (X rem Y == 0)])) == 0])).

connect(L=[H|_]) -> connect(H, L).
connect(Pid, [Pid1 | []]) ->
    Pid1 ! {who, self()},
    receive
	{who, Max} -> loop(Max, Pid)
    end;
connect(Pid, [Pid1 | Tl = [Pid2 | _]]) ->
    Pid1 ! {Pid, Pid2}, connect(Pid, Tl).

loop(Max, Head) ->
    receive
	{new, N, From} when N =< Max ->
	    io:format("You asked for: ~p~n", [N]),
	    Head ! {new, N},
	    receive
		{res, B} ->
		    From ! {result, lists:flatten(io_lib:format("is ~p prime? ~p", [N, B]))}
	    end,
	    loop(Max, Head);
	{new, N, From} ->
	    io:format("You asked for: ~p~n", [N]),
	    From ! {result, lists:flatten(io_lib:format("~p is uncheckable, too big value.", [N]))},
	    loop(Max, Head);
	{quit, From} ->
	    io:format("I'm closing...~n", []),
	    From ! {result, lists:flatten(io_lib:format("The service is closed!!!"))};
	Any -> io:format("Unknown msg received: ~p~n", [Any])
    end.
