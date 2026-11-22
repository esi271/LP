-module(ring).
-export([start/2, stop/0, send_message/1, send_message/2]).

start(N, [H|Tl]) -> 
    register(ring_leader, spawn(fun() -> Pid = create_next(N-1, Tl), loop(Pid, H) end)).

create_next(1, [H|_]) ->
    spawn_link(fun() -> loop_last(H) end);
create_next(N, [H|Tl]) ->
    spawn_link(fun() -> Pid = create_next(N-1, Tl), loop(Pid, H) end).

send_message(X) -> ring_leader ! {forward, 1, X}.
send_message(X, Times) -> ring_leader ! {forward, Times, X}.

stop() -> ring_leader ! {stop}.

loop(Next, Fun) ->
    receive
	{stop} -> Next ! {stop};
	{forward, Times, In} ->
	    Next ! {forward, Times, Fun(In)},
	    loop(Next, Fun);
	Any -> io:format("Unexpected msg: ~p~n", [Any])
    end.

loop_last(Fun) ->
    receive
	{stop} -> exit(normal), unregister(ring_leader);
	{forward, Times, In} ->
	    case Times of
		1 -> 
		    io:format("~p~n", [Fun(In)]),
		    loop_last(Fun);
		Other -> 
		    ring_leader ! {forward, Other-1, Fun(In)},
		    loop_last(Fun)
	    end
    end.
