-module(sample_riak_erlang_client_app).

-export([main/1]).

-ifdef(TEST).
-compile(export_all).
-endif.

%% change bucket and key to binaries
main([Op, Bucket, Key|Other]) when is_list(Bucket) ->
    main([Op, list_to_binary(Bucket), Key|Other]);

main([Op, Bucket, Key|Other]) when is_list(Key) ->
    main([Op, Bucket, list_to_binary(Key)|Other]);

%% get
main([_, Bucket, Key]) ->
    {ok, Pid} = riakc_pb_socket:start_link("127.0.0.1", 8087),
    case riakc_pb_socket:get(Pid, Bucket, Key) of
        {ok, Obj} ->
            Value = riakc_obj:get_value(Obj),
            io:format("~s~n", [Value]);
        {error, notfound} ->
            io:format("Not Found~n", [])
    end;

%% put
main([_, Bucket, Key, Value]) ->
    {ok, Pid} = riakc_pb_socket:start_link("127.0.0.1", 8087),
    O = case riakc_pb_socket:get(Pid, Bucket, Key) of
            {ok, Obj} ->
                riakc_obj:update_value(Obj, Value);
            {error, notfound} ->
                riakc_obj:new(Bucket, Key, Value)
        end,
    case riakc_pb_socket:put(Pid, O) of
        ok -> io:format("ok~n", []);
        _ -> io:format("fail~n", [])
    end.
