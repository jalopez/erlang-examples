-module(ring).
-export([start_ring/2, process_first/1, process_loop/1]).

start_ring(P, M) ->
	First = make_ring(P),
	start_send(First, M).

make_ring(P) when P > 1 ->
	First = spawn(ring, process_first, [none]),
	io:format("Creating Process ~w: id ~w. next ~w~n", [P, First, none]),
	make_ring(P - 1, First, First),
	First.

make_ring(0, First, Next) ->
	First ! {set_next, Next};

make_ring(N, First, Next) ->
	Pid = spawn(ring, process_loop, [Next]),
	io:format("Creating Process ~w: id ~w. next ~w~n", [N, Pid, Next]),
	make_ring(N - 1, First, Pid).

start_send(First, M) ->
	First ! {start_messages, M}.

process_first(Next) ->
	receive
		{set_next, NextPid} ->
			io:format("Setting next to process ~w. next ~w~n", [self(), NextPid]),
			process_first(NextPid);
		{start_messages, M} ->
			io:format("~w: Start sending messages~n", [self()]),
			Next ! {message, M},
			process_first(Next);
		{message, 1} ->
			io:format("~w: Received message ~w~n", [self(), 1]),
			io:format("~w: Message loop finished, stopping processes~n", [self()]),
			io:format("~w: Stopping~n", [self()]),		
			Next ! stop;
		{message, M} ->
			io:format("~w: Received message ~w~n", [self(), M]),
			Next ! {message, M - 1},
			process_first(Next)
	end.

process_loop(Next) ->
	receive
		{message, M} ->
			io:format("~w: Received message ~w~n", [self(), M]),
			Next ! {message, M},
			process_loop(Next);
		stop ->
			io:format("~w: Stopping~n", [self()]),		
			Next ! stop
	end.
