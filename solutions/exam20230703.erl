-module(exam20230703).
-compile(export_all).

% Done during exercise session, I followed along and then re-did it
% 1. Define a “deep reverse” function, which takes a “deep” list, i.e. a list containing possibly lists of any depths,
%    and returns its reverse.E.g. deeprev([1,2,[3,[4,5]],[6]]) is [[6],[[5,4],3],2,1].
% 2. Define a parallel version of the previous function.

% 1.
deeprev([X | Xs]) -> deeprev(Xs) ++ [deeprev(X)];
deeprev(X) -> X.

% 2.
deeprevp(List) ->
    Self = self(),
    drp(Self, List),
    receive
        {Self, Res} -> Res
    end.

drp(Back, [X | Xs]) ->
    Self = self(),
    PX = spawn(fun() -> drp(Self, X) end),
    PXs = spawn(fun() -> drp(Self, Xs) end),
    receive
        {PX, R} ->
            receive
                {PXs, Rs} -> Back ! {Self, Rs ++ [R]}
            end
    end;

drp(Back, X) ->
    Back ! {self(), X}.