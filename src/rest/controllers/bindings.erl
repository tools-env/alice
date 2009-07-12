-module (bindings).
-export ([get/1, post/2, put/2, delete/2]).


get(["root"]) -> ?MODULE:get(["/"]);
get([VhostArg]) -> 
  [Back] = get_bindings_for(VhostArg),
  
  {Exchange, Queue, AsQueue, _Other} = Back,
  {resource, _, exchange, Exch} = Exchange,
  {resource, _, queue, RealQueue} = Queue,
  
  % {"exchange", Exch}, {"other", Other}
  O = {struct,  [
                  {"queue", utils:turn_binary(RealQueue)},
                  {"exchange", utils:turn_binary(Exch)},
                  {"from_queue", utils:turn_binary(AsQueue)}                  
                ]},
  {?MODULE, O};
  
get(_Path) -> {"error", <<"unhandled">>}.

post(_Path, _Data) -> {"error", <<"unhandled">>}.
put(_Path, _Data) -> {"error", <<"unhandled">>}.
delete(_Path, _Data) -> {"error", <<"unhandled">>}.

% PRIVATE

get_bindings_for(VhostArg) ->
  case rabint:call({rabbit_exchange, list_bindings, [ VhostArg ]}) of
    {error, E} -> {"error", erlang:list_to_binary(E)};
    Bin -> Bin
  end.