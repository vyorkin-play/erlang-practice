-module(channel_server).
-export([start/0, alloc/0, free/1, init/0]).

start() -> spawn(channel_server, init, []).

init() ->
  register(channel_server, self()),
  Channels = channels(),
  loop(Channels).

alloc() ->
  channel_server ! {self(), alloc},
  receive
    {channel_server, Res} -> Res
  end.

free(Channel) ->
  channel_server ! {free, Channel},
  ok.

loop(Channels) ->
  receive
    {From, alloc} ->
      {Channel, NewChannels} = alloc(Channels),
      From ! {channel_server, Channel},
      loop(NewChannels);
    {free, Channel} ->
      NewChannels = free(Channel, Channels),
      loop(NewChannels)
  end.

channels() -> {_Allocated = [], _Free = lists:seq(1, 100)}.

alloc({Allocated, [H|T] = _Free}) -> {H, {[H|Allocated], T}}.

free(Channel, {Alloc, Free} = Channels) ->
   case lists:member(Channel, Alloc) of
      true  -> {lists:delete(Channel, Alloc), [Channel|Free]};
      false -> Channels
   end.

