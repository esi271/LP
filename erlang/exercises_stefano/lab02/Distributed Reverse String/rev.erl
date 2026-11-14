-module(rev).
-export([start_server/0, reverse/2]).

%server
start_server() ->
    register(server, spawn(fun() -> io:format("Server creato.~n",[]), wait_server() end)),
    ok.

wait_server() ->
    receive
        {long_reverse_string, From, W, M} ->
            From ! {reversed, long_reverse_string(W, M)},
            wait_server();
        Any ->
            io:format("Unknown message: ~p.~n", [Any]),
            wait_server()
    end.

long_reverse_string(W, M) ->
    Slaves = create_slaves(M, []),
    Sub = substrings(W, M),
    forwards(Sub, Slaves),
    lists:append([receive {reversed, Rev, S} -> Rev end || S <- Slaves]).

forwards([W], [S]) -> S ! {reverse, W, self()};
forwards([W | Sub], [S | Slaves]) ->
    S ! {reverse, W, self()},
    forwards(Sub, Slaves).


%SubStrings
substrings(W, M) ->
    Rest = length(W) rem M,
    Div = length(W) div M,
    Ranges = lists:duplicate(Rest, Div + 1) ++ lists:duplicate(M-Rest, Div),
    cut(W, Ranges, []).

cut([], [], Acc) -> Acc;
cut(W, [I | Tl], Acc) ->
    {Part, Rest} = lists:split(I, W),
    cut(Rest, Tl, [Part | Acc]).


%slaves
create_slaves(0, Acc) -> Acc;
create_slaves(M, Acc) ->
    Pid = spawn(fun wait_slave/0),
    create_slaves(M-1, [Pid | Acc]).

wait_slave() ->
    receive
        {reverse, W, Pid} ->
            Pid ! {reversed, lists:reverse(W), self()}
    end.


%client
reverse(W, M) ->
    server ! {long_reverse_string, self(), W, M},
    receive
        {reversed, Rev} -> Rev
    end.