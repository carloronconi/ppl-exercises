% Consider a main process which takes two lists: one of function names, and one of lists of parameters (the first element
% of with contains the parameters for the first function, and so forth). For each function, the main process must spawn
% a worker process, passing to it the corresponding argument list. If one of the workers fails for some reason, the main
% process must create another worker running the same function. The main process ends when all the workers are done.

main(FunList, ArgList) ->
    process_flag(trap_exit, true),
    ChildrenMap = spawn_children(FunList, ArgList, #{}),
    wait_children(length(FunList), ChildrenMap),
    ok.

spawn_children([], _, Map) -> Map;
spawn_children([Fun | RestFun], [Pars, RestPars], Map) ->
    Pid = spawn_link(?MODULE, Func, Pars),
    spawn_children(RestFun, RestPars, Map#{Pid => {Fun, Pars}}).

wait_children(0, _) -> ok;
wait_children(N, Map) ->
    receive
        {’EXIT’, _, normal} ->
            wait_children(N-1, Map);
        {’EXIT’, Child, _} ->
            #{Child := {Fun, Pars}} = Map,
            Pid = spawn_link(?MODULE, Fun, Pars),
            % TODO: delete entry with key child and use that cleaned map below: CleanMap = maps:remove(Child, Map)
            wait_children(N, Map#{Pid => {Fun, Pars})
    end.