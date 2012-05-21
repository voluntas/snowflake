-module(snowflake_logger).

-export([init/0]).

-export([start/1, stop/0, notify/2]).

-export_type([session_id/0]).

-type session_id() :: binary().

-spec init() -> ok.
init() ->
    _Tid = ets:new(snowflake_logger_table, [set, named_table]),
    ok.

-spec start(session_id()) -> ok.
start(SessionId) ->
    %% TODO(nakai): Filename を SessionId から生成する
    Filename = SessionId,
    {ok, Pid} = gen_event:start(),
    ok = gen_event:add_handler(Pid, snowflake_event_log, [Filename, SessionId]),
    %% self() を使って Pid と関連付ける
    true = ets:insert(snowflake_logger_table, {self(), Pid}),
    ok.

-spec stop() -> ok.
stop() ->
    [{_, Pid}] = ets:lookup(snowflake_logger_table, self()),
    true = ets:delete(snowflake_logger_table, self()),
    ok = gen_event:delete_handler(Pid, snowflake_event_log, []).

-spec notify(iolist(), [any()]) -> ok.
notify(Format, Args) ->
    %% FIXME(nakai): 実装は適当です、例外起きたことのこと考えてない
    [{_, Pid}] = ets:lookup(snowflake_logger_table, self()),
    ok = gen_event:sync_notify(Pid, [Format, Args]).
