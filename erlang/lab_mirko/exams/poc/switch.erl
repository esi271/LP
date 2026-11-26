-module(switch).
-export([init/2]).

init(I, Node) ->
    loop(I, Node).

loop(I, Node) ->
    receive
	{send, Msg, Seq, T} when Seq == 0 ->
	{send, Msg, Seq, T} when Seq > T ->
	{send, Msg, Seq, T} ->
	    {receiver, Node} !  {send, Msg, Seq},
	    io:format("The switch #~p is routing the message \"~p\"~n", [I, Msg]),
	    loop(I, Node);
	Any -> io:format("### ERROR: ~p~n", [Any]), loop(I, Node)
    end.
