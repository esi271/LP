-module(echo).
-export([start/0, print/1, stop/0]).

start() -> 
    register(echo_server, spawn(fun loop/0)),
    ok.

print(Term) ->
    echo_server ! {msg, Term},
    ok.

stop() ->
    echo_server ! stop,
    ok.

loop() -> 
    receive
	stop -> io:format("Stopping echo server~n");
	{msg, Term} -> io:format("Server received ~p~n", [Term]), loop();
	Any -> io:format("ERROR: received ~p~n", [Any])
    end.
