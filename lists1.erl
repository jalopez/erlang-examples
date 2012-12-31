-module(lists1).
-export([min/1, max/1, min_max/1, min_max2/1]).


min([]) -> {error};
min([H|T]) -> min(T, H).

min([], Min) -> Min;
min([H|T], Min) when H < Min ->
	min(T, H);
min([H|T], Min) -> 
	min(T, Min). 

max([]) -> {error};
max([H|T]) -> max(T, H).

max([], Max) -> Max;
max([H|T], Max) when H > Max ->
	max(T, H);
max([H|T], Max) -> 
	max(T, Max).

% Min Max with accumulators
min_max([H|T]) -> min_max(T, H, H).

min_max([], Min, Max) -> {Min, Max};
min_max([H|T], Min, Max) when H < Min ->
	min_max(T, H, Max);
min_max([H|T], Min, Max) when H > Max ->
	min_max(T, Min, H);
min_max([H|T], Min, Max) ->
	min_max(T, Min, Max).

% Min Max using separate functions
min_max2(L) -> {min(L), max(L)}.
