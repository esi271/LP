-module(bank).
-export([start/0, create/1, balance/1, deposit/2, withdraw/2]).

start() ->
    register(bank, spawn(fun loop/0)).

create(Id) ->
    bank ! {create, Id}.

balance(Id) ->
    bank ! {balance, Id}.

deposit(Id, Amt) ->
    bank ! {deposit, Id, Amt}.

withdraw(Id, Amt) ->
    bank ! {withdraw, Id, Amt}.

loop() ->
    receive
	{create, N} -> 
	    put(N, 5000),
	    loop();
	{balance, Who} -> 
	    Bal = get(Who),
	    io:format("Balance is ~p~n", [Bal]),
	    loop();
	{deposit, Who, Amt} ->
	    New = get(Who) + Amt,
	    put(Who, New),
	    loop();
	{withdraw, Who, Amt} ->
	    case get(Who) - Amt of
		N when N < 0 -> 
		    error;
		N -> 
		    put(Who, N)
	    end,
	    loop();
	Any -> io:format("Received unknown msg: ~p~n", [Any]), loop()
    end.
