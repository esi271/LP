-module(echo2).
-export([start/0, print/1, stop/0, start_client/0]).

start() -> 
    register(echo_server, spawn(fun loop/0)),
    ok.

print(Term) ->
    echo_server ! {msg, Term},
    ok.

stop() ->
    exit(whereis(echo_server), stop),
    ok.

loop() -> 
    receive
	stop -> io:format("Stopping echo server~n");
	{msg, Term} -> io:format("Server received ~p~n", [Term]), loop();
	Any -> io:format("ERROR: received ~p~n", [Any])
    end.

start_client() ->
    spawn(
      fun() ->
	      link(whereis(echo_server)),
	      client_loop()
      end
      ).

client_loop() ->
    receive
	Any -> io:format("client rx ~p~n", [Any]), loop()
    end.
