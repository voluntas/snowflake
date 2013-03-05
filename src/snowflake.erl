-module(snowflake).

-export([main/0]).
-export([jiffy/1]).
-export([mochijson2/1]).
-export([ejson/1]).
-export([jsx/1]).

-define(TIME, 100).

main() ->
  {ok, Binary} = file:read_file("tokoroten.json"),
  {JiffyTime, _Value} = timer:tc(?MODULE, jiffy, [Binary]),
  {Ejson, _Value} = timer:tc(?MODULE, ejson, [Binary]),
  {Mochijson2Time, _Value} = timer:tc(?MODULE, mochijson2, [Binary]),
  {JsxTime, _Value} = timer:tc(?MODULE, jsx, [Binary]),

  io:format("jiffy      .. Time: ~w~n", [JiffyTime]),
  io:format("ejson      .. Time: ~w~n", [Ejson]),
  io:format("mochijson2 .. Time: ~w~n", [Mochijson2Time]),
  io:format("jsx        .. Time: ~w~n", [JsxTime]),
  ok.

jsx(Binary) ->
  F = fun(_) ->
        jsx:decode(jsx:encode(Binary))
      end,
  lists:foreach(F, lists:duplicate(?TIME, duplicate)).

ejson(Binary) ->
  F = fun(_) ->
        ejson:decode(ejson:encode(Binary))
      end,
  lists:foreach(F, lists:duplicate(?TIME, duplicate)).

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
