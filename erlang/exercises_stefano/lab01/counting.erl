-module(counting).
-export([start/0, dummy1/0, dummy2/0, dummy3/0, tot/0]).

start() ->
    Pid = spawn(fun() -> loop([]) end),
    register(server, Pid),
    ok.

dummy1() ->
    server ! {call, dummy1},
    ok.

dummy2() ->
    server ! {call, dummy2},
    ok.

dummy3() ->
    server ! {call, dummy3},
    ok.

tot() ->
    server ! {call, tot, {request, self()}},
    receive
        {tot_reply, M}-> M
    end.

increment(R, K) -> increment(R, K, []).

increment([], K, Acc) -> 
    lists:reverse([{K, 1} | Acc]);
increment([{K,N} | Tl], K, Acc) ->
    lists:reverse( [{K, (N+1)} | Acc], Tl);
increment([H | Tl], K, Acc) ->
    increment(Tl, K, [H| Acc]).

loop(Register) ->
    receive
        {call, M} ->
            loop(increment(Register, M));
        {call, tot, {request, Pid}} ->
            Updated = increment(Register, tot),
            Pid ! {tot_reply, Updated},
            loop(Updated);
        _ -> loop(Register)
    end.