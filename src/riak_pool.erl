-module(riak_pool).

-export([get/2, put/1, delete/2]).

-define(DEFAULT_POOL_NAME, pool1).

-spec pool_name() -> atom().
pool_name() ->
    ?DEFAULT_POOL_NAME.

get(Bucket, Key) ->
    transaction(pool_name(), {get, Bucket, Key}).

put(Object) ->
    transaction(pool_name(), {put, Object}).

delete(Bucket, Key) ->
    transaction(pool_name(), {delete, Bucket, Key}).

transaction(PoolName, Term) ->
    F = fun(Worker) ->
                gen_server:call(Worker, Term)
        end,
    poolboy:transaction(PoolName, F).
