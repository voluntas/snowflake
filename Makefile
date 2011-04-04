all: compile xref eunit

compile:
	@./rebar compile skip_deps=true

xref:
	@./rebar xref skip_deps=true

eunit:
	@./rebar eunit skip_deps=true

qc:
	@./rebar qc skip_deps=true

build:
	@./rebar get-deps
	@./rebar update-deps
	@./rebar compile
	@./rebar xref
