-module(snowflake).

-export([main/0]).
-export([jiffy/1]).
-export([mochijson2/1]).
-export([ejson/1]).
-export([jsx/1]).
-export([jsonx/1]).

-define(TIME, 100).

main() ->
  {ok, Binary} = file:read_file("tokoroten.json"),

  {JiffyTime, _Value} = timer:tc(?MODULE, jiffy, [Binary]),
  io:format("jiffy      .. Time: ~w~n", [JiffyTime]),

  {EjsonTime, _Value} = timer:tc(?MODULE, ejson, [Binary]),
  io:format("ejson      .. Time: ~w~n", [EjsonTime]),

  {Mochijson2Time, _Value} = timer:tc(?MODULE, mochijson2, [Binary]),
  io:format("mochijson2 .. Time: ~w~n", [Mochijson2Time]),

  {JsxTime, _Value} = timer:tc(?MODULE, jsx, [Binary]),
  io:format("jsx        .. Time: ~w~n", [JsxTime]),

  {JsonxTime, _Value} = timer:tc(?MODULE, jsonx, [Binary]),
  io:format("jsonx      .. Time: ~w~n", [JsonxTime]),

  ok.

jsonx(Binary) ->
  F = fun(_) ->
        jsonx:decode(jsonx:encode(Binary))
      end,
  lists:foreach(F, lists:duplicate(?TIME, duplicate)).

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
