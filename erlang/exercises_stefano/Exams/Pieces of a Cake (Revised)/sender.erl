-module(sender).
-export([start/2, send_msg/1, quit/0, shutdown/0]).

%functions
start(N, Node) ->
    register(sender, spawn(fun() -> init(N, Node) end)).

send_msg(Msg) ->
    sender ! {send, Msg}.

quit() ->
    sender ! {quit}.

shutdown() ->
    sender ! {shutdown}.

%Others
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

shutdown_switch([S]) ->
    S ! {shutdown, receiver};
shutdown_switch([S | Tl]) ->
    S ! {shutdown},
    shutdown_switch(Tl).

wait(Switches)->
    receive
        {send, M} ->
            Pieces = string:tokens(M, " "),
            init_send(Switches, Pieces),
            wait(Switches);
        {quit} ->
            io:format("I'm closing ...~n",[]),
            lists:foreach(fun(Pid) -> Pid ! {quit} end, Switches);
        {shutdown} ->
            io:format("Shutting down the system...~n",[]),
            shutdown_switch(Switches)
    end.