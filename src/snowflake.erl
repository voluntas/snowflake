-module(snowflake).

-export([main/0]).

main() ->
  {ok, Context} = erlzmq:context(),
  {ok, Client} = erlzmq:socket(Context, [req]),
  ok = erlzmq:setsockopt(Client, identity, pid_to_list(self())),
  ok = erlzmq:connect(Client, "tcp://127.0.0.1:5555"),
  erlzmq:send(Client, <<"Hello">>),
  {ok, Reply} = erlzmq:recv(Client),
  io:format("Reply: ~p", [Reply]),
  ok = erlzmq:close(Client),
  ok = erlzmq:term(Context),
  ok.

-ifdef(TEST).
-endif.
