all: compile xref eunit

compile:
	@./rebar compile skip_deps=true

xref:
	@./rebar xref skip_deps=true

eunit:
	@./rebar eunit skip_deps=true

clean:
	@./rebar clean skip_deps=true

distclean:
	@./rebar delete-deps
	@./rebar clean

qc:
	@./rebar compile skip_deps=true
	@./rebar qc skip_deps=true

build:
	@./rebar get-deps
	@./rebar update-deps
	@./rebar compile
	@./rebar xref
