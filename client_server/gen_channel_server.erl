-module(gen_channel_server).
-export([start/1, call/2, cast/2, init/1]).

start(Mod) -> spawn(gen_channel_server, init, [Mod]).

init(Mod) ->
  register(Mod, self()),
  State = Mod:init(),
  loop(Mod, State).

call(Name, Req) ->
  Name ! {call, self(), Req},
  receive
    {Name, Res} -> Res
  end.

cast(Name, Req) ->
  Name ! {cast, Req},
  ok.

loop(Mod, State) ->
  receive
    {call, From, Req} ->
      {Res, NewState} = Mod:handle_call(Req, State),
      From ! {Mod, Res},
      loop(Mod, NewState);
    {cast, Req} ->
      NewState = Mod:handle_cast(Req, State),
      loop(Mod, NewState)
  end.
