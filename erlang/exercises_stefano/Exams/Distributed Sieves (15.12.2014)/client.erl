-module(client).
-export([is_prime/1, close/0]).

server() ->
    [_, Host] = string:tokens(atom_to_list(node()), "@"),
    list_to_atom("sif@" ++ Host).

is_prime(N) ->
    {controller, server()} ! {new, N, self()},
    receive
        {result, R} ->
            io:format("is ~p prime? ~p~n", [N, R]);
        {uncheckable} ->
            io:format("~p is uncheckable, too big value.~n", [N])
    end.

close() -> 
    {controller, server()} ! {quit, self()},
    receive
        {closed} ->
            io:format("The service is closed!!!~n", [])
    end.