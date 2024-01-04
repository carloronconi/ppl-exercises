-module(exam20190628).
-compile(export_all).

% B starts running bu with argument []
% P1 starts running pr and sends to B values from 0 to 4 included, then messages master "done"
% B receives values from 0 to 4 and is running as bu([4, 3, 2, 1, 0])
% P2 does same as P1 with values from 5 to 9 included
% P3 does same as P1 with values from 10 to 15 included
% B receives all and is running with C = [list of all values from 0 to 15 in some order]
% the two consumers running cf receive the data but probably main process doesn't wait for them to finish, because
% spawn_link was used so they die as soon as main() terminates!
% 1) Basically this is a producer/consumer system where B is the dispatcher.
% 2) By swapping the 3 spawn_link with spawn, the dispatcher and consumers would keep running after main finishes so
%    they can finish consuming values. They never terminate though, could add messages...
