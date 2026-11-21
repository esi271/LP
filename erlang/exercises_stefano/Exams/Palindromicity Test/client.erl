-module(client).
-export([start/0, close/0, is_palindrome/1]).

get_fullname_node(Name)->
    list_to_atom(string:join([Name, "@", net_adm:localhost()], "")).

init_system([M1, M2, S]) ->
    PidS = server:spawn_server(S),
    MM1 = mm:spawn_mm(M1, PidS),
    MM2 = mm:spawn_mm(M2, PidS),
    PidS ! {self(), mm1, MM1, mm2, MM2},
    receive
        {ready} ->
            io:format("The system is ready.~n", [])
    end.

start() ->
    Nodes = [get_fullname_node(N) || N <- ["mm1", "mm2", "server"]],
    Down = [D || D <- Nodes, net_adm:ping(D) == pang],
    case Down of
        [] ->
            io:format("Faccio spawn.~n", []),
            init_system(Nodes);
        _ ->
            io:format("The nodes: ~p aren't responding.~n", [Down])
    end.

is_palindrome(Word) when length(Word) rem 2 == 0 ->
    L = length(Word),
    Dim = length(Word) div 2,
    S1 = string:sub_string(Word, 1, Dim),
    S2 = string:sub_string(Word, Dim + 1, L),
    Ref = make_ref(),
    {mm, get_fullname_node("mm1")} ! {Word, palindrome, S1, Ref},
    {mm, get_fullname_node("mm2")} ! {Word, palindrome, lists:reverse(S2), Ref};
is_palindrome(Word) ->
    L = length(Word),
    Dim = L div 2,
    S1 = string:sub_string(Word, 1, Dim + 1),
    S2 = string:sub_string(Word, Dim + 1, L),
    Ref = make_ref(),
    {mm, get_fullname_node("mm1")} ! {Word, palindrome, S1, Ref},
    {mm, get_fullname_node("mm2")} ! {Word, palindrome, lists:reverse(S2), Ref}.

close() ->
    {mm, get_fullname_node("mm1")} ! {close}, 
    {mm, get_fullname_node("mm2")} ! {close},
    io:format("Closing the whole system.~n", []).