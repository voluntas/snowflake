#!/bin/sh
erl -sname snowflake -pa ebin -pa deps/*/ebin -s snowflake
