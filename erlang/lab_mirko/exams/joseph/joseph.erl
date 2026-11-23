-module(joseph).
-export([joseph/2]).

joseph(N, K) ->
    Me = self(),
    PIDs = [spawn(hebrew, init, [N, K, Me, I]) || I <- lists:seq(1, N)],
    connect(PIDs),
    io:format("In a circle of ~p people, killing number ~p~n", [N, K]),
    hd(PIDs) ! {forward, 1, self(), 0},
    receive
	{survived, I} ->
	    io:format("Joseph is the Hebrew in position ~p~n", [I]);
	Any -> io:format("received unknown msg: ~p~n", [Any])
    end.

connect(L=[H|_]) -> 
    connect(H, L).
connect(H, [Pid | []]) ->
    Pid ! {next, H},
    ok;
connect(H, [Pid | Tl=[Pid2 | _]]) ->
    Pid ! {next, Pid2},
    connect(H, Tl).
