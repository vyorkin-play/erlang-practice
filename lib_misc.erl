-module(lib_misc).
-export([
  for/3, sum/1, map/2, pythag/1, perms/1, max/2,
  ebani/2, filter/2, odds_and_evens1/1, odds_and_evens2/1
]).

for(Max, Max, F)  -> [F(Max)];
for(I, Max, F)    -> [F(I)|for(I + 1, Max, F)].

sum([H|T])        -> H + sum(T);
sum([])           -> 0.

map(_, [])        -> [];
map(F, [H|T])     -> [F(H)|map(F, T)].

pythag(N) ->
  [ {A, B, C} ||
    A <- lists:seq(1, N),
    B <- lists:seq(1, N),
    C <- lists:seq(1, N),
    A + B + C =< N,
    A*A + B*B =:= C*C
  ].

filter(P, [H|T]) ->
  case P(H) of
    true  -> [H|filter(P, T)];
    false -> filter(P, T)
  end;
filter(_, []) -> [].

perms([])  -> [[]];
perms(L)   -> [[H|T] || H <- L, T <- perms(L -- [H])].

max(X, Y) when X > Y -> X;
max(_, Y) -> Y.

ebani(X, Y) when (X rem Y > 0) orelse (Y rem X > 0) -> true;
ebani(X, _) -> X.

odds_and_evens1(L) ->
  Odds  = [X || X <- L, (X rem 2 =:= 1)],
  Evens = [X || X <- L, (X rem 2 =:= 0)],
  {Odds, Evens}.

odds_and_evens2(L) ->
  odds_and_evens_acc(L, [], []).

odds_and_evens_acc([H|T], OddsAcc, EvensAcc) ->
  case (H rem 2) of
    0 -> odds_and_evens_acc(T, OddsAcc, [H|EvensAcc]);
    1 -> odds_and_evens_acc(T, [H|OddsAcc], EvensAcc)
  end;

odds_and_evens_acc([], OddsAcc, EvensAcc) -> [OddsAcc, EvensAcc].

