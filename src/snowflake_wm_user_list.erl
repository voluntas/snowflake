-module(snowflake_wm_user_list).
%% wm_user_keylist ?

-export([init/1,
         allowed_methods/2,
         content_types_provided/2]).

-export([to_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

%% RD -> ReqData
%% Ctx -> Context

init([]) ->
    {ok, undefined}.

allowed_methods(RD, Ctx) ->
    {['GET'], RD, Ctx}.

content_types_provided(RD, Ctx) ->
    {[{"application/json", to_json}], RD, Ctx}.

to_json(RD, Ctx) ->
    Keys = snowflake_user:key_list(),
    Result = mochijson2:encode({struct, [{<<"keys">>, Keys}]}),
    {Result, RD, Ctx}.
