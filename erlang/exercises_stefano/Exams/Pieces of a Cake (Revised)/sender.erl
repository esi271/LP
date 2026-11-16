-module(sender).
-export([start/2, send_msg/1]).

start(N, Node) ->
    register(sender, spawn(fun() -> init(N, Node) end)).

send_msg(Msg) ->
    sender ! {send, Msg}.

init(N, Node) ->
    wait([spawn(switch, wait, [S, Node]) || S <- lists:seq(1, N)]).

send([Sw | _], [], Tot) ->
    Sw ! {finished, Tot - 1};
send([Sw | S], [P1 | P], NumSeq) ->
    Sw ! {piece, P1, NumSeq},
    send(S ++ [Sw], P, NumSeq + 1).

init_send([S1 | S], Pieces) ->
    S1 ! {start},
    receive
        {ready} -> send(S ++ [S1], Pieces, 1)
    end.

wait(Switches)->
    receive
        {send, M} ->
            Pieces = string:tokens(M, " "),
            init_send(Switches, Pieces),
            wait(Switches)
    end.