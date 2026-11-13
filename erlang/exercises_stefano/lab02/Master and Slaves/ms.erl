-module(ms).
-export([start/1, to_slave/2]).

start(N) ->
    register(master, spawn(fun() -> init(N) end)).

to_slave(Message, N) ->
    master ! {msg, Message, N}.

create_slaves(0, Acc) -> lists:reverse(Acc);
create_slaves(N, Acc) ->
    Pid = spawn_link(fun slave_wait/0),
    create_slaves(N-1, [{N, Pid} | Acc]).

init(N) ->
    process_flag(trap_exit, true),
    Dict = create_slaves(N, []),
    master_wait(Dict).

get(N, [{N, Pid} | _]) -> Pid;
get(N, [_ | Tl]) -> get(N, Tl).

get_N(Pid, [{N, Pid} | _]) -> N;
get_N(Pid, [_| Tl]) -> get_N(Pid, Tl).

replace_N(N, Pid, [{N, _} | Tl], Acc) ->
    lists:reverse([{N, Pid} | Acc], Tl);
replace_N(N, Pid, [{N1, Pid1} | Tl], Acc) ->
    replace_N(N, Pid, Tl, [{N1, Pid1} | Acc]).

master_wait(Dict) ->
    receive
        {msg, Msg, N_slave} when N_slave >= 1, N_slave =< length(Dict) ->
            get(N_slave, Dict) ! {msg, Msg, N_slave},
            master_wait(Dict);
        {msg, _, N_slave} ->
            io:format("invalid slave number ~p.~n", [N_slave]),
            master_wait(Dict);
        {'EXIT', Pid, _} ->
            N = get_N(Pid, Dict),
            io:format("master restarting dead slave~p.~n", [N]),
            New_dict = replace_N(N, spawn_link(fun slave_wait/0), Dict, []),
            master_wait(New_dict);
        Any ->
            io:format("Unknown message: ~p.~n", [Any]),
            master_wait(Dict)
    end.


slave_wait() ->
    receive 
        {msg, die, _} ->
            exit(kill);
        {msg, Content, N} -> 
            io:format("Slave ~p got message: ~p.~n", [N, Content]),
            slave_wait();
        Any ->
            io:format("Unknown message: ~p.~n", [Any]),
            slave_wait()
    end.