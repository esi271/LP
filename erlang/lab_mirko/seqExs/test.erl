-module(test).
-export([test_palindrome/0, test_anagram/0]).

test(F, L) ->
    lists:foreach(
      fun(X) -> io:format("~p : ~p~n", [X, F(X)]) end,
      L
    ).

test_palindrome() ->
    test(
      fun sequential:is_palindrome/1,
      ["detartrated", "Do geese see God?", "Rise to vote, sir."]
     ).

test_anagram() ->
    test(
      fun (X) -> sequential:is_an_anagram(X, 
	["rat", "cat", "tar", "car", "amongus"]) end,
      ["amongus"]
     ).
