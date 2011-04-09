%% vim: syn=erlang

-record(user, {id :: binary(),
               password :: binary(),
               groups = [] :: [binary()]}).
