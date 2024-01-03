-module(exam20190208).
-compile(export_all).

% 1) MOSTLY RIGHT: I MISSED THE RE-ORDERING THING
% the system spawns 3 types of actor.
% - buffer, which has two states: the first one (which is the initial one) in which it waits for a "put" message and
%   stores the received data in the parameter for passing to the second state, in which it waits for a "get" message
%   and sends back the received data at the previous step. the number of actors of this tpe spawned depends on the
%   length of the list of commands passed.
% - pi, which sends a "put" (a ping) command to the N-th buffer process where N is indicated by the number in the
%   command, so for example sends "house" to the 3rd buffer process because of the command {3, house}
% - po, which receives "get" (the pong) commands from buffer processes iterating in the buffer ordering, so from buffer
 %  1 to the last, and prints the data it receives
% in the end, the output of the call prints the words passed in the commands, ordered by their number:
%
% moose
% lambda
% house
% dark

% 2) WRONG BECAUSE MISSED RE-ORDERING! RE-DONE BELOW
% no, it's not possible to have deadlocks: each buffer process starts with empty data, so it only waits for "put"
% messages coming from the pi process, and only after receiving the message wait for "get" messages from the po process.
% pi and po sequentially send messages to all the buffer processes, so the ordering of events is deterministic.

% 2) re-done
% yes, it is possible to have deadlocks, because pi sends commands following the number passed in the command, while po
% waits for replies in the order of the buffer. So with run([{2,house},{2,moose},{1,lambda}]). pi will send house to
% process 2 and then be stuck waiting to send moose to buf process 2, while buf process 2 is stuck in the second state
% waiting to receive a get message from po, while po is stuck sending a get message to buf process 1, which is stuck in
% the first state waiting for pi to send a put message

% 3) RIGHT (BUT FORGOT TO ADD ok, JUST REMOVED THE LINE)
% at the end, all the spawned buffer processes will still be running: they all recursively re-call their function without ever
% returning in both states. To fix it we can terminate after the end of the second state like so:

buffer(Data) ->
    case Data of
        empty ->
            receive
                {put, V} ->
                    buffer(V)
            end;
        _ ->
            receive
                {get, Who} ->
                    Who ! Data,
                    ok
                    % buffer(empty) removed this and added ok so after pong the process finishes
            end
    end.

create_buffers(0) -> [];
create_buffers(V) -> [spawn(?MODULE, buffer, [empty]) | create_buffers(V-1)].

pi(_, []) -> ok;
pi(Buf, [{V,D} | Cmds]) ->
    lists:nth(V,Buf) ! {put, D},
    pi(Buf, Cmds).

po([]) -> ok;
po([V | Vs]) ->
    V ! {get, self()},
    receive
        X -> true
    end,
    io:format("~s~n", [X]),
    po(Vs).

run(Commands) ->
    Buf = create_buffers(length(Commands)),
    spawn(?MODULE, pi, [Buf, Commands]),
    spawn(?MODULE, po, [Buf]),
    ok.







