-module(snowflake).

-export([start/0]).

start() ->
    ok = application:start(snowflake),
    F1 = fun() ->
            ok = snowflake_logger:start(<<"log/abcdefg">>),
            timer:sleep(1000),
            ok = snowflake_logger:notify("~w | ~w ~n", [<<"abc">>, <<"def">>]),
            timer:sleep(1000),
            ok = snowflake_logger:stop()
        end,
    F2 = fun() ->
            ok = snowflake_logger:start(<<"log/egfdija">>),
            timer:sleep(1000),
            ok = snowflake_logger:notify("~w | ~w ~n", [<<"abc">>, <<"def">>]),
            timer:sleep(1000),
            ok = snowflake_logger:stop()
        end,
    spawn(F1),
    spawn(F2),
    ok.


-ifdef(TEST).
-endif.
