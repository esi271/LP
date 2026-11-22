-module(mm).
-export([spawn_mm/2]).

spawn_mm(Node, Pid) ->
    spawn(
        Node,
        fun() ->
            register(mm, self()),
            group_leader(whereis(user), self()),
            io:format("MM is ready on node ~p.~n", [node()]),
            wait_mm(Pid)
        end
    ).

wait_mm(Server) ->
    receive
        {Word, palindrome, S, Ref} ->
            io:format("Forwarding ~p to server.~n", [{Word, palindrome, S, Ref} ]),
            Server ! {self(), Word, palindrome, S, Ref},
            wait_mm(Server);
        {close} ->
            io:format("Closing this mm.~n", []),
            Server ! {close};
        Any ->
            io:format("Received ~p.~n", [Any]),
            wait_mm(Server)
    end.