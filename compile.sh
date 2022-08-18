#!/bin/bash

./autogen.sh

./configure \
--with-rebar=mix \
--enable-debug \
--enable-elixir \
--enable-pam \
--enable-pgsql \
--enable-redis \
--enable-tools


export PATH=/opt/erlang/23.3.4.16/bin:/opt/elixir/bin:$PATH

mix local.hex --force

mix local.rebar --force

mix do deps.get, compile --force