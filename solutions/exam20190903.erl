-module(exam20190903).
-compile(export_all).

% 1) Define a split function, which takes a list and a number n and returns a pair of lists, where the first one is the
% prefix of the given list, and the second one is the suffix of the list of length n.
% E.g. split([1,2,3,4,5], 2) is
% {[1,2,3],[4,5]}.
% 2) Using split of 1), define a splitmap function which takes a function f, a list L, and a value n,
% and splits L with parameter n, then launches two process to map f on each one of the two lists resulting from the
% split. The function splitmap must return a pair with the two mapped lists.

% 1) CORRECT: took a while, very different from solution but works
split(List, SufLen) -> split(SufLen, [], List).

split(SufLen, Pre, Suf) ->
    if
        SufLen == length(Suf) -> {Pre, Suf};
        true ->
            [First | Rest] = Suf,
            split(SufLen, Pre ++ [First], Rest)
    end.

% 2) CORRECT: faster and same as solution
mapProc(List, Func, Who) ->
    Who ! {self(), lists:map(Func, List)}.

splitMap(Func, List, SufLen) ->
    {Pre, Suf} = split(List, SufLen),
    Self = self(),
    P1 = spawn(?MODULE, mapProc, [Pre, Func, Self]),
    P2 = spawn(?MODULE, mapProc, [Suf, Func, Self]),
    receive
        {P1, Res1} ->
            receive
                {P2, Res2} -> {Res1, Res2}
            end
    end.

% c(exam20190903).
% exam20190903:splitMap(fun (X) -> X + 1 end, [1, 2, 3, 4, 5], 2).