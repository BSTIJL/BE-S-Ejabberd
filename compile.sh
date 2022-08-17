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

export PATH=/opt/elixir/bin:$PATH

mix local.hex local.rebar do deps.get, compile --force