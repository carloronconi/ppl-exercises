-module(exam20190724).
-compile(export_all).

% Define a master process which takes a list of nullary (or 0-arity) functions, and starts a worker process for each of
% them. The master must monitor all the workers and, if one fails for some reason, must re-start it to run the same code
% as before. The master ends when all the workers are done.
% Note: for simplicity, you can use the library function spawn_link/1, which takes a lambda function, and spawns and
% links a process running it.

create_workers([]) -> [];
create_workers([Func | Next]) ->
    [spawn_link(fun () -> Func() end) | create_workers(Next)].

% took inspiration from the internet but did it myself!
index_of(List, Elm) -> index_of(List, Elm, 1).

index_of([], _, _) -> not_found;
index_of([Elm | _], Elm, Index) -> Index;
index_of([_ | Next], Elm, Index) -> index_of(Next, Elm, Index + 1).


master_loop(Count, Workers, NullaryFunctions) ->
    receive
        {'EXIT', Child, normal} ->
            io:format("child ~p has ended ~n", [Child]),
            if
                Count =:= 1 -> ok; % this was the last
                true -> master_loop(Count-1, Workers, NullaryFunctions)
            end;
        {'EXIT', Child, _} -> % child failure
            Index = index_of(Workers, Child),
            Func = lists:nth(Index, NullaryFunctions),
            NewChild = spawn_link(fun () -> Func() end), % forgot to swap out new child in Workers so if new worker fails it doesn't get replaced!
            io:format("child ~p has died, now replaced by ~p ~n", [Child, NewChild]),

            {HeadList, [_|TailList]} = lists:split(Index-1, Workers), % building the new list here, probably couldn't have done it without the internet
            master_loop(Count, lists:append([HeadList, [NewChild|TailList]]), NullaryFunctions)
    end.

master(NullaryFunctions) ->
    process_flag(trap_exit, true),
    Workers = create_workers(NullaryFunctions),
    master_loop(length(Workers), Workers, NullaryFunctions),
    ok.

% TEST:
% exam20190724:master([fun () ->  io:fwrite("Hello world!~n", []) end, fun () ->  io:fwrite("Hello world 2!~n", []) end, fun () ->  io:fwrite("Hello world 3!~n", []) end]).
% > terminates correctly
% exam20190724:master([fun () ->  io:fwrite("Hello world!~n", []) end, fun () ->  io:fwrite("Hello world 2!~n", []) end, fun () ->  io:fwrite("Hello world 3!~n", []) end, fun () -> 4 / 0 end]).
% > keeps replacing last failing child correctly
