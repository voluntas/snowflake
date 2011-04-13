-module(prop_snowflake_mnesia).

-author('@voluntas').

-export([initial_state/0,
         command/1,
         precondition/2,
         next_state/3,
         postcondition/3]).

-include_lib("proper/include/proper.hrl").
%%-include_lib("eunit/include/eunit.hrl").

-include("snowflake.hrl").

-record(state, {users = [] :: [#user{}]}).

prop_snowflake() ->
  ?FORALL(Cmds,
          commands(?MODULE, initial_state()),
          begin
            error_logger:tty(false),
            application:start(mnesia),
            snowflake_mnesia:init(),
            {History, State, Result} = run_commands(?MODULE, Cmds),
            application:stop(mnesia),
            ?WHENFAIL(io:format("History: ~p\nState: ~p\nRes: ~p\n",
                                [History, State, Result]),
                      aggregate(command_names(Cmds), Result =:= ok)
          end
  ).

initial_state() ->
  #state{}.

command(#state{users = Users}) ->
  oneof(
    [
      {call, snowflake_mnesia, lookup_user, [binary(20)]},
      {call, snowflake_mnesia, add_user, [binary(20), binary(20), binary(20)]},
      {call, snowflake_mnesia, delete_user, [binary(20)]}
    ] 
    ++
    case Users of
      [] ->
        [];
      _ ->
        [
          {call, snowflake_mnesia, delete_user, [?LET(User, elements(Users), User#user.id)]},
          {call, snowflake_mnesia, lookup_user, [?LET(User, elements(Users), User#user.id)]},
          {call, snowflake_mnesia, add_user, [?LET(User, elements(Users), User#user.id),
                                              ?LET(User, elements(Users), User#user.password),
                                              ?LET(User, elements(Users), User#user.groups)]}
        ]
    end
  ).

%% Call -> {call, Module, Function, Args}
precondition(_State, _Call) ->
  true.

%% {var, integer()}
next_state(State, _Var, {call, _, lookup_user, _}) -> 
  State;
next_state(State, _Var, {call, _, add_user, [Id, Password, Group]}) ->
  case lists:keymember(Id, #user.id, State#state.users) of
    true ->
      State;
    false ->
      User = #user{id = Id, password = Password, groups = [Group]},
      State#state{users = [User|State#state.users]}
  end;
next_state(State, _Var, {call, _, delete_user, [Id]}) ->
  case lists:keymember(Id, #user.id, State#state.users) of
    true ->
      Users = lists:keydelete(Id, #user.id, State#state.users),
      State#state{users = Users};
    false ->
      State
  end.

postcondition(State, {call, _, lookup_user, [Id]}, Result) ->
  case lists:keyfind(Id, #user.id, State#state.users) of
    false ->
      Result == {error, user_not_found};
    User ->
      Result == {ok, User}
  end;
postcondition(State, {call, _, add_user, [Id, Password, Group]}, Result) ->
  case lists:keyfind(Id, #user.id, State#state.users) of
    false ->
      Result == {ok, #user{id = Id, password = Password, groups = [Group]}};
    _User ->
      Result == {error, already_user_exist}
  end;
postcondition(State, {call, _, delete_user, [Id]}, Result) ->
  case lists:keyfind(Id, #user.id, State#state.users) of
    false ->
      Result == {error, user_not_found};
    User ->
      Result == {ok, User}
  end.

