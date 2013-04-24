.PHONY: all compile deps clean test devrel rel

REBAR_CONFIG = rebar.config

APP_NAME = snowflake

all: clean deps test

deps: get-deps update-deps
	@./rebar -C $(REBAR_CONFIG) compile

update-deps:
	@./rebar -C $(REBAR_CONFIG) update-deps

get-deps:
	@./rebar -C $(REBAR_CONFIG) get-deps

compile:
	@./rebar -C $(REBAR_CONFIG) compile skip_deps=true
	@./rebar -C $(REBAR_CONFIG) xref skip_deps=true

devrel: rel
	$(foreach dep,$(wildcard deps/*), rm -rf dev/$(APP_NAME)/lib/$(shell basename $(dep))-* && ln -sf $(abspath $(dep)) dev/$(APP_NAME)/lib;)
	rm -rf dev/$(APP_NAME)/lib/$(APP_NAME)-*
	rm -rf dev/$(APP_NAME)/lib/$(APP_NAME)
	mkdir dev/$(APP_NAME)/lib/$(APP_NAME)
	ln -sf $(abspath ebin) dev/$(APP_NAME)/lib/$(APP_NAME)/ebin
	ln -sf $(abspath priv) dev/$(APP_NAME)/lib/$(APP_NAME)/priv

rel: compile
	mkdir -p dev
	mkdir -p deps
	(cd rel && rm -rf ../dev/$(APP_NAME) && ../rebar generate target_dir=../dev/$(APP_NAME))

test:
	rm -rf .eunit
	@./rebar -C $(REBAR_CONFIG) eunit skip_deps=true

clean:
	@./rebar -C $(REBAR_CONFIG) clean skip_deps=true

distclean: clean
	@./rebar -C $(REBAR_CONFIG) clean
	@./rebar -C $(REBAR_CONFIG) delete-deps
	rm -rf dev

dialyze-init:
	dialyzer --build_plt --apps erts kernel stdlib mnesia crypto public_key snmp reltool
	dialyzer --add_to_plt --plt ~/.dialyzer_plt --output_plt $(APP_NAME).plt -c .
	dialyzer -c ebin -Wunmatched_returns -Werror_handling -Wrace_conditions -Wunderspecs

dialyze: compile
	dialyzer --check_plt --plt $(APP_NAME).plt -c .
	dialyzer -c ebin

watch:
	watchmedo shell-command --patterns="*.erl;*.hrl" \
                  --recursive --wait --command="make compile" \
                  src include test
