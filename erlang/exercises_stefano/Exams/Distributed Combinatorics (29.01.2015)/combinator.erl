-module(combinator).
-export([start/2]).

% permutation of m possible values took n by n with repetitions
% table of permutation has: n columns, m^n rows

start(N, M) ->
    NumRows = trunc(math:pow(M,N)),
    register(
        master,
        spawn(
            fun() ->
                Slaves = init_slaves(NumRows, N, M),
                get_permutation(NumRows-1, lists:reverse(Slaves))
            end
        )
    ).

init_slaves(NumRows, N, M) ->
    [generator:spawn_slave(NumRows, trunc(math:pow(M,L)), M) || L <- lists:seq(N-1, 0, -1)].

get_messages(_, [], Acc) ->
    Row = string:join(lists:map(fun(E) -> integer_to_list(E) end, Acc), ", "),
    io:format("~s~n", [Row]);

get_messages(RowsToGenerate, [Slave | S], Acc) ->
    receive
        {from, Slave, rows_to_generate, RowsToGenerate, element, Element} ->
            get_messages(RowsToGenerate, S, [Element | Acc])
    end.

get_permutation(0, Slaves) ->
    get_messages(0, Slaves, []);

get_permutation(RowsToGenerate, Slaves) ->
    get_messages(RowsToGenerate, Slaves, []),
    get_permutation(RowsToGenerate-1, Slaves).