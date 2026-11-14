-module(kvs).
-export([start_frontend/1, store/2, lookup/1]).

%frontend 
start_frontend(Nodes) ->
    global:register_name(frontend, spawn(fun() -> init(Nodes) end)).

init(Nodes) ->
    group_leader(whereis(user), self()),
    Stores = spawn_store(Nodes, []),
    wait_frontend(Stores).

spawn_store([], Acc) -> Acc;
spawn_store([N | Nodes], Acc) ->
    Pid = spawn(N, fun() -> store_init() end),
    spawn_store(Nodes, [Pid | Acc]).

update_stores(M, [S]) ->
    S ! M;
update_stores(M, [S | Stores]) -> 
    S ! M,
    update_stores(M, Stores).

wait_frontend([S1 | Stores]) ->
    receive
        {store, Tag, Value, Pid} ->
            update_stores({store, Tag, Value, self()}, [S1 | Stores]),
            Pid ! {done},
            wait_frontend([S1 | Stores]);
        {lookup, Tag, Pid} ->
            S1 ! {lookup, Tag, Pid},
            wait_frontend(Stores ++ [S1]);
        Any ->
            io:format("Unexpected message recived: ~p.~n", [Any]),
            wait_frontend([S1 | Stores])
    end.


%server store
store_init() ->
    group_leader(whereis(user), self()),
    io:format("Store initialized successfully.~n", []),
    wait_store().

wait_store() ->
    receive
        {store, Tag, Value, _Pid} ->
            put(Tag, Value),
            io:format("Put Tag: ~p, Val: ~p in store.~n", [Tag, Value]),
            wait_store();
        {lookup, Tag, Pid} ->
             io:format("Doing lookup of: ~p in store.~n", [Tag]),
            Pid ! {result, get(Tag)},
            wait_store();
        Any ->
            io:format("Unexpected message recived: ~p.~n", [Any]),
            wait_store()
        end.

%client
store(Tag, Value) ->
    global:whereis_name(frontend) ! {store, Tag, Value, self()},
    receive
        {done} -> ok
    end.

lookup(Tag) ->
    global:whereis_name(frontend) ! {lookup, Tag, self()},
    receive
        {result, Val} -> Val
    end.