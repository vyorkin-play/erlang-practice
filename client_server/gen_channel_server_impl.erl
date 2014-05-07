-module(gen_channel_server_impl).
-export([
  start/0, init/0, alloc/0, free/1,
  handle_call/2, handle_cast/2
]).

start() -> gen_channel_server:start(gen_channel_server_impl).
alloc() -> gen_channel_server:call(gen_channel_server_impl, alloc).
free(C) -> gen_channel_server:cast(gen_channel_server_impl, {free, C}).
init()  -> {_Allocated = [], _Free = lists:seq(1, 100)}.

handle_call(alloc, Cs)     -> alloc(Cs).
handle_cast({free, C}, Cs) -> free(C, Cs).

alloc({Allocated, [H|T] = _Free}) -> {H, {[H|Allocated], T}}.

free(Channel, {Alloc, Free} = Channels) ->
   case lists:member(Channel, Alloc) of
      true  -> {lists:delete(Channel, Alloc), [Channel|Free]};
      false -> Channels
   end.
