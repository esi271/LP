-module(generator).
-export([spawn_slave/3]).

spawn_slave(RowsToGenerate, NumRepetition, Element) ->
    io:format("Spawn slave with NumRepetition = ~p.~n", [NumRepetition]),
    spawn(
        fun() ->
            generate(RowsToGenerate, NumRepetition, Element, 1)
        end
    ).

send(RowsToGenerate, 1, Element) ->
    master ! {from, self(), rows_to_generate, RowsToGenerate - 1, element, Element};

send(RowsToGenerate, RepsToDo, Element) ->
    master ! {from, self(), rows_to_generate, RowsToGenerate - 1, element, Element},
    send(RowsToGenerate - 1, RepsToDo - 1, Element).


generate(RepsToDo, RepsToDo, _MaxElement, CurrentElement) ->
    send(RepsToDo, RepsToDo, CurrentElement);

generate(RowsToGenerate, RepsToDo, MaxElement, MaxElement) ->
    send(RowsToGenerate, RepsToDo, MaxElement),
    generate(RowsToGenerate - RepsToDo, RepsToDo, MaxElement, 1);

generate(RowsToGenerate, RepsToDo, MaxElement, CurrentElement) ->
    send(RowsToGenerate, RepsToDo, CurrentElement),
    generate(RowsToGenerate - RepsToDo, RepsToDo, MaxElement, CurrentElement + 1).

