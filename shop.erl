-module(shop).
-export([cost/1, total/1]).

cost(a) -> 1;
cost(b) -> 2;
cost(c) -> 3;
cost(d) -> 4;
cost(e) -> 5;
cost(f) -> 6.

total([{What, N}|T])  -> cost(What) * N + total(T);
total([])             -> 0.
