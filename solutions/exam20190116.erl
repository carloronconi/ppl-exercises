-module(exam20190116).
-compile(export_all).

% Define a process P, having a local behavior (a function), that answer to three commands:
% - load is used to load a new function f on P: the previous behavior is composed with f;
% - run is used to send some data D to P: P returns its behavior applied to D;
% - stop is used to stop P.For security reasons, the process must only work with messages coming
% from its creator: other messages must be discarded.

process(Behavior, Creator) ->
    receive
        {load, Func, Creator} ->
            process(fun (X) -> Func(Behavior(X)) end, Creator);
        {run, Data, Creator} ->
            Creator ! {Behavior(Data)},
            process(Behavior, Creator);
        {stop, Creator} ->
            ok;
        _ -> process(Behavior, Creator) % add this line to discard, not sure it was necessary (tested below with
                                        % testEnemy and it was already working fine)
    end.

testEnemy(P) -> P ! {run, 2, self()}.

run() ->
    Self = self(),
    P = spawn(?MODULE, process, [fun (X) -> X + 1 end, Self]),
    spawn(?MODULE, testEnemy, [P]),
    P ! {load, fun (X) -> X * 2 end, Self},
    P ! {run, 3, Self},
    receive
        {Res} -> io:format("~p~n", [Res])
    end,
    P ! {stop, Self},
    ok.