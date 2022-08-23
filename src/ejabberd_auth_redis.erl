%%%-------------------------------------------------------------------
%%% File    : ejabberd_auth_redis.erl
%%% Purpose : Redis authentication
%%%-------------------------------------------------------------------
-module(ejabberd_auth_redis).

-author('defeng.liang.cn@gmail.com').

-define(TOKEN_PREFIX, <<"token_">>).
-define(USER_PREFIX, <<"user_">>).

-behaviour(ejabberd_auth).

-export([start/1, stop/1,
	check_password/4,
	user_exists/2,
	store_type/1,
	get_password/2,
	plain_password_required/1]).

-include_lib("xmpp/include/scram.hrl").
-include("logger.hrl").

start(_Host) ->
	ok.

stop(_Host) ->
	ok.

check_password(User, _AuthzId, _Host, Password) ->
	Key = <<?TOKEN_PREFIX/binary, User/binary>>,
	case ejabberd_redis:get(Key) of
		{ok, Password} ->
			true;
		_ ->
			false
	end.

user_exists(User, _Host) ->
	Key = <<?TOKEN_PREFIX/binary, User/binary>>,

%% TODO
%%	Req = "",
%%	HttpOpts = [],
%%	Result = try httpc:request(post, Req, HttpOpts, [{body_format, binary}]) of
%%						 {ok, {{_, Code, _}, RetHdrs, <<"true">>}} ->
%%							 true;
%%						 {error, Reason} ->
%%							 ?WARNING_MSG("http request error - ~p~n", [Reason]),
%%							 false
%%					 catch
%%						 exit:Reason ->
%%							 ?WARNING_MSG("http request error - ~p~n", [Reason]),
%%							 false
%%					 end,
	case ejabberd_redis:get(Key) of
		{ok, _} ->
			true;
		_ ->
			false
	end.

get_password(User, _Server) ->
	Key = <<?TOKEN_PREFIX/binary, User/binary>>,
	case ejabberd_redis:get(Key) of
		{ok, Tokens} ->
			NewToken = list_to_binary(string:replace(Tokens, "\"","",all)),
			TokenList = binary:split(NewToken, <<",">>, [global]),
			?DEBUG("TokenList - ~p~n", [TokenList]),
			case TokenList of
				[Password, <<>>, <<>>, <<"0">>] ->
					{cache, {ok, Password}};
				[StoredKey, ServerKey, Salt, IterationCount] ->
					{Hash, SK} = case StoredKey of
												 <<"sha256:", Rest/binary>> -> {sha256, Rest};
												 <<"sha512:", Rest/binary>> -> {sha512, Rest};
												 Other -> {sha, Other}
											 end,
					{cache, {ok, #scram{storedkey = SK,
						serverkey = ServerKey,
						salt = Salt,
						hash = Hash,
						iterationcount = binary_to_integer(IterationCount)}}};
				_ ->
					{nocache, error}
			end;
		_ ->
			false
	end.

plain_password_required(_) -> false.

store_type(_) -> scram.