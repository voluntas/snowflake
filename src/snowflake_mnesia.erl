-module(snowflake_mnesia).

-author('@voluntas').

-export([init/0]).

-export([lookup_user/1,
         add_user/3,
         delete_user/1]).

-include_lib("eunit/include/eunit.hrl").

-include("snowflake.hrl").

-define(USER_TABLE, snowflake_mnesia_user_table).

init() ->
  mnesia:create_table(?USER_TABLE, [{record_name, user}, {attributes, record_info(fields, user)}]).

add_user(Id, Password, Group) ->
  F = fun() ->
        case mnesia:read(?USER_TABLE, Id, read) of
          [] ->
            User = #user{id = Id, password = Password, groups = [Group]},
            mnesia:write(?USER_TABLE, User, sticky_write),
            {ok, User};
          [_User] ->
            {error, already_user_exist}
        end
      end,
  mnesia:activity(transaction, F).

lookup_user(Id) ->
  case mnesia:activity(transaction,
                       fun mnesia:read/3,
                       [?USER_TABLE, Id, read]) of
    [] ->
      {error, user_not_found};
    [User] ->
      {ok, User}
  end.

delete_user(Id) ->
  F = fun() ->
        case mnesia:read(?USER_TABLE, Id, read) of
          [] ->
            {error, user_not_found};
          [User] ->
            mnesia:delete(?USER_TABLE, Id, sticky_write),
            {ok, User}
        end
      end,
  mnesia:activity(transaction, F).

-ifdef(TEST).
-endif.

