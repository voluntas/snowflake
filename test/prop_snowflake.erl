-module(prop_snowflake).

-include_lib("proper/include/proper.hrl").

-export([initial_state/0,
         command/1,
         precondition/2,
         next_state/3,
         postcondition/3]).

initial_state() ->
  on.

command(S) ->
  oneof(
    [{call, snowflake, press, []} || S == off] ++
    [{call, snowflake, release, []} || S == on]
  ).

precondition(S, {call, _, press, _}) ->
  S == off;
precondition(S, {call, _, release, _}) ->
  S == on.

next_state(_, _, {call, _, press, _}) ->
  on;
next_state(_, _, {call, _, release, _}) ->
  off.

postcondition(_, {call, _, press, _}, R) ->
  R == on;
postcondition(_, {call, _, release, _}, R) ->
  R == off.

prop_snowflake() ->
  ?FORALL(Cmds,
          commands(?MODULE, initial_state()),
          begin
            {_H, _S, R} = run_commands(?MODULE, Cmds),
            R == ok
          end
  ).
