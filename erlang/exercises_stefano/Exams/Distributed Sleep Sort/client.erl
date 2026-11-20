-module(client).
-export([connect_server/1, queries/1]).

%client
connect_server(Node) ->
    {server, Node} ! {ready, self()},
    receive
        {ready} ->
            register(client, spawn(fun() -> wait(Node) end)),
            io:format("We are connected to the server.", [])
    after 50 ->
        io:format("Failed to connect with server in node: ~p.~n", [Node])
    end.


wait(Node) ->
    receive
        {sort, List, Pid} ->
            {server, Node} ! {sort, List, self()},
            receive
                {sorted, Ordered} ->
                    io:format("Received: ~p~n", [Ordered]),
                    Pid ! {sorted, Ordered},
                    wait(Node)
            end;
        {quit} ->
            io:format("Quitting.", []),
            {server, Node} ! {quit};
        Any ->
            io:format("Received ~p~n", [Any]),
            wait(Node)
    end.

% talk to client
queries(quit) ->
    whereis(client) ! {quit};
queries(List) ->
    whereis(client) ! {sort, List, self()},
    receive
        {sorted, Ordered} -> Ordered
    end.
