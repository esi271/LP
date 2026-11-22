-module(client).
-export([convert/5]).

convert(from, Source, to, Target, Val) ->
    AtomSource = list_to_atom("from" ++ atom_to_list(Source)),
    AtomTarget = list_to_atom("to" ++ atom_to_list(Target)),
    AtomSource ! {convert, AtomTarget, Val, self()},
    receive
        {converted, Res} ->
            io:format("~p°~s are equivalent to ~p°~s.~n", [Val, atom_to_list(Source), Res, atom_to_list(Target)])
    end.
