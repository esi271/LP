-module(sleepsort).
-export([start/0]).

start() ->
    register(server, spawn(fun wait/0)).

%slaves nodes
pad(N) when N < 10 -> [$0 | integer_to_list(N)];
pad(N) -> integer_to_list(N).

slave_node_atom(N) ->
    NodeName = string:join(["sleep", pad(N), "@", net_adm:localhost()], ""),
    list_to_atom(NodeName).

%slaves
wait_sleep() ->
    receive
        {sleep, N, Pid} ->
            receive
            after N ->
                io:format("I'm the stage ~p~n", [N]),
                Pid ! {sorted, N},
                io:format("I waited ~p millisecs~n", [N])
            end
    end.

spawn_slaves([], Acc) ->
    lists:reverse(Acc);
spawn_slaves([N | N1], Acc) ->
    Pid = spawn(
        slave_node_atom(N),
        fun() ->
            group_leader(whereis(user), self()),
            wait_sleep()
        end
        ),
    spawn_slaves(N1, [Pid | Acc]).

%server
sleepsort(List) ->
    Slaves = spawn_slaves(lists:seq(1, length(List)), []),
    lists:foreach(fun({S, N}) -> S ! {sleep, N, self()} end, lists:zip(Slaves, List)),
    sort(length(List), []).

sort(Dim, Acc) when Dim == length(Acc) -> lists:reverse(Acc);
sort(Dim, Acc) ->
    receive
        {sorted, N} ->
            sort(Dim, [N | Acc])
    end.

wait() ->
    receive
        {sort, List, Pid} ->
            io:format("Received ~p to sort.~n", [List]),
            Ordered = sleepsort(List),
            io:format("Ordered list: ~p.~n", [Ordered]),
            Pid ! {sorted, Ordered},
            wait();
        {ready, Pid} ->
            io:format("Received connection attempt from ~p.~n", [Pid]),
            Pid ! {ready}, 
            wait();
        {quit} ->
            io:format("Stopping Server.~n");
        Any ->
            io:format("Received ~p~n", [Any]),
            wait()
    end.