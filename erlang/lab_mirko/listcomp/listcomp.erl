-module(listcomp).
-export([squared_int/1, intersect/2, symmetric_difference/2]).

squared_int(L) -> [X*X || X <- L, is_integer(X)].
intersect(List1, List2) -> [X || X <- List1, Y <- List2, X==Y].
symmetric_difference(List1, List2) -> [X || X <- List1++List2, not lists:member(X, intersect(List1, List2))].
