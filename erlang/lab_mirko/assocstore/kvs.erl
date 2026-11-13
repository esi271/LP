-module(kvs).
-export([start/0, start_nodes/1, store/2, lookup/1, update_local/2]).

start() ->
    register(kvs, spawn(fun loop/0)),
    group_leader(whereis(user), self()),
    global:register_name(node(), self()).

start_nodes(Nodes) ->
    rpc:multicall(Nodes, kvs, start, []).

store(Key, Value) ->
    rpc({store, Key, Value}).

update_local(Key, Value) ->
    kvs ! {update, Key, Value},
    ok.

lookup(Key) -> rpc({lookup, Key}).

rpc(Q) ->
    kvs ! {self(), Q},
    receive
	{kvs, Reply} ->
	    Reply
    after 5000 ->
	timeout
    end.

loop() ->
    receive
	{From, {store, Key, Value}} ->
	    put(Key, Value),
	    rpc:multicall(nodes(), kvs, update_local, [Key, Value]),
	    From ! {kvs, true},
	    loop();
	{update, Key, Value} ->
	    put(Key, Value),
	    loop();
	{From, {lookup, Key}} ->
	    From ! {kvs, get(Key)},
	    loop();
	Any -> 
	    io:format("Wrong input: ~p~n", [Any]),
	    loop()
    end.
