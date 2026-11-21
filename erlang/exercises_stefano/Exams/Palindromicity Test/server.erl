-module(server).
-export([spawn_server/1]).

spawn_server(Node) ->
    spawn(
        Node,
        fun() ->
            group_leader(whereis(user), self()),
            io:format("Starting server on node ~p.~n", [node()]),
            waiting_mm()
        end
    ).

waiting_mm() ->
    receive
        {From, mm1, Pid1, mm2, Pid2} ->
            From ! {ready},
            io:format("Received mm1: ~p and mm2: ~p.~n", [Pid1, Pid2]),
            io:format("Server is ready on node ~p.~n", [node()]),
            wait_server({Pid1, Pid2})
    end.

wait_second_part(M2, S, Ref) ->
    receive
        {M2, Word, palindrome, S1, Ref} when S1 == S ->
            io:format("String ~p is palindrome.~n", [Word]);
        {M2, Word, palindrome, _, Ref} ->
            io:format("String ~p isn't palindrome.~n", [Word])
    end.

wait_server({M1, M2}) ->
    receive
        {M1, _Word, palindrome, S, Ref} ->
            wait_second_part(M2, S, Ref),
            wait_server({M1, M2});
        {close} ->
            io:format("Closing the server.~n", [])
    end.