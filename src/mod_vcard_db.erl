%%%-------------------------------------------------------------------
%%%
%%%----------------------------------------------------------------------

-module(mod_vcard_db).

-behaviour(mod_vcard).

%% API
-export([init/2, stop/1, get_vcard/2, set_vcard/4, search/4, remove_user/2,
	 search_fields/1, search_reported/1, import/3, export/1]).
-export([is_search_supported/1]).

-export([mod_opt_type/1, mod_options/1, mod_doc/0]).

-include_lib("xmpp/include/xmpp.hrl").
-include("mod_vcard.hrl").
-include("logger.hrl").
-include("ejabberd_sql_pt.hrl").
-include("translate.hrl").

%%%===================================================================
%%% API
%%%===================================================================
init(_Host, _Opts) ->
  ok.

stop(_Host) ->
  ok.

is_search_supported(_LServer) ->
  false.

get_vcard(LUser, LServer) ->
  case ejabberd_sql:sql_query(
	   LServer,
	   ?SQL("select "
	          " @(chat_only_bio)s, "
            " @(chat_only_profession)s, "
            " @(chat_only_profile_name)s, "
            " @(chat_only_profile_photo)s, "
            " @(chat_only_region)s, "
            " @(chat_only_website)s "
          " from v_vcard "
          "  where username=%(LUser)s ")) of
	{selected, [{Bio, Profession, Name, Photo, Region, Website}]} ->
    BaseUrl = mod_vcard_db_opt:s3_proxy_server(LServer),
    PhotoUrl = case Photo of
      null ->
        <<>>;
      _ ->
        <<BaseUrl/binary, Photo/binary>>
    end,
    Vcard =
      [#xmlel{name = <<"vCard">>,
        attrs = [{<<"xmlns">>, ?NS_VCARD}],
        children = [
          #xmlel{name = <<"bio">>, children = [{xmlcdata, null_to_empty(Bio)}]},
          #xmlel{name = <<"profession">>, children = [{xmlcdata, null_to_empty(Profession)}]},
          #xmlel{name = <<"name">>, children = [{xmlcdata, null_to_empty(Name)}]},
          #xmlel{name = <<"photo">>, children = [{xmlcdata, PhotoUrl}]},
          #xmlel{name = <<"region">>, children = [{xmlcdata, null_to_empty(Region)}]},
          #xmlel{name = <<"website">>, children = [{xmlcdata, null_to_empty(Website)}]}
        ]}],
    {ok, Vcard};
	{selected, []} -> {ok, []};
	  _ -> error
  end.

null_to_empty(Value) when is_atom(Value) ->
  <<>>;
null_to_empty(Value) ->
  Value.

set_vcard(_LUser, _LServer, _VCard, _VCardSearch) ->
  {atomic, not_implemented}.

search(_LServer, _Data, _AllowReturnAll, _MaxMatch) ->
  {atomic, not_implemented}.

search_fields(_LServer) ->
  {atomic, not_implemented}.

search_reported(_LServer) ->
  {atomic, not_implemented}.

remove_user(_LUser, _LServer) ->
  {atomic, not_implemented}.

export(_Server) ->
  ok.

import(_, _, _) ->
  ok.

mod_opt_type(s3_proxy_server) ->
  econf:binary().

mod_options(_) ->
  [{s3_proxy_server, undefined}].

mod_doc() ->
  #{opts =>
  [{s3_proxy_server,
    #{value => "S3 proxy server's URL.",
      desc =>
      ?T("The S3 proxy server's url.")}}]}.