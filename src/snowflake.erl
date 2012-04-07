-module(snowflake).

-callback start() -> ok.

-ifdef(TEST).
-endif.
