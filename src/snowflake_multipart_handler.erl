-module(snowflake_multipart_handler).

-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

-include_lib("eunit/include/eunit.hrl").

init({_, http}, Req, _) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    true = cowboy_req:has_body(Req),
    {ok, _Data, Req2} = read_body(Req, <<>>, 1000000),
    {ok, Req2, State}.


terminate(_, _, _) ->
    ok.

% Read chunked request content
read_body(Req, Acc, BodyLengthRemaining) ->
    case cowboy_req:stream_body(Req) of
        {ok, Data, Req2} ->
            ?debugVal(Data),
            BodyLengthRem = BodyLengthRemaining - byte_size(Data),
            read_body(Req2, << Acc/binary, Data/binary >>, BodyLengthRem);
        {done, Req2} ->
            {ok, Acc, Req2}
    end.
