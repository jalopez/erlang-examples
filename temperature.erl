-module(temp).
-export([convert/1]).

convert({c, T}) -> {f, c2f(T)};
convert({f, T}) -> {c, f2c(T)}.

f2c(F) ->
	5 * (F - 32) / 9.

c2f(C) ->
	((9 * C) / 5) + 32.
