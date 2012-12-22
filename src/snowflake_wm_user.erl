-module(snowflake_wm_user).

-export([init/1,
         service_available/2,
         allowed_methods/2,
         resource_exists/2,
         create_path/2,
         content_types_accepted/2,
         content_types_provided/2]).

-export([to_json/2, from_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

-include("snowflake_user.hrl").

%% RD -> ReqData
%% Ctx -> Context

-record(ctx, {user :: #user{},
              user_id :: snowflake_user:user_id(),
              method :: atom()}).

init(_Config) ->
    %% {ok, undefined}.
    {{trace, "/tmp"}, #ctx{}}.

service_available(RD, Ctx) ->
    {true, RD, Ctx#ctx{method = wrq:method(RD)}}.

allowed_methods(RD, Ctx) ->
    {['GET', 'PUT'], RD, Ctx}.

create_path(RD, Ctx) ->
    {Ctx#ctx.user_id, RD, Ctx}.

resource_exists(RD, Ctx) ->
    UserId = wrq:path_info(user_id, RD),
    case snowflake_user:lookup(UserId) of
        not_found ->
            {false, RD, Ctx#ctx{user_id = UserId}};
        User ->
            {true, RD, Ctx#ctx{user = User}}
    end.

content_types_accepted(RD, Ctx) ->
    {[{"application/json", from_json}], RD, Ctx}.

content_types_provided(RD, Ctx) ->
    {[{"application/json", to_json}], RD, Ctx}.

to_json(RD, #ctx{user = User} = Ctx) ->
    Result = mochijson2:encode({struct, [{<<"user_id">>, User#user.id},
                                         {<<"password">>, User#user.password}]}),
    {Result, RD, Ctx}.

from_json(RD, Ctx) ->
    RawJson = wrq:req_body(RD),
    {struct, Json} = mochijson2:decode(RawJson),
    Password = proplists:get_value(<<"password">>, Json),
    NewJson = mochijson2:encode({struct, [{<<"user_id">>, list_to_binary(Ctx#ctx.user_id)},
                                          {<<"password">>, Password}]}),
    RD2 = wrq:set_resp_body(NewJson, RD),
    {true, RD2, Ctx}.
