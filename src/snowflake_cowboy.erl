-module(snowflake_cowboy).

-export([start/0]).

-spec start() -> ok.
start() ->
    application:start(cowboy),
    Dispatch = [
        {'_', [
            {'_', snowflake_default_handler, []}
        ]}
    ],
    cowboy:start_listener(snowflake_http_handler, 100,
        cowboy_tcp_transport, [{port, 8080}],
        cowboy_http_protocol,  [{dispatch, Dispatch}]
    ),
    ok.
