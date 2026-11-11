-module(ring_cen).
-export([send_msg/3, create_ring/1]).

send_msg(0, _, _) -> {finish_loop};
send_msg(M, [Start|Rest]=Ring, Msg) -> 
    Start ! {Msg, Rest},
    send_msg(M-1, Ring, Msg).

create_ring(N) -> create_ring(N, []).
create_ring(0, Acc) -> lists:reverse(Acc);
create_ring(N, Acc) ->
    Pid = spawn(fun loop/0),
    create_ring(N-1, [Pid|Acc]).

loop() ->
    receive
	{quit, []} -> 
	    io:format("Quitting ring~n");
	{quit, [H|Tl]} -> 
	    io:format("Quitting ring~n"),
	    H ! {quit, Tl};
	{M, []} -> 
	    io:format("Rx ~p~n",[M]),
	    loop();
	{M, [H|Tl]} -> 
	    io:format("Rx ~p, forwarding to ~p~n", [M, H]),
	    H ! {M, Tl},
	    loop()
    end.
