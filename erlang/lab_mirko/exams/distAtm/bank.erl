-module(bank).
-export([start/0]).

start() ->
    register(bank, spawn(node(), fun loop/0)).

loop() ->
    receive
	{From, {create, N}} -> 
	    put(N, 5000),
	    From ! {ok, N},
	    loop();
	{From, {balance, Who}} -> 
	    Bal = get(Who),
	    io:format("I got a balance request from ATM ~p~n", [Who]),
	    From ! {ok, Bal},
	    loop();
	{From, {deposit, Who, Amt}} ->
	    New = get(Who) + Amt,
	    put(Who, New),
	    From ! {ok},
	    loop();
	{From, {withdraw, Who, Amt}} ->
	    New = get(Who) - Amt,
	    put(Who, New),
	    From ! {ok},
	    loop();
	Any -> io:format("Received unknown msg: ~p~n", [Any]), loop()
    end.
