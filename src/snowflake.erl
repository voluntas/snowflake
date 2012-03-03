-module(snowflake).

-export([main/0]).

main() ->
  application:start(erlzmq),
  application:start(jiffy),
  {ok, Context} = erlzmq:context(),
  {ok, Client} = erlzmq:socket(Context, [req]),
  ok = erlzmq:setsockopt(Client, identity, pid_to_list(self())),
  ok = erlzmq:connect(Client, "tcp://127.0.0.1:5555"),
  Request = jiffy:encode({[{foo, [<<"bing">>, 2.3, true]}]}),
  io:format("Request(encoded): ~w", [Request]),
  erlzmq:send(Client, Request),
  {ok, Reply} = erlzmq:recv(Client),
  Term = jiffy:decode(Reply),
  io:format("Reply(decoded): ~w", [Term]),
  ok = erlzmq:close(Client),
  ok = erlzmq:term(Context),
  ok.

-ifdef(TEST).
-endif.
