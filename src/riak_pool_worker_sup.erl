-module(riak_pool_worker_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-include_lib("eunit/include/eunit.hrl").

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    %% TODO: settings
    Pools = [
        {pool1,
            [
                {size, 100},
                {max_overflow, 150}
            ],
            [
                {ip_address, "127.0.0.1"},
                {port_number, 8081}
            ]
        }
        %% {pool2,
        %%     [
        %%         {size, 100},
        %%         {max_overflow, 150}
        %%     ],
        %%     [
        %%         {ip_address, "127.0.0.1"},
        %%         {port_number, 8082}
        %%     ]
        %% }
    ],
    F = fun({Name, SizeArgs, WorkerArgs}) ->
                PoolArgs = [{name, {local, Name}},
                            {worker_module, riak_pool_worker}] ++ SizeArgs,
                poolboy:child_spec(Name, PoolArgs, WorkerArgs)
        end,
    PoolSpecs = lists:map(F, Pools),
    {ok, { {one_for_one, 5, 10}, PoolSpecs} }.


