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
        case mnesia:read(?USER_TABLE, Id) of
          [] ->
            User = #user{id = Id, password = Password, group = Group},
            mnesia:write(?USER_TABLE, User, sticky_write);
          [_User] ->
            {error, already_user_exist}
        end
      end,
  mnesia:activity(async_dirty, F).

lookup_user(Id) ->
  case mnesia:activity(async_dirty,
                       fun mnesia:read/2,
                       [?USER_TABLE, Id]) of
    [] ->
      {error, user_not_found};
    [User] ->
      {ok, User}
  end.

delete_user(Id) ->
  F = fun() ->
        case mnesia:read(?USER_TABLE, Id) of
          [] ->
            {error, user_not_found};
          [_User] ->
            mnesia:delete(?USER_TABLE, Id, sticky_write)
        end
      end,
  mnesia:activity(async_dirty, F).

-ifdef(TEST).
-endif.

