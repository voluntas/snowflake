-module(snowflake_user).

-export([new/0]).
-export([assign/2, delete/1, lookup/1, key_list/0]).

-export_type([user_id/0, password/0]).

-include("snowflake_user.hrl").

-type user_id() :: binary().
-type password() :: binary().

-define(USER_TABLE, snowflake_user_table).

-spec new() -> ok.
new() ->
    _Tid = ets:new(?USER_TABLE, [named_table, {keypos, #user.id}, public, set]),
    ok.

-spec assign(user_id(), password()) -> ok.
assign(UserId, Password) ->
    true = ets:insert(?USER_TABLE, #user{id = UserId, password = Password}),
    ok.

-spec delete(user_id()) -> ok | {error, missing_user_id}.
delete(UserId) ->
    case lookup(UserId) of
        not_found ->
            {error, missing_user_id};
        _User ->
            true = ets:delete(UserId),
            ok
    end.

-spec lookup(user_id()) -> not_found | #user{}.
lookup(UserId) ->
    case ets:lookup(?USER_TABLE, UserId) of
        [] ->
            not_found;
        [User] ->
            User
    end.

-spec key_list() -> [user_id()].
key_list() ->
    [ User#user.id || User <- ets:tab2list(?USER_TABLE) ].
