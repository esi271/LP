-module(generator).
-export([create/3]).

create(M, N, Col) ->
    counter(1, trunc(math:pow(M, N-Col)), trunc(math:pow(M,N)), 1, M, N, Col).

% counter(Seq, Tick, Max, Val, M, N, Col)
counter(Seq, _, Max, _, _, _, _) when Seq > Max -> stop;
counter(Seq, _, Max, Val, M, N, Col) when Val > M ->
    counter(Seq, trunc(math:pow(M,N-Col)), Max, 1, M, N, Col);
counter(Seq, 1, Max, Val, M, N, Col) ->
    combinator_master ! {Seq, Col, Val},
    counter(Seq+1, trunc(math:pow(M,N-Col)), Max, Val+1, M, N, Col);
counter(Seq, Tick, Max, Val, M, N, Col) ->
    combinator_master ! {Seq, Col, Val},
    counter(Seq+1, Tick-1, Max, Val, M, N, Col).


