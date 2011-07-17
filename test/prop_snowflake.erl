-module(prop_snowflake).

-author('@voluntas').

-behaviour('proper_statem').

-export([press/0, release/0]).

-export([initial_state/0,
         command/1,
         precondition/2,
         next_state/3,
         postcondition/3]).

-include_lib("proper/include/proper.hrl").

-record(state, {button = on :: on | off}).

initial_state() ->
  #state{}.

command(S) ->
  oneof(
    [{call, ?MODULE, press, []} || S#state.button == off] ++
    [{call, ?MODULE, release, []} || S#state.button == on]
  ).

precondition(S, {call, _, press, _}) ->
  S#state.button == off;
precondition(S, {call, _, release, _}) ->
  S#state.button == on.

next_state(S, _, {call, _V, press, _}) ->
  S#state{button = on};
next_state(S, _, {call, _V, release, _}) ->
  S#state{button = off}.

postcondition(_, {call, _V, press, _}, R) ->
  R == on;
postcondition(_, {call, _V, release, _}, R) ->
  R == off;
postcondition(_, _, _) ->
  false.

press() ->
  on.

release() ->
  off.


prop_snowflake() ->
  ?FORALL(Cmds, commands(?MODULE, initial_state()),
          begin
            {_H, _S, R} = run_commands(?MODULE, Cmds),
            R =:= ok
          end).
