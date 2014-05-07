-module(rec_test).
-export([clear_status/1]).

-record(todo, {status=reminder, who=joe,text}).

clear_status(#todo{status = _, who= _} = R) ->
  R#todo{status=finished}.
