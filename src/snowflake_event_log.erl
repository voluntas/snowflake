-module(snowflake_event_log).

-behaviour(gen_event).

-export([init/1, handle_event/2, handle_call/2,
         handle_info/2, terminate/2, code_change/3]).

-record(state, {fd :: file:fd(),
                session_id :: binary(),
                filename :: file:filename()}).

init([Filename, SessionId]) ->
    {ok, Fd} = file:open(Filename, [append, raw, binary]),
    {ok, #state{fd = Fd, session_id = SessionId, filename = Filename}}.

handle_event([_Format, _Args], #state{fd = Fd} = State) ->
    io:format(Fd, "日付: ~w~n", [now()]),
    {ok, State}.

handle_call(_Request, State) ->
    Reply = State,
    {ok, Reply, State}.

handle_info(_Info, State) ->
    {ok, State}.

terminate(_Args, #state{fd = Fd} = _State) ->
    file:close(Fd),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
