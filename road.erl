-module(road).
-compile(export_all).

main() ->
    File = "road.txt",
    {ok, Bin} = file:read_file(File),
    List = parse_map(Bin),
    optimal_path(List).

parse_map(Bin) when is_binary(Bin) ->
    parse_map(binary_to_list(Bin));
parse_map(List) when is_list(List) ->
    L = [list_to_integer(X) || X <- string:tokens(List, "\r\n\t ")],
    group_values(L, []).

group_values([], Acc) ->
    lists:reverse(Acc);
group_values([A,B,X|Tail], Acc) ->
    group_values(Tail, [{A,B,X}|Acc]).

shortest_step({A,B,X}, {{DistA, PathA}, {DistB, PathB}}) ->
    OptionA1 = {DistA + A, [{a, A} | PathA]},
    OptionA2 = {DistB + B + X, [{x, X}, {b, B} | PathB]},
    OptionB1 = {DistB + B, [{b, B} | PathB]},
    OptionB2 = {DistA + A + X, [{x, X}, {a, A} | PathA]},
    {min(OptionA1, OptionA2), min(OptionB1, OptionB2)}.

optimal_path(List) ->
    {{DistA, PathA}, {DistB, PathB}} = lists:foldl(fun shortest_step/2, {{0, []}, {0, []}}, List),
    {{DistA, lists:reverse(PathA)}, {DistB, lists:reverse(PathB)}}.
