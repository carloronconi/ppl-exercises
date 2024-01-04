-module(exam20190628).
-compile(export_all).

% B starts running bu with argument []
% P1 starts running pr and sends to B values from 0 to 4 included, then messages master "done"
% B receives values from 0 to 4 and is running as bu([4, 3, 2, 1, 0])
% P2 does same as P1 with values from 5 to 9 included
% P3 does same as P1 with values from 10 to 15 included
% B receives all and is running with C = [list of all values from 0 to 15 in some order] and sends data to consumers in
% LIFO order (like a stack)
% the two consumers running cf receive the data but probably main process doesn't wait for them to finish, because
% spawn_link was used so they die as soon as main() terminates!
% 1) CORRECT
% Basically this is a producer/consumer system where B is a LIFO dispatcher.
%
% 2) WRONG!! I THOUGHT THE OPPOSITE WAS REQUIRED!
% By swapping the 3 spawn_link with spawn, the dispatcher and consumers would keep running after main finishes so
% they can finish consuming values. They never terminate though, could add messages...
%
% Actually, the dispatcher and consumers already keep running, because the default (normal) exit signal is silently
% dropped in spawn_link'ed processes. Any other exit signal is instead not ignored and terminates the linked receiver
% so what the exam wanted us to do was just terminate main() with any other exit signal: exit(done) instead of ok.
% The exam didn't care if main() terminated the consumers before they emptied the dispatcher's queue: confirmed by also
% running the official "corrected" version below
%
% 3) WRONG!
% no: the dispatcher gives back data as LIFO, so 0 1 2 7 12 3 8 13 can't do out 12 out 7
%
% yes: the output of the system is correct, because it is possible that some elements remain in the buffer,
% being the buffer managed as a stack.
% 0 1 2 3 8 13 4 15 end state

% testing what happens when exiting with different signal than default (default when not using explicit exit)
other() ->
    io:format("running~n", []),
    other().

test() ->
    spawn_link(?MODULE, other, []),
    io:format("terminating~n", []),
    exit(done).

% exam text
bu(C) ->
    receive
        {get, From} ->
            if
                C =:= [] ->
                    From ! empty, bu([]);
                true ->
                    [H|T] = C,
                    From ! H, bu(T)
            end;
        {put, Data} -> bu([Data | C])
    end.

pr(From, To, B, Master) ->
    if
        From =< To ->
            B ! {put, From},
            io:format("~w in ~p~n", [self(), From]),
            pr(From+1, To, B, Master);
        true ->
            Master ! {self(), done}
    end.

cf(B) ->
    B ! {get, self()},
    receive
        empty ->
            io:format("~w: no data~n", [self()]),
            cf(B);
        V ->
            io:format("~w out ~p~n", [self(), V]),
            cf(B)
    end.

main() ->
    B  = spawn_link(?MODULE, bu, [[]]),
    P1 = spawn(?MODULE, pr, [0,4,B,self()]),
    P2 = spawn(?MODULE, pr, [5,9,B,self()]),
    P3 = spawn(?MODULE, pr, [10,15,B,self()]),
    spawn_link(?MODULE, cf, [B]),
    spawn_link(?MODULE, cf, [B]),
    receive
        {P3, done} ->
            receive
                {P2, done} ->
                    receive
                        {P1, done} -> exit(done) % here the correction: "exit(done)" instead of "ok"
                    end
            end
    end.

