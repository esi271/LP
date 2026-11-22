-module(client).
-export([is_prime/1, close/0]).

is_prime(N) ->
    send_msg({new, N, self()}).

close() ->
    send_msg({quit, self()}).

send_msg(M) ->
    {controller, 'sif@MirkoLaptop'} ! M,
    receive
	{result, R} -> io:format("~p~n", [R]);
	Any -> io:format("Unexpected msg received: ~p~n", [Any])
    end.
