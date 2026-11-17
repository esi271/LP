-module(ms).
-export([start/1, to_slave/2]).

start(N) -> 
    register(master, spawn(fun() -> init(N) end)). 

init(N) ->
    process_flag(trap_exit, true),
    Slaves = create_slaves(N),
    loop_master(Slaves).

create_slaves(N) -> create_slaves(N, []).
create_slaves(0, Acc) ->
    lists:reverse(Acc);
create_slaves(N, Acc) ->
    Pid = spawn_link(fun loop_slave/0),
    create_slaves(N-1, [{N, Pid}|Acc]).

to_slave(Msg, N) -> 
    master ! {Msg, N}.

loop_slave() ->
    receive
	{die} -> exit(kill);
	{Msg, N} -> io:format("Slave ~p got message ~p~n", [N, Msg]), loop_slave();
	Any -> io:format("Slave received unexpected msg ~p~n", [Any])
    end.

get(N, [{N, Pid}|_]) -> Pid;
get(N, [_|Tl]) -> get(N, Tl).

get_n(Pid, [{N, Pid}|_]) -> N;
get_n(Pid, [_|Tl]) -> get_n(Pid, Tl).

replace_n(N, Slaves) -> 
    NewS = lists:delete(N, Slaves),
    Pid = spawn_link(fun loop_slave/0),
    [Pid | NewS].

loop_master(Slaves) ->
    receive
	{die, N} -> 
	    get(N, Slaves) ! {die},
	    io:format("master restarting dead slave ~p~n", [N]),
	    loop_master(Slaves);
	{Msg, N} ->
	    get(N, Slaves) ! {Msg, N},
	    loop_master(Slaves);
	{'EXIT', Pid, Why}  -> 
	    io:format("Slave ~p died, ~p~n", [Pid, Why]),
	    N = get_n(Pid, Slaves),
	    NewSlaves = replace_n(N, Slaves),
	    loop_master(NewSlaves);
	Any -> io:format("Master received unknown msg ~p~n", [Any])
    end.
