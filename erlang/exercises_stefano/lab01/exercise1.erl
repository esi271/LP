-module(exercise1).
-export([is_palindrome/1, is_an_anagram/2, factors/1, is_proper/1]).

% is_palindrome: string → bool 
% that checks if the string given as input is palindrome, a string is palindrome when 
% the represented sentence can be read the same way in either directions in spite of spaces, punctual and letter cases

filter([], _) -> [];
filter(L, F) -> filter(L, F, []).

filter([H | Tl], F, Acc) -> filter( F(H), H, Tl, F, Acc);
filter("", _,  Acc) -> lists:reverse(Acc).

filter(true, H, Tl, F, Acc) -> filter(Tl, F, [H | Acc]);
filter(false, _, Tl, F, Acc) -> filter(Tl, F, Acc).

reverse("") -> "";
reverse(S) -> reverse(S, "").

reverse("", Acc) -> Acc;
reverse([H | Tl], Acc) -> reverse(Tl, [H | Acc]).

is_palindrome(S) ->
    Check = fun(C) when (C /= $. andalso C /= $, andalso C /= $; andalso C /= $: andalso C /= $? andalso C /= $! andalso C /= 32) -> true;
               (_) -> false
            end,
    Pulita = string:to_lower(filter(S, Check)),
    Pulita == reverse(Pulita).

% is_an_anagram : string → string list → boolean 
% that given a dictionary of strings, checks if the input string is an anagram of one or more of the strings in the dictionary;

sort([]) -> [];
sort([H | Tl]) -> 
    sort([X || X <- Tl, X =< H])
    ++
    [H]
    ++
    sort([X || X <- Tl, X > H]).

is_an_anagram(S, [H | Tl]) -> is_an_anagram(sort(S) == sort(H), S, Tl);
is_an_anagram(_, []) -> false.

is_an_anagram(true, _, _) -> true;
is_an_anagram(false, S, Tl) -> is_an_anagram(S, Tl).

% factors: int → int list 
% that given a number calculates all its prime factors

is_prime(N) when (N >= 2) -> is_prime(N, 2);
is_prime(_) -> false.

is_prime(N, D) when (D * D =< N) -> is_prime(N rem D == 0, N, D);
is_prime(_, _) -> true.

is_prime(true, _, _) -> false;
is_prime(false, N, D) -> is_prime(N, D+1).

factors(N) -> [X || X <- lists:seq(2, N), (N rem X == 0), is_prime(X)].

% is_proper: int → boolean 
% that given a number calculates if it is a perfect number or not, 
% where a perfect number is a positive integer equal to the sum of its proper positive divisors (excluding itself), 
% e.g., 6 is a perfect number since 1, 2 and 3 are the proper divisors of 6 and 6 is equal to 1+2+3;

sum([]) -> 0;
sum([H | Tl]) -> sum(Tl, H).

sum([], Acc) -> Acc;
sum([H | Tl], Acc) -> sum(Tl, Acc + H).

is_proper(N) when N > 0 ->
    Pd = [X || X <- lists:seq(1, (N-1)), (N rem X == 0)],
    N == sum(Pd);
is_proper(_) -> false.