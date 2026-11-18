-module(receiver).
-export([start/0]).

start() ->
    register(receiver, spawn(fun wait/0)).

waiting_for_transmission(Received, N) when length(Received) == N ->
    build(Received);
waiting_for_transmission(Received, N) ->
    receive
        {piece, P, NumSeq} ->
            waiting_for_transmission([{P, NumSeq} | Received], N);
        {finished, Tot} ->
            waiting_for_transmission(Received, Tot)
    end.

build(Received) ->
    Ordered = lists:sort(fun({_A, N1}, {_B,N2}) -> N1 =< N2 end, Received),
    lists:map(fun({A, _N}) -> A end, Ordered).

wait() ->
    receive
        {start, Pid} ->
            Pid ! {ready},
            Msg = waiting_for_transmission([], -1),
            io:format("The message is: ~p.~n", [string:join(Msg, " ")]),
            wait();
        {shutdown} ->
            io:format("The receiver is gracely shutting down~n")
    end.
