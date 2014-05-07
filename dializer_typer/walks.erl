-module(walks).
-export([plan_route/2]).

-spec plan_route(From:: point(), To:: point()) -> route().

-type direction()   :: north | south | easy | west.
-type point()       :: {integer(), integer()}.
-type route()       :: [{go, direction(), integer()}].
