-module(switch).
-export([wait/2]).

wait(Number, Node) ->
    receive 
        {piece, P, NumSeq} ->
            io:format("The switch #~p is routing the message: ~p~n", [Number, P]), 
            {receiver, Node} ! {piece, P, NumSeq},
            wait(Number, Node);
        {start} ->
            io:format("The switch #~p is initializing the communication process.~n", [Number]),
            {receiver, Node} ! {start, self()},
            receive 
                {ready} -> 
                    whereis(sender) ! {ready},
                    wait(Number, Node)
            end;
        {finished, Tot} ->
            io:format("The switch #~p is finishing the communication process.~n", [Number]),
            {receiver, Node} ! {finished, Tot},
            wait(Number, Node)
    end.