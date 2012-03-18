-module(snowflake).

-export([main/0]).
-export([jiffy/1]).
-export([mochijson2/1]).

-define(TIME, 1).

main() ->
  {ok, Binary} = file:read_file("tokoroten.json"),
  {JiffyTime, _Value} = timer:tc(?MODULE, jiffy, [Binary]),
  io:format("jiffy .. Time: ~w~n", [JiffyTime]),
  {Mochijson2Time, _Value} = timer:tc(?MODULE, mochijson2, [Binary]),
  io:format("mochijson2 .. Time: ~w~n", [Mochijson2Time]),
  ok.

mochijson2(Binary) ->
  F = fun(_) ->
        mochijson2:decode(mochijson2:encode(Binary))
      end,
  lists:foreach(F, lists:duplicate(?TIME, duplicate)).

jiffy(Binary) ->
  F = fun(_) ->
        jiffy:decode(jiffy:encode(Binary))
      end,
  lists:foreach(F, lists:duplicate(?TIME, duplicate)).

-ifdef(TEST).

-endif.
