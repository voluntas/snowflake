-module(zmq_subscriber).

-behaviour(gen_server).

-define(SERVER, ?MODULE).

-define(DEFAULT_PUB, "tcp://127.0.0.1:5000").

-record(state, {zmq_context :: any(),
                zmq_socket :: any()}).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(_Args) ->
  {ok, Context} = erlzmq:context(),
  {ok, Socket} = erlzmq:socket(Context, [sub, {active, true}]),
  ok = erlzmq:connect(Socket, ?DEFAULT_PUB),
  {ok, #state{zmq_context = Context, zmq_socket = Socket}}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info({zmq, _S, [pollin]}, State) ->
  {ok, Msg} = erlzmq:recv(State#state.zmq_socket),
  Data = jiffy:decode(Msg),
  io:format("~p: ~p", [self(), Data]),
  {noreply, State};
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, State) ->
  ok = erlzmq:close(State#state.zmq_socket),
  ok = erlzmq:term(State#state.zmq_context),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

