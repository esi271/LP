-module(combinator).
-export([start/2]).

start(M, N) ->
    register(combinator_master, spawn(fun() -> init_slaves(M, N) end)).

init_slaves(M, N) ->
    [spawn_link(generator, create, [M, N, I]) || I <- lists:seq(1, N)],
    collect(N, M, 1, 1, trunc(math:pow(M, N))).

collect(N, M, Pos, Seq, Max) ->
    receive
	{Seq, Pos, V} when (Seq==Max) andalso (Pos+1 > N) ->
	    io:format("~p~n", [V]), exit(combinator_master), unregister(combinator_master);
	{Seq, Pos, V} when (Pos+1 > N) ->
	    io:format("~p~n", [V]), collect(N, M, 1, Seq+1, Max);
	{Seq, Pos, V} ->
	    io:format("~p ", [V]), collect(N, M, Pos+1, Seq, Max)
    end.
