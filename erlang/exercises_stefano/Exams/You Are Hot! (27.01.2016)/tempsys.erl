-module(tempsys).
-export([startsys/0]).

%Conversion
get_scale_atoms() ->
    ['C', 'F', 'K', 'R', 'De', 'N', 'Re', 'Ro'].

get_toC_functions() ->
    [fun toC/1, fun toF/1, fun toK/1, fun toR/1, fun toDe/1, fun toN/1, fun toRe/1, fun toRo/1].

toC(C) -> C.
toF(C) -> (C * 9/5) + 32.
toK(C) -> (C) + 273.15.
toR(C) -> toK(C) * 9/5.
toDe(C) -> (100 - C) * 3/2.
toN(C) -> C * 33 / 100.
toRe(C) -> C * 4 / 5.
toRo(C) -> (C * 21 / 40) + 7.5.

get_from_functions() ->
    [fun fromC/1, fun fromF/1, fun fromK/1, fun fromR/1, fun fromDe/1, fun fromN/1, fun fromRe/1, fun fromRo/1].

%from Tsys to C
fromC(C) -> C.
fromF(F) -> (F - 32) * 5 / 9.
fromK(K) -> K - 273.15.
fromR(R) -> (R * 5 / 9) - 273.15.
fromDe(De) -> 100 - (De * 2 / 3).
fromN(N) -> N * 100 / 33.
fromRe(Re) -> Re * 5 / 4.
fromRo(Ro) -> (Ro - 7.5) * 40 / 21.

%System
startsys() ->
    FromTo = lists:zip(get_scale_atoms(), get_from_functions()),
    To = lists:zip(get_scale_atoms(), get_toC_functions()),
    lists:foreach(
        fun({Atom, Fun}) ->
            Name = list_to_atom("from" ++ atom_to_list(Atom)),
            register(
                Name,
                spawn(fun() -> loop_from_to(Fun) end)
            )
        end,
        FromTo
    ), 
    lists:foreach(
        fun({Atom, Fun}) ->
            Name = list_to_atom("to" ++ atom_to_list(Atom)),
            register(
                Name,
                spawn(fun() -> loop_to(Fun) end)
            )
        end,
        To
    ).

loop_from_to(Fun) ->
    receive 
        {convert, AtomTarget, Val, Client} ->
            AtomTarget ! {convert, Fun(Val), self()},
            receive 
                {converted, _Res} = M->
                    Client ! M,
                    loop_from_to(Fun)
            end;
        Any ->
            io:format("Received ~p.~n", [Any]),
            loop_from_to(Fun)
    end.

loop_to(Fun) ->
    receive
        {convert, N, Pid} ->
            Pid ! {converted, Fun(N)},
            loop_to(Fun);
        Any ->
            io:format("Received ~p.~n", [Any]),
            loop_to(Fun)
    end.