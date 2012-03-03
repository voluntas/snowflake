-module(snowflake_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-include_lib("eunit/include/eunit.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  ok = application:start(erlzmq),
  ok = application:start(jiffy),

  {ok, Sup} = snowflake_sup:start_link(),
  F = fun(_) ->
        supervisor:start_child(zmq_subscriber_sup, [])
      end,
  ok = lists:foreach(F, lists:duplicate(10, dummy)),
  {ok, Sup}.

stop(_State) ->
    ok.
