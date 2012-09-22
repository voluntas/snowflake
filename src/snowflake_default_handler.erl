-module(snowflake_default_handler).

-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/2]).

init({_Any, http}, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {ok, Res} = cowboy_req:reply(200, [], <<"Hello cowboy!">>, Req),
    {ok, Res, State}.

terminate(_Req, _State) ->
    ok.
