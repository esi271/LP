-module(sender).
-export([start/2, send_msg/1, quit/0, shutdown/0]).

start(N, Node) ->
    register(sender, (fun() -> init(N, Node) end)).

init(N, Node) ->
    PIDs = [spawn_link(switch, init, [I, Node]) || I <- lists:seq(1, N)],
    loop(PIDs).

send_msg(Msg) ->
    sender ! {send, Msg}.

quit() ->
    sender ! {quit}.

shutdown() ->
    sender ! {shutdown}.

loop(PIDs) ->
    receive
	{send, Msg} -> 
	    Tokens = strings:lexemes(Msg, " "),
	    Len = length(PIDs),
	    Assign = lists:zip(Tokens, [lists:nth((Len rem I), PIDs) || I <- lists:seq(0, length(Tokens)) ]),
	    lists:foreach(
		fun({Seq, {Pid, Token}}) ->
			Pid ! {send, Token, Seq, length(Tokens)}
		end, lists:enumerate(Assign)
	    );
	Any -> io:format("### ERROR: ~p~n", [Any])
    end.
