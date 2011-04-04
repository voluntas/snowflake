-module(snowflake).

-export([my_func/0]).

my_func() ->
  ok.

-ifdef(TEST).
-endif.
