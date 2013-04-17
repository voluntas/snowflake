-module(snowflake_cowboy).

-export([start/0]).

-spec start() -> ok.
start() ->
    application:start(crypto),
    application:start(ranch),
    application:start(cowboy),
    Dispatch = cowboy_router:compile([
        {'_', [
            {[<<"multipart">>], snowflake_multipart_handler, []},
            {'_', snowflake_default_handler, []}
        ]}
    ]),
    cowboy:start_http(snowflake_http_handler, 100,
       [{port, 8080}], 
       [{env, [{dispatch, Dispatch}]}]
    ),
    ok.
