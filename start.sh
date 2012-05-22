#!/bin/sh
erl -boot start_sasl -sname snowflake -pa ebin -pa deps/*/ebin -s snowflake

