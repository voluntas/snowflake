-module(snowflake_logger).

-export([init/0]).

-export([start/1, stop/0, notify/2]).

-export_type([session_id/0]).

-include_lib("eunit/include/eunit.hrl").

-define(TABLE, snowflake_logger_table).

-type session_id() :: binary().

-spec init() -> ok.
init() ->
    _Tid = ets:new(?TABLE, [set, named_table, public]),
    ?debugVal(_Tid),
    ok.

-spec start(session_id()) -> ok.
start(SessionId) ->
    %% TODO(nakai): Filename を SessionId から生成する
    Filename = SessionId,
    {ok, Pid} = gen_event:start(),
    ok = gen_event:add_handler(Pid, snowflake_event_log, [Filename, SessionId]),
    %% self() を使って Pid と関連付ける
    true = ets:insert(?TABLE, {self(), Pid}),
    ok.

-spec stop() -> ok.
stop() ->
    [{_, Pid}] = ets:lookup(?TABLE, self()),
    true = ets:delete(?TABLE, self()),
    ok = gen_event:delete_handler(Pid, snowflake_event_log, []).

-spec notify(iolist(), [any()]) -> ok.
notify(Format, Args) ->
    %% FIXME(nakai): 実装は適当です、例外起きたことのこと考えてない
    [{_, Pid}] = ets:lookup(?TABLE, self()),
    ok = gen_event:sync_notify(Pid, [Format, Args]).
