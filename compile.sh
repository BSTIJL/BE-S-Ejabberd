#!/bin/sh

export PATH=/opt/elixir/bin:/opt/erlang/23.3.4.16/bin:$PATH

./autogen.sh

./configure \
--with-rebar=rebar3 \
-enable-new-sql-schema \
--enable-debug \
--enable-pgsql \
--enable-redis \
--enable-tools

make clean

make