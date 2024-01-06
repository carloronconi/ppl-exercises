# Erlang linking

## Sending Signals

There are many signals that processes and ports use to communicate. The list below contains the most important signals.

message
Sent when using the send operator !, or when calling one of the erlang:send/2,3 or erlang:send_nosuspend/2,3 BIFs.
link
Sent when calling the link/1 BIF.
unlink
Sent when calling the unlink/1 BIF.
exit
Sent either when explicitly sending an exit signal by calling the exit/2 BIF, or when a linked process terminates. If the signal is sent due to a link, the signal is sent after all directly visible Erlang resources used by the process have been released.

## Links

Two processes can be linked to each other. Also a process and a port that reside on the same node can be linked to each other. A link between two processes can be created if one of them calls the link/1 BIF with the process identifier of the other process as argument. Links can also be created using one the following spawn BIFs spawn_link(), spawn_opt(), or spawn_request(). The spawn operation and the link operation will be performed atomically, in these cases.

If one of the participants of a link terminates, it will send an exit signal to the other participant. The exit signal will contain the exit reason of the terminated participant.

A link can be removed by calling the unlink/1 BIF.

Links are bidirectional and there can only be one link between two processes. Repeated calls to link() have no effect. Either one of the involved processes may create or remove a link.

## Sending Exit Signals

When a process or port terminates it will send exit signals to all processes and ports that it is linked to.

## Receiving Exit Signals

What happens when a process receives an exit signal depends on:

- The trap exit state of the receiver at the time when the exit signal is received.
- The exit reason of the exit signal.
- The sender of the exit signal.
- The state of the link flag of the exit signal. If the link flag is set, the exit signal was sent due to a link; otherwise, the exit signal was sent by a call to the exit/2 BIF.
- If the link flag is set, what happens also depends on whether the link is still active or not when the exit signal is received.

Based on the above states, the following will happen when an exit signal is received by a process:

- *The exit signal is silently dropped* if:
    - the link flag of the exit signal is set and the corresponding link has been deactivated.
    - the exit reason of the exit signal is the atom normal, the receiver is not trapping exits, and the receiver and sender are not the same process.

- *The receiving process is terminated* if:
    - the link flag of the exit signal is not set, and the exit reason of the exit signal is the atom kill. The receiving process will terminate with the atom killed as exit reason.
    - the receiver is not trapping exits, and the exit reason is something other than the atom normal. Also, if the link flag of the exit signal is set, the link also needs to be active otherwise the exit signal will be dropped. The exit reason of the receiving process will equal the exit reason of the exit signal. Note that if the link flag is set, an exit reason of kill will not be converted to killed.
    - the exit reason of the exit signal is the atom normal and the sender of the exit signal is the same process as the receiver. The link flag cannot be set in this case. The exit reason of the receiving process will be the atom normal.

- *The exit signal is converted to a message signal* and added to the end of the message queue of the receiver, if the receiver is trapping exits, the link flag of the exit signal is:
    - not set, and the exit reason of the signal is not the atom kill.
    - set, and the corresponding link is active. Note that an exit reason of kill will not terminate the process in this case and it will not be converted to killed.

The converted message will be on the form {'EXIT', SenderID, Reason} where Reason equals the exit reason of the exit signal and SenderID is the identifier of the process or port that sent the exit signal.

## Looping with list comprehensions
Using list comprehensions allows to do something like `for_each(Child in Children) {do something with Child}`.
It also allows to wait for all the replies for each of the same children very easily.
```
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
```