-module(dispatcher).
-export([start/1]).

start(Node) ->
    register(dispatcher, spawn(fun() -> process_flag(trap_exit, true), loop(Node) end)).

loop(Bank) ->
    receive
	{From, Id, Counter, Msg} ->
	    io:format("Dispatcher rx msg ~p from ~p: ~p~n", [Counter, Id, Msg]),
	    Pid = case get(Id) of
		undefined ->
		    {bank, Bank} ! {From, {create, Id}},
		    create_mm(Id);
		Some -> Some
	    end,
	    Pid ! {From, Id, Counter, Msg},
	    loop(Bank);
	{ordered, From, Id, Num, {balance}} ->
	    {bank, Bank} ! {From, {balance, Id}},
	    loop(Bank);
	Any -> io:format("Dispatcher received unknown message: ~p~n", [Any]), loop(Bank)
    end.

create_mm(Id) ->
    io:format("Creating middle man for ~p~n", [Id]),
    Pid = spawn(fun() -> loop_mm(0, []) end),
    put(Id, Pid),
    Pid.

loop_mm(Counter, Queue) ->
    receive
	{From, Id, Num, {balance}} when Num > Counter -> 
	    flush(Counter, Queue)
	{From, Id, Num, {balance}} -> 
	    io:format("MM ~p rx msg ~p~n", [Id, Num]),
	    dispatcher ! {ordered, From, Id, Num, {balance}},
	    loop_mm(Counter);
	Any -> io:format("Unknown msg: ~p~n", [Any]),
	    loop_mm(Counter)
    end.
