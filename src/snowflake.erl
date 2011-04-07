-module(snowflake).

-export([press/0, release/0]).

press() ->
  on.

release() ->
  off.

-ifdef(TEST).
-endif.
