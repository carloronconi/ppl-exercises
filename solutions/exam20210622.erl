-module(exam20210622).
-compile(export_all).

% Create a function node_wait that implements nodes in a tree-like topology. Each node, which is a separate agent, keeps
% track of its parent and children (which can be zero or more), and contains a value. An integer weight is associated to
% each edge between parent and child.A node waits for two kind of messages:
% • {register_child, ...}, which adds a new child to the node (replace the dots with appropriate values),
% • {get_distance, Value}, which causes the recipient to search for Value among its children, by interacting with them
% through appropriate messages. When the value is found, the recipient answers with a message containing the minimum
% distance between it and the node containing "Value", considering the sum of the weights of the edges to be traversed.
% If the value is not found,the recipient answers with an appropriate message. While a node is searching for a value among
% its children, it may not accept any new children registrations.
% E.g., if we send {get_distance, a} to the root process, it answers with the minimum distance between the root and the
% closest node containing the atom a (which is 0 if a is in the root).

% first attempt
% node(Parent, Children, Value) -> % Children is a map Pid => Weight
%     receive
%         {register_child, Weight, ValueChild} ->
%             Child = spawn(?MODULE, node, [self(), #{}, ValueChild]),
%             node(Parent, Children#{Child => Weight}, Value);
%         {get_distance, ValueOther} ->
%             self() ! {get_distance, Sender, ValueOther, 0};
%         {get_distance, Sender, Value, WeightAccum} ->
%             Sender ! {return_distance, WeightAccum},
%             node(Parent, Children, Value);
%         {get_distance, Sender, ValueOther, WeightAccum} ->

% TODO: can't solve this exercise!
% second attempt
receive_distance(Children) ->
    receive
        {}

get_distance_children(Value, Children, []) -> receive_distance(Children);
get_distance_children(Value, Children, Remaining) ->
    [{Pid, Weight} | Rest] = Children,
    Pid ! {get_distance, Value},
    get_distance_children(Value, Children, Rest).

node(Parent, Children, Value) -> % because we need to iterate over children, better to make it list of tuples (from prof's sol)
    receive
        {register_child, Pid, Weight} -> % wasn't clear from exam text, but don't need to spawn it, caller spawned it
            node(Parent, [{Pid, Weight} | Children], Value);
        {get_distance, Value} ->
            Parent ! {self(), found},
            node(Parent, Children, Value);
        {get_distance, ValueOther} ->
            if
                Children == [] -> Parent ! {self(), not_found}
                true ->
                    Parent ! get_distance_children(ValueOther, Children, Children),
                    node(Parent, Children, Value)
            end;

% solution by prof
node_wait(Parent, Elem, Children) ->
    receive
        {register_child, Child, Weight} ->
            node_wait(Parent, Elem, [{Child, Weight} | Children]);
        {get_distance, Value} ->
            if
                Value == Elem ->
                    Parent ! {distance, Value, self(), 0},
                    node_wait(Parent, Elem, Children);
                true ->
                    node_comp_dist(Parent, Elem, Children, Value)
            end
    end.

node_comp_dist(Parent, Elem, Children, Value) ->
    [Child ! {get_distance, Value} || {Child, _} <- Children],    % here
    Dists = [receive
                {distance, Value, Child, D} ->
                    D + Weight;
                {not_found, Value, Child} ->
                    not_found
            end || {Child, Weight} <- Children],                  % here
    FoundDists = lists:filter(fun erlang:is_integer/1, Dists),
    case FoundDists of
        [] ->
            Parent ! {not_found, Value, self()};
        _ ->
            Parent ! {distance, Value, self(), lists:min(FoundDists)}
    end,
    node_wait(Parent, Elem, Children).