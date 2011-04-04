-module(snowflake).

-export([my_func/1]).

-spec my_func(binary()) -> ok | binary().
my_func(Binary) ->
  case Binary of
    Binary when byte_size(Binary) > 10 ->
      spam;
    _ ->
      Binary
  end.

-ifdef(TEST).
-endif.
