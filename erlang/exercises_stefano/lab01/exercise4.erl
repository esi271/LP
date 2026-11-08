-module(exercise4).
-export([start/0, print/1, stop/0, start2/0, print2/1, stop2/0]).

start() -> 
    Pid = spawn(fun() -> loop() end),
    register(server, Pid).

print(Term) ->
    server ! Term.

stop() ->
    server ! {stop}.

loop() ->
    receive
        {stop} -> 
            unregister(server);
        M ->
            io:format("~p.~n", [M]),
            loop()
    end.

% Then write a client to be connected to such a server and link these two processes each other. 
% When the stop function is called, instead of sending the stop message, make the first process terminate abnormally. 
% This should result in the EXIT signal propagating to the other process, causing it to terminate as well.

start2() -> 
    Pid = spawn(
        fun()->
            PidServer = spawn_link(fun() -> loopServer() end),
            register(server, PidServer),   %per controllare dalla shell se effettivamente muore anche lui
            loopClient(PidServer)
        end
        ),
    register(client, Pid),
    ok.

print2(Term) ->
    client ! {print,Term},
    ok.

stop2() ->
    exit(whereis(client), kill),
    ok.

loopClient(Pid) ->
    receive
        M -> 
            Pid ! M,
            loopClient(Pid)
    end.

loopServer() ->
    receive
        {print, Term} ->
            io:format("~p.~n", [Term]),
            loopServer();
        _ ->
            io:format("comando non riconoscito.~n"),
            loopServer()
    end.
