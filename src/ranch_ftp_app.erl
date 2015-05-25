-module(ranch_ftp_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    ranch_ftp_sup:start_link().

stop(_State) ->
    ok.
