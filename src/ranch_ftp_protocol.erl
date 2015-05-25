-module(ranch_ftp_protocol).
-export([start_link/4, init/3]).

start_link(ListenerPid, Socket, Transport, _Opts) ->
    Pid = spawn_link(?MODULE, init, [ListenerPid, Socket, Transport]),
    {ok, Pid}.

init(ListenerPid, Socket, Transport) ->
    ok = ranch:accept_ack(ListenerPid),
    io:format("Got a connection!~n"),
    Transport:send(Socket, <<"200 My cool Ftp server welcomes you!\r\n">>),
    {ok, Data} = Transport:recv(Socket, 0, 30000),
    auth(Socket, Transport, Data),
    loop(Socket, Transport).
auth(Socket, Transport, <<"USER ", Rest/bits>>) ->
    io:format("User authenticated! ~p~n", [Rest]),
    Transport:send(Socket, <<"230 Auth OK\r\n">>),
    ok.

loop(Socket, Transport) ->
    case Transport:recv(Socket, 0, 30000) of
        {ok, Data} ->
            handle(Socket, Transport, Data),
            loop(Socket, Transport);
        {error, _} ->
            io:format("The client disconnected~n")
    
    end.

handle(Socket, Transport, Data) ->
    io:format("Command receive ~p~n", [Data]),
    Transport:send(Socket, <<"500 Bad command\r\n">>).
