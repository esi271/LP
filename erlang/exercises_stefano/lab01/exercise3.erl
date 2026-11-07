-module(exercise3).
-export([start/3, start2/3]).

% The first one is to have a central process that sets up the ring and initiates sending the message.
% uso la shel come central process

loop(Pid, P) ->
    receive
        {N, Mess, 0} ->
            io:format("~p: messaggio ~p (~p), TTL 0, il giro e' completo, avviso la shell.~n",[self(), N, Mess]),
            P ! {continue},
            loop(Pid, P);
        {N, Mess, Tl} ->
            io:format("~p: messaggio ~p (~p), TTL ~p, inoltro a ~p.~n",[self(), N, Mess, Tl, Pid]),
            Pid ! {N, Mess, (Tl-1)},
            loop(Pid, P);
        {quit} ->
            io:format("~p: ricevuto quit, lo inoltro a ~p e termino.~n",[self(), Pid]),
            Pid ! {quit}
    end.

set_ring(0, Acc) ->
    lists:reverse(Acc);
set_ring(N, Acc) ->
    E = spawn(fun() ->
        receive
            {Pid, P} ->
                io:format("~p: il mio successivo e' ~p.~n", [self(), Pid]),
                loop(Pid, P)
        end
    end),
    io:format("Creato processo ~p.~n", [E]),
    set_ring((N-1), [E | Acc]).

connect([P1], [P2]) ->
    P1 ! {P2, self()};
connect([P1 | Tl1], [P2 | Tl2]) ->
    P1 ! {P2, self()},
    connect(Tl1, Tl2).

send(1, Message, Tl, H) ->
    io:format("Shell: invio l'ultimo messaggio (1) a ~p.~n", [H]),
    H ! {1, Message, Tl},
    receive
        {continue} ->
            io:format("Shell: ultimo giro finito, mando quit.~n"),
            H ! {quit}
    end;
send(M, Message, Tl, H) ->
    io:format("Shell: invio il messaggio ~p a ~p.~n", [M, H]),
    H ! {M, Message, Tl},
    receive
        {continue} ->
            io:format("Shell: giro ~p finito, passo al prossimo.~n", [M]),
            send((M-1), Message, Tl, H)
    end.

start(M, N, Message) ->
    [H | Tl] = set_ring(N, []),
    connect([H | Tl], (Tl ++ [H])),
    send(M, Message, N, H).


% The second strategy consists of the new process spawning the next process in the ring. 
% With this strategy, you have to find a method to connect the first process to the second process.
loop2(Pid) ->
    receive
        {N, Mess, 0} ->
            io:format("~p: messaggio ~p (~p), TTL 0, il giro e' completo.~n",[self(), N, Mess]),
            loop2(Pid);
        {N, Mess, Tl} ->
            io:format("~p: messaggio ~p (~p), TTL ~p, inoltro a ~p.~n",[self(), N, Mess, Tl, Pid]),
            Pid ! {N, Mess, (Tl-1)},
            loop2(Pid);
        {quit} ->
            io:format("~p: ricevuto quit, lo inoltro a ~p e termino.~n",[self(), Pid]),
            Pid ! {quit}
    end.

set_ring2(1, First) ->
    spawn(fun() -> 
        loop2(First) 
    end);
set_ring2(N, First) ->
    spawn(fun() -> 
        loop2(set_ring2(N-1, First))
    end).

%spawna primo processo
set_ring2(N) ->
    spawn(fun() -> 
        %pid del primo processo
        Pid = self(),
        loop2(set_ring2(N-1, Pid)) 
    end).

send2(0, _, _, H) ->
    io:format("Shell: invio quit a ~p.~n", [H]),
    H ! {quit};
send2(M, Message, Tl, H) ->
    io:format("Shell: invio il messaggio ~p a ~p.~n", [M, H]),
    H ! {M, Message, Tl},
    send2((M-1), Message, Tl, H).

start2(M, N, Message) ->
    H = set_ring2(N),
    send2(M, Message, N, H).