-module(exam20200115).
-compile(export_all).

% We want to implement something like Python’s range in Erlang, using processes.
% E.g.
% R = range(1,5,1) % starting value, end value, step
% next(R) % is 1
% next(R) % is 2...
% next(R) % is 5
% next(R) % is the atom stop_iteration
%
% Define range and next, where range creates a process that manages the iteration, and next a function that talks with
% it, asking the current value.

% EVERYTHING IS CORRECT :)
runner(stop) ->
    receive
        {Who, next} ->
            Who ! stop_iteration,
            runner(stop)
    end.

runner(Curr, End, Step) ->
    receive
        {Who, next} ->
            Who ! Curr,
            Next = Curr + Step,
            if
                Next > End -> runner(stop);
                true -> runner(Next, End, Step)
            end
    end.


range(Start, End, Step) ->
    spawn(?MODULE, runner, [Start, End, Step]).

next(Pid) ->
    Pid ! {self(), next},
    receive
        Any -> Any
    end.

test() ->
 Pid = range(1, 5, 1),
 [next(Pid), next(Pid), next(Pid), next(Pid), next(Pid), next(Pid), next(Pid)].