-module(ring).
-export([start/2, stop/0, send_message/1, send_message/2]).

%functions
start(N, L) ->
    Pid = self(),
    register(ring, spawn(fun() -> init_ring(N, L, Pid) end)),
    receive
        {ready} ->
            io:format("Ring stareted.~n")
    end.

stop() ->
    io:format("Closing the system.~n", []),
    ring ! {stop}.

send_message(N) ->
    send_message(N, 1).

send_message(N, Times) ->
    ring ! {input, N, times, Times}.

%ring system
init_ring(1, [F], Starter) ->
    Starter ! {ready},
    wait_last(F, ring);
init_ring(N, [F1 | F], Starter) ->
    Pid = spawn_link(fun() -> init_ring(N-1, F, Starter) end),
    wait(F1, Pid).

wait_last(F, Next) ->
    receive
        {stop} ->
            ok;
        {input, N, times, 1} ->
            io:format("~p.~n", [F(N)]),
            wait_last(F, Next);
        {input, N, times, T} ->
            Next ! {input, F(N), times, T-1},
            wait_last(F, Next);
        Any ->
            io:format("Received ~p.~n", [Any]),
            wait_last(F, Next) 
    end.

wait(F, Next) ->
    receive
        Msg = {stop} ->
            Next ! Msg,
            ok;
        {input, N, times, T} ->
            Next ! {input, F(N), times, T},
            wait(F, Next);
        Any ->
            io:format("Received ~p.~n", [Any]),
            wait_last(F, Next) 
    end.

