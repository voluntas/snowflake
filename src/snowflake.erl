-module(snowflake).

-export([main/0]).


main() ->
    case get_value(spam, [{eggs, <<"bacon">>}]) of
        undefined ->
            {error, not_found};
        Value ->
            {ok, Value}
    end.


%% -spec get_value(atom(), [{atom(), binary()}]) -> not_found | binary().
get_value(Key, List) ->
    proplists:get_value(Key, List, not_found).

-ifdef(TEST).
-endif.
