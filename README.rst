###########################
Riak Pool Example
###########################

riak_pool::

    $ erl -pa ebin -pa deps/*/ebin
    Erlang R15B01 (erts-5.9.1) [source] [64-bit] [smp:4:4] [async-threads:0] [kernel-poll:false] [dtrace]

    Eshell V5.9.1  (abort with ^G)
    1> application:start(snowflake).
    ok
    2> Obj = riakc_obj:new(<<"groceries">>, <<"mine">>, <<"eggs & bacon">>).
    {riakc_obj,<<"groceries">>,<<"mine">>,undefined,[],
               undefined,<<"eggs & bacon">>}
    3> riak_pool:put(Obj).
    ok
    4> riak_pool:get(<<"groceries">>, <<"mine">>).
    {ok,{riakc_obj,<<"groceries">>,<<"mine">>,
                   <<107,206,97,96,96,96,204,96,202,5,82,28,71,131,54,114,7,
                     88,125,121,151,193,148,...>>,
                   [{{dict,2,16,16,8,80,48,
                           {[],[],[],[],[],[],[],[],[],[],[],[],...},
                           {{[],[],[],[],[],[],[],[],[],[],...}}},
                     <<"eggs & bacon">>}],
                   undefined,undefined}}
