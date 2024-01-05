-module(exam20190116).
-compile(export_all).

% Define a "functional" process buffer, called fuffer, that stores only one value and may receive messages only from its
% creator. fuffer can receive the following commands:
% 'set' to store a new value
% 'get' to obtain the current value
% 'apply F' to apply the function F to the stored value
% 'die' to end
% 'duplicate' to create (and return) an exact copy of itself

% ALL GOOD :)
fuffer(From, Val) ->
    receive
        {set, From, NewVal} ->
            fuffer(From, NewVal);
        {get, From} ->
            From ! Val,
            fuffer(From, Val);
        {apply, From, F} ->
            fuffer(From, F(Val));
        {die, From} ->
            ok;
        {duplicate, From} ->
            Pid = spawn(?MODULE, fuffer, [From, Val]),
            From ! Pid,
            fuffer(From, Val)
    end.