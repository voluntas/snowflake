-module(snowflake_tests).

-include_lib("eunit/include/eunit.hrl").

specs_test() ->
  ?assertEqual([], proper:check_specs(snowflake)),
  ok.
