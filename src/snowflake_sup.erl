-module(snowflake_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->

    IP = {0,0,0,0},
    Port = 8080,
    LogDir = "priv/log",

    ChildSpec = snowflake_wm:child_spec(IP, Port, LogDir),
    {ok, { {one_for_one, 5, 10}, [ChildSpec]} }.
