-module(shop2).
-export([total/1]).
-import(lib_misc, [sum/1]).

cost(a) -> 1;
cost(b) -> 2;
cost(c) -> 3;
cost(d) -> 4;
cost(e) -> 5;
cost(f) -> 6.

total(L) -> sum([cost(P) * C || {P, C} <- L]).
