-module(sieve).
-export([init/1]).

init(Prime) ->
    receive
        {max, Pid} -> 
            Pid ! {max, (Prime * Prime)},
            init(Prime);
        {Next, Gateway} ->
            wait(Next, Gateway, Prime)
    end.

wait(Next, Gateway, Prime) ->
    receive
        {new, N} ->
            Gateway ! {pass, N},
            wait(Next, Gateway, Prime);
        {pass, N} when (N rem Prime) == 0 ->
            Gateway ! {res, false},
            wait(Next, Gateway, Prime);
        {pass, N} when (Prime * Prime) > N ->
            Gateway ! {res, true},
            wait(Next, Gateway, Prime);
        {pass, N} ->
            Next ! {pass, N},
            wait(Next, Gateway, Prime);
        {res, R} ->
            controller ! {res, R},
            wait(Next, Gateway, Prime)
    end.
