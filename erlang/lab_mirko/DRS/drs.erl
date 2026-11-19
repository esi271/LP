-module(drs).
-export([start_master/0, divide_string/1]).

start_master() ->
    register('MasterProcess', spawn(
	fun() -> 
	    process_flag(trap_exit, true),
	    loop_master()
	end
    )).

long_reverse_string(Str) ->
    Subs = divide_string(Str).

divide_string(Str) ->
    N = string:length(Str) rem 10,
    divide_string(0, N, string:length(Str), Str, []).
divide_string(10, _, _, _, Acc) ->
    Acc;
divide_string(NSub, N, Len, Str, Acc) when NSub > N ->
    WN = string:slice(Str, 0, Len div 10),
    NStr = string:slice(Str, Len div 10 + 1, infinity),
    divide_string(NSub+1, N, Len, NStr, [WN|Acc]);
divide_string(NSub, N, Len, Str, Acc) ->
    WN = string:slice(Str, 0, Len div 10 + 1),
    NStr = string:slice(Str, Len div 10 + 1, infinity),
    divide_string(NSub+1, N, Len, NStr, [WN|Acc]).

loop_slave() ->
    receive
	{substring, S} ->
	    'MasterProcess' ! {done, strings:reverse(S)};
	Any ->
	    io:format("Unknown msg received ~p~n", [Any])
    end.

loop_master() ->
    receive
	Any -> 
	    io:format("puppa ~p~n", [Any]),
	    loop_master()
    end.
