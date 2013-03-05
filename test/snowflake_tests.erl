-module(snowflake_tests).
-include_lib("eunit/include/eunit.hrl").

trivial_test_() ->
    [?_assertEqual(true, true)].
