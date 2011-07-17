-module(prop_snowflake_mnesia).

-author('@voluntas').

-behaviour('proper_statem').

-export([initial_state/0,
         command/1,
         precondition/2,
         next_state/3,
         postcondition/3]).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").

-include("snowflake.hrl").

-record(state, {dict :: term()}).

prop_snowflake() ->
  ?FORALL(Cmds, commands(?MODULE, initial_state()),
    begin
      error_logger:tty(false),
      application:start(mnesia),
      snowflake_mnesia:init(),
      {History, State, Result} = run_commands(?MODULE, Cmds),
      application:stop(mnesia),
      ?WHENFAIL(io:format("History: ~p\nState: ~p\nRes: ~p\n",
                          [History, State, Result]),
                aggregate(command_names(Cmds), Result =:= ok))
    end).

prop_snowflake_mnesia_paralell() ->
  ?FORALL(Cmds, parallel_commands(?MODULE),
          begin
            error_logger:tty(false),
            application:start(mnesia),
            snowflake_mnesia:init(),
            {History, State, Result} = run_parallel_commands(?MODULE, Cmds),
            application:stop(mnesia),
            ?WHENFAIL(io:format("History: ~p\nState: ~p\nRes: ~p\n",
                                [History, State, Result]),
                      Result =:= ok)
          end).

id(Dict) ->
  elements(dict:fetch_keys(Dict)).

initial_state() ->
  #state{dict = dict:new()}.

command(#state{dict = Dict}) ->
  oneof(
    [
      {call, snowflake_mnesia, lookup_user, [binary(20)]},
      {call, snowflake_mnesia, add_user, [binary(20), binary(20), binary(20)]},
      {call, snowflake_mnesia, delete_user, [binary(20)]}
    ] 
    ++
    case dict:size(Dict) of
      0 ->
        [];
      _ ->
        [
          {call, snowflake_mnesia, lookup_user,
            [?LET(Id, id(Dict), Id)]},
          {call, snowflake_mnesia, add_user,
            [?LET(Id, id(Dict), Id), binary(20), binary(20)]},
          {call, snowflake_mnesia, delete_user,
            [?LET(Id, id(Dict), Id)]}
        ]
    end
  ).

%% Call -> {call, Module, Function, Args}
precondition(_State, _Call) ->
  true.

postcondition(State, {call, _, lookup_user, [Id]}, Result) ->
  case dict:find(Id, State#state.dict) of
    {ok, User} ->
      Result =:= {ok, User};
    error ->
      Result =:= {error, user_not_found}
  end;
postcondition(State, {call, _, add_user, [Id, _Password, _Group]}, Result) ->
  case dict:is_key(Id, State#state.dict) of
    false ->
      Result =:= ok;
    true ->
      Result =:= {error, already_user_exist}
  end;
postcondition(State, {call, _, delete_user, [Id]}, Result) ->
  case dict:is_key(Id, State#state.dict) of
    false ->
      Result == {error, user_not_found};
    true ->
      Result == ok
  end.

%% {var, integer()}
next_state(State, _Var, {call, _, lookup_user, [_Id]}) -> 
  State;
next_state(#state{dict = Dict} = State, _Var, {call, _, add_user, [Id, Password, Group]}) ->
  case dict:is_key(Id, Dict) of
    true ->
      State;
    false ->
      User = #user{id = Id, password = Password, group = Group},
      State#state{dict = dict:store(Id, User, Dict)}
  end;
next_state(#state{dict = Dict} = State, _Var, {call, _, delete_user, [Id]}) ->
  case dict:is_key(Id, Dict) of
    true ->
      State#state{dict = dict:erase(Id, Dict)};
    false ->
      State
  end.
