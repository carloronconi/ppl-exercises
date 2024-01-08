-module(exam20210831).
-compile(export_all).

% Define a function which takes two list of PIDs [x1, x2, ...], [y1, y2, ...], having the same length, and a function f,
% and creates a different "broker" process for managing the interaction between each pair of processes xi and yi.
% At start, the broker process i must send its PID to xi and yi with a message {broker, PID}.
% Then, the broker i will receive messages {from, PID, data, D} from xi or yi, and it must send to the other one an
% analogous message, but with the broker PID and data D modified by applying f to it.
% A special stop message can be sent to a broker i, that will end its activity sending the same message to xi and yi.

% all good, same as prof's solution!
main([], [], _) -> ok.
main([], _, _) -> fail.
main(_, [], _) -> fail.
main([X | Xs], [Y | Ys], F) ->
    spawn(?MODULE, broker, [X, Y, F]),
    main(Xs, Ys, F).

broker(PidX, PidY, F) ->
    Self = self(),
    PidX ! {broker, Self},
    PidY ! {broker, Self},
    broker_loop(PidX, PidY, F).

broker_loop(PidX, PidY, F) ->
    receive
            {from, PidX, data, D} ->
                PidY ! {from, self(), data, F(D)},
                broker_loop(PidX, PidY, F);
            {from, PidY, data, D} ->
                PidX ! {from, self(), data, F(D)},
                broker_loop(PidX, PidY, F);
            stop ->
                PidX ! stop,
                PidY ! stop,
                ok
    end.


