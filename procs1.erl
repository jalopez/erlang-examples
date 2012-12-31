-module(procs1).
-export([simple_procs/1, send_msg/2, receive_msg/1]).

simple_procs(M) ->
	Other = spawn(procs1, send_msg, [self(), M]),
	receive_msg(Other).

send_msg(To, M) ->
	io:format("~w: Sending message ~w to ~w ~n", [self(), M, To]),
	To ! M,
	receive
		0 ->
			io:format("~w: Last message received. Finishing ~n", [self()]),
			To ! stop;
		M1 ->
			send_msg(To, M1)
	end.

receive_msg(From) ->
	receive	
		stop ->
			io:format("~w: Finishing process ~n", [self()]);
		M ->
			io:format("~w: Received message ~w ~n", [self(), M]),
			From ! M - 1,
			receive_msg(From)
	end.
		
