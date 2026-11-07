-module(exercise2).
-export([parse/1, evaluator/1]).

op($+) -> plus;
op($-) -> minus;
op($*) -> mul.

parse(S) ->
    {E, []} = expr(S),
    E.

expr([$~ | Tl]) -> 
    {E, R} = expr(Tl),
    {{neg, E}, R};

expr([$( | Tl]) ->
    {L, [Op | R1]} = expr(Tl),
    {R, [$) | R2]} = expr(R1),
    {{op(Op), L, R}, R2};

expr([H | Tl]) ->
    {{num, list_to_integer([H])}, Tl}.

evaluator({}) -> 0;

evaluator({num, N}) ->
    N;

evaluator({plus, E1, E2}) ->
    evaluator(E1) + evaluator(E2);

evaluator({minus, E1, E2}) ->
    evaluator(E1) - evaluator(E2);

evaluator({mul, E1, E2}) ->
    evaluator(E1) * evaluator(E2);

evaluator({neg, E1}) ->
    - evaluator(E1).