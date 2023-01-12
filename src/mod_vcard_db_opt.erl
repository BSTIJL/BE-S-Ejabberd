%% Generated automatically
%% DO NOT EDIT: run `make options` instead

-module(mod_vcard_db_opt).

-export([s3_proxy_server/1]).

-spec s3_proxy_server(gen_mod:opts() | global | binary()) -> binary().
s3_proxy_server(Opts) when is_map(Opts) ->
    gen_mod:get_opt(s3_proxy_server, Opts);
s3_proxy_server(Host) ->
    gen_mod:get_module_opt(Host, mod_vcard, s3_proxy_server).

