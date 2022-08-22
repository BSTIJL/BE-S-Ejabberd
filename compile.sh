#!/bin/sh

export PATH=/opt/erlang/23.3.4.16/bin:/opt/elixir/bin:$PATH

./autogen.sh

./configure \
--with-rebar=rebar3 \
-enable-new-sql-schema \
--enable-debug \
--enable-pgsql \
--enable-redis \
--enable-tools

make clean

make rel

cp -dfr _build/prod/rel/ejabberd/lib app/