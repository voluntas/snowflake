-module(snowflake).

-export([main/0]).

main() ->
    ok = snowflake_logger:init(),
    F = fun() ->
            ok = snowflake_logger:start(<<"abcdefg">>),
            timer:sleep(1000),
            ok = snowflake_logger:notify("~w | ~w ~n", [<<"abc">>, <<"def">>]),
            timer:sleep(1000),
            ok = snowflake_logger:stop()
        end,
    spawn(F),
    spawn(F),
    ok.


-ifdef(TEST).
-endif.
