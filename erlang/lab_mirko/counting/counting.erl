-module(counting).
-export([start/0, rpc/1, loop/1, dummy1/0, dummy2/0, tot/0]).

start() ->
    register(c_server, spawn(?MODULE, loop, [[]])).

rpc(Request) ->
    c_server ! {self(), Request},
    receive
	Any -> io:format("I got: ~p~n", [Any])
    end.

count(Service, []) -> [{Service, 1}];
count(Service, [{Service, Acc}|Tl]) -> [{Service, Acc+1}|Tl];
count(Service, [H|Tl]) -> [H|count(Service, Tl)].

dummy1() -> dummy1.
dummy2() -> dummy2.
tot() -> tot.

loop(Reg) ->
    receive
	{From, tot} ->
	    From ! {c_server, Reg},
	    loop(count(tot, Reg));
	{From, Service} -> 
	    From ! {c_server, Service},
	    loop(count(Service, Reg));
	Any ->
	    io:format("Not a function: ~p~n", [Any]),
	    loop(Reg)
    end.
