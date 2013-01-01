-module(rpn).
-export([rpn/1]).

rpn(L) when is_list(L) ->
    [Res] = lists:foldl(fun rpn/2, [], L),
    Res.

rpn("+", [F,S|T]) -> [S+F|T];
rpn("-", [F,S|T]) -> [S-F|T];
rpn("*", [F,S|T]) -> [S*F|T];
rpn("/", [F,S|T]) -> [S/F|T];

rpn(N, L) -> [N|L].


