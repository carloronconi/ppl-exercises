-module(exam20200207).
-compile(export_all).

% We want to create a simplified implementation of the “Reduce” part of the MapReduce paradigm. To this end, define a
% process “reduce_manager” that keeps track of a pool of reducers. When it is created, it stores a user-defined
% associative binary function ReduceF. It receives messages of the form {reduce, Key, Value}, and forwards them to a
% different “reducer” process for each key, which is created lazily (i.e. only when needed). Each reducer serves
% requests for a unique key. Reducers keep into an accumulator variable the result of the application of ReduceF to the
% values they receive. When they receive a new value, they apply ReduceF to the accumulator and the new value, updating
% the former. When the reduce_manager receives the message print_results, it makes all its reducers print their key and
% incremental result.
%
% For example, the following code (where the meaning of string:split should be clear from the context):
% word_count(Text) -> RMPid = start_reduce_mgr(fun (X, Y) -> X + Y end),
%                     lists:foreach(
%                           fun (Word) -> RMPid ! {reduce, Word, 1} end,
%                           string:split(Text, " ", all)),
%                     RMPid ! print_results,
%                     ok.
%
% causes the following print:
% 1> mapreduce:word_count("sopra la panca la capra campa sotto la panca la capra crepa").
% sopra: 1
% la: 4
% panca: 2
% capra: 2
% campa: 1
% sotto: 1
% crepa: 1
% ok


% MAPS
% Map = #{key => 0}.
% Updated = Map#{key := 1}.
% #{key := Value} = Updated.
% Value =:= 1.
% %=> true

start_reduce_mgr(ReduceF) ->
    spawn(fun () -> run_mgr(ReduceF, #{}) end).

run_mgr(ReduceF, ReducersMap) ->
    receive
        {reduce, Key, Num} ->
            % if reducer for Key not present, spawn it by passing ReduceF and add its id to ReducersMapUpdated
            case maps:find(Key, ReducersMap) of
                {K, ReducerId} -> ReducersMapUpdated = ReducersMap;
                _ ->
                    RedId = spawn(fun () -> run_reducer(ReduceF, 0) end),
                    ReducersMapUpdated = ReducersMap#{Key := RedId}
            end,
            #{Key := Reducer} = ReducersMapUpdated,
            Reducer ! {reduce_partial, Num};
        print_results ->
            maps:foreach(
                fun (K, R) ->
                    io:fwrite("~s: ", K),
                    R ! print_partial_result,
                    io:fwrite("~n") end,
                ReducersMap
            ),
            ReducersMapUpdated = ReducersMap
    end,
    run_mgr(ReduceF, ReducersMapUpdated).

run_reducer(ReduceF, Accum) ->
    receive
        {reduce_partial, Num} ->
            Res = apply(?MODULE, ReduceF, [Accum | Num]),
            run_reducer(ReduceF, Res);
        print_partial_result ->
            io:fwrite("~d", Accum)
    end.

% TEST run by doing > exam20200207:word_count("sopra la panca la capra campa sotto la panca la capra crepa").
word_count(Text) ->
    RMPid = start_reduce_mgr(fun(X, Y) -> X + Y end),
    lists:foreach(fun(Word) -> RMPid ! {reduce, Word, 1} end, string:split(Text, " ", all)),
    RMPid ! print_results,
    ok.
% test fails:
% =ERROR REPORT==== 2-Jan-2024::16:40:55.452112 ===
%  Error in process <0.134.0> with exit value:
%  {{badkey,"sopra"},
%   [{exam20200207,run_mgr,2,[{file,"exam20200207.erl"},{line,51}]}]}
