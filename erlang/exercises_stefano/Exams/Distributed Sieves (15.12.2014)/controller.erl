-module(controller).
-export([start/1]).

% is prime 
check(N, Div) when (Div * Div) > N -> true;
check(N, Div) when (N rem Div) == 0 -> false;
check(N, Div) -> check(N, Div+1).

is_prime(N) when N =< 1 -> false;
is_prime(N) ->
    check(N, 2).

%init_ring
init_ring(Primes) ->
    %spawn_link: se controller muore -> ring muore e viceversa
    [Head | Tl] = [spawn_link(sieve, init, [L]) || L <- Primes],
    connect([Head | Tl], Tl ++ [Head], Head).

connect([Pid], [Next], Gateway) ->
    Pid ! {max, self()},
    receive
        {max, Max} ->
            Pid ! {Next, Gateway},
            wait(Gateway, Max)
    end;
connect([Pid | Members], [Next | Neighbors], Gateway) ->
    Pid ! {Next, Gateway},
    connect(Members, Neighbors, Gateway).

%controller
start(Range) ->
    Primes = lists:filter(fun is_prime/1, lists:seq(2, Range)),
    register(controller, spawn(fun() -> init_ring(Primes) end)).

wait(Head, Max) ->
    receive
        {new, N, From} when N >= Max ->
            io:format("You asked for: ~p~n", [N]),
            From ! {uncheckable},
            wait(Head, Max);
        {new, N, From} ->
            io:format("You asked for: ~p~n", [N]),
            Head ! {new, N},
            receive
                {res, R} -> 
                    From ! {result, R},
                    wait(Head, Max)
            end;
        {quit, From} ->
            io:format("I'm closing ...~n"),
            From ! {closed};
        Any -> 
            io:format("Ricevuto: ~p~n", [Any]),
            wait(Head, Max)
    end.