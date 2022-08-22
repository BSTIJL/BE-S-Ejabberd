#!/bin/sh

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