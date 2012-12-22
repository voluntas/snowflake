-module(snowflake_wm).

-export([child_spec/3]).

-define(DISPATCH, [{["users"], snowflake_wm_user_list, []},
                   {["users", user_id], snowflake_wm_user, []}]).

child_spec(IP, Port, LogDir) ->
    WMConfig = [{ip, IP},
                {port, Port},
                {log_dir, LogDir},
                {dispatch, ?DISPATCH}],
    {webmachine_mochiweb,
     {webmachine_mochiweb, start, [WMConfig]},
     permanent, 5000, worker, dynamic}.
