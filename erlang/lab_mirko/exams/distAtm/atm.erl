-module(atm).
-export([start/1, balance/2]).

start(N) ->
    Pid = spawn(fun() -> loop(N, 0) end),
    put(N, Pid).

balance(Node, Id) ->
    get(Id) ! {self(), {balance, Node, Id}},
    receive
	{ok, Amt} -> io:format("Currently the balance is ~p~n", [Amt]);
	Any -> io:format("Unknown msg: ~p~n", [Any])
    end.

loop(Id, Counter) ->
    receive
	{From, {balance, Node, Id}} ->
	    io:format("Atm ~p sending balance rq to bank~n", [Id]),
	    {dispatcher, Node} ! {self(), Id, Counter, {balance}},
	    receive
		{ok, Amt} -> From ! {ok, Amt};
		{error} -> boh
	    end,
	    loop(Id, Counter+1);
	Any -> io:format("Atm ~p received unknown message: ~p~n", [Id, Any]), loop(Id, Counter)
    end.
