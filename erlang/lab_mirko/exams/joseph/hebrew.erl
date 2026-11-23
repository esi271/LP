-module(hebrew).
-export([init/4]).

init(N, K, Master, I) ->
    receive
	{next, To} -> 
	    loop(N, K, To, Master, I);
	Any -> io:format("Unknown msg received: ~p~n", [Any])
    end.

loop(N, K, Next, Master, I) ->
    receive
	{died, NewNext} ->
	    loop(N, K, NewNext, Master, I);
	{forward, _, _, D} when D==(N-1) ->
	    Master ! {survived, I};
	{forward, K, From, D} ->
	    From ! {died, Next},
	    Next ! {forward, 1, self(), D+1};
	{forward, Seq, _, D} ->
	    Next ! {forward, Seq+1, self(), D},
	    loop(N, K, Next, Master, I)
    end.
