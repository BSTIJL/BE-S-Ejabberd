#!/bin/bash

./configure \
--with-rebar=rebar3 \
--enable-debug \
--enable-elixir \
--enable-pgsql \
--enable-redis \
--enable-tools

make