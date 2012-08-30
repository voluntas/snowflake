-module(riak_pool_worker).

-behaviour(gen_server).
-behaviour(poolboy_worker).

-export([start_link/1]).
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-include_lib("eunit/include/eunit.hrl").

-record(state, {pid :: pid()}).

start_link(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->
    IPAddress = proplists:get_value(ip_address, Args),
    PortNumber = proplists:get_value(port_number, Args),
    {ok, Pid} = riakc_pb_socket:start_link(IPAddress, PortNumber),
    %% TODO: riak_pb_socket:ping(Pid),
    {ok, #state{pid = Pid}}.

handle_call({put, Object}, _From, #state{pid = Pid} = State) ->
    {reply, riakc_pb_socket:put(Pid, Object), State};
handle_call({get, Bucket, Key}, _From, #state{pid = Pid} = State) ->
    {reply, riakc_pb_socket:get(Pid, Bucket, Key), State};
handle_call({delete, Bucket, Key}, _From, #state{pid = Pid} = State) ->
    {reply, riakc_pb_socket:delete(Pid, Bucket, Key), State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, #state{pid = Pid}) ->
    ok = riak_pb_socket:stop(Pid),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
