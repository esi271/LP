-module(sequential).
-export([is_palindrome/1, is_an_anagram/2, factors/1, is_proper/1]).

is_palindrome(S) ->
    L = string:casefold(lists:filter(fun(X) -> not lists:member(X, [$., $,, $:, $?, 32]) end, S)),
    string:equal(string:reverse(L), L).

is_an_anagram(S, Dict) -> 
    SortedS =  lists:sort(S),
    lists:search(fun(X) -> string:equal(SortedS, lists:sort(X)) end, Dict).

is_prime(N) -> is_prime(N, N div 2).
is_prime(_, C) when C < 0 -> false;
is_prime(_, C) when C =< 2 -> true;
is_prime(N, C) when N rem C == 0 -> false;
is_prime(N, C) -> is_prime(N, C-1).

primes(N) -> primes(N, [], 2).
primes(N, L, C) when C > N -> L;
primes(N, L, C) -> 
    case is_prime(C) of
	true -> primes(N, [C|L], C+1);
	false -> primes(N, L, C+1)
    end.

factors(N) -> factors(N, [], primes(N div 2)).
factors(_, L, []) -> L;
factors(N, L, [N|_]) -> [N|L];
factors(N, L, [H|_] = T) when N rem H == 0 -> factors(N div H, [H|L], T);
factors(N, L, [_|Tl]) -> factors(N, L, Tl).

is_proper(N) ->
    L = [Y || Y <- lists:seq(1, N-1), N rem Y == 0],
    lists:sum(L) == N.
