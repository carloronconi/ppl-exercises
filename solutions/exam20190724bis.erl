-module(exam20190724bis).
-compile(export_all).

% Define a master process which takes a list of nullary (or 0-arity) functions, and starts a worker process for each of
% them. The master must monitor all the workers and, if one fails for some reason, must re-start it to run the same code
% as before. The master ends when all the workers are done.
% Note: for simplicity, you can use the library function spawn_link/1, which takes a lambda function, and spawns and
% links a process running it.

create_workers(Func) -> create_workers(Func, #{}).

create_workers([], Map) -> Map;
create_workers([Func | Next], Map) ->
    Pid = spawn_link(Func), % no need for lambda using only Func
    create_workers(Next, Map#{Pid => Func}).


master_loop(Count, WorkerFuncMap) ->
    receive
        {'EXIT', Child, normal} ->
            io:format("child ~p has ended ~n", [Child]),
            if
                Count =:= 1 -> ok; % this was the last
                true -> master_loop(Count-1, WorkerFuncMap)
            end;
        {'EXIT', Child, _} -> % child failure
            #{Child := Func} = WorkerFuncMap,
            NewChild = spawn_link(Func),
            io:format("child ~p has died, now replaced by ~p ~n", [Child, NewChild]),
            CleanMap = maps:remove(Child, WorkerFuncMap), % prof solution doesn't remove old child, I found this on official documentation to do it
            master_loop(Count, CleanMap#{NewChild => Func})
    end.

master(NullaryFunctions) ->
    process_flag(trap_exit, true),
    WorkerFuncMap = create_workers(NullaryFunctions),
    master_loop(length(NullaryFunctions), WorkerFuncMap),
    ok.

% TEST:
% exam20190724:master([fun () ->  io:fwrite("Hello world!~n", []) end, fun () ->  io:fwrite("Hello world 2!~n", []) end, fun () ->  io:fwrite("Hello world 3!~n", []) end]).
% > terminates correctly
% exam20190724:master([fun () ->  io:fwrite("Hello world!~n", []) end, fun () ->  io:fwrite("Hello world 2!~n", []) end, fun () ->  io:fwrite("Hello world 3!~n", []) end, fun () -> 4 / 0 end]).
% > keeps replacing last failing child correctly
