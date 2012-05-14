all:
	@./rebar update-deps
	@./rebar get-deps
	@./rebar compile
	@./rebar xref skip_deps=true
	@./rebar eunit skip_deps=true

compile:
	@./rebar compile skip_deps=true

xref:
	@./rebar xref skip_deps=true

eunit:
	@./rebar eunit skip_deps=true

clean:
	@./rebar clean skip_deps=true
	rm erl_crash.dump

distclean:
	@./rebar delete-deps
	@./rebar clean

qc:
	@./rebar qc skip_deps=true

release:
	rm -rf rel/snowflake/
	@./rebar compile
	(cd rel && ../rebar generate)
