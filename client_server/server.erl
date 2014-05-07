-module(server).
-author("Vasiliy Yorkin").

%% API

-export([
         start_link/0,
         alloc/0,
         free/1,
         init/1,
         handle_call/3,
         handle_cast/2
        ]).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

start_link()  -> gen_server:start_link({local, server}, server, [], []).
init(_Args)   -> {ok, channels()}.
alloc()       -> gen_server:call(server, alloc).
free(Channel) -> gen_server:cast(server, {free, Channel}).

handle_call(alloc, _From, Channels) ->
  {Channel, NewChannels} = alloc(Channels),
  {reply, Channel, NewChannels}.

handle_cast({free, Channel}, Channels) ->
  NewChannels = free(Channel, Channels),
  {noreply, NewChannels}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

channels() -> {_Allocated = [], _Free = lists:seq(1, 100)}.

alloc({Allocated, [H|T] = _Free}) -> {H, {[H|Allocated], T}}.

free(Channel, {Alloc, Free} = Channels) ->
   case lists:member(Channel, Alloc) of
      true  -> {lists:delete(Channel, Alloc), [Channel|Free]};
      false -> Channels
   end.
