#!/bin/bash

./configure \
--with-rebar=rebar3 \
--enable-debug \
--enable-elixir \
--enable-pam \
--enable-pgsql \
--enable-redis \
--enable-tools

make