-module(snowflake_mnesia_tests).

-include_lib("eunit/include/eunit.hrl").

snowflake_mnesia_props_test_() ->
  {setup,
    fun() ->
      ok
    end,
    fun(_) ->
      ok
    end,
    {timeout, 10000,
      [
        ?_assertEqual([], proper:module(prop_snowflake_mnesia))
      ]
    }
  }.
