# between main and main2, we should set the swith

main:
	$(MAKE) create_switch 
	
main2:
	$(MAKE) update-upgrade && $(MAKE) build_deps

create_switch:
	@if [ ! -d "_opam" ]; then \
		echo "Creating OPAM switch 4.14.1..."; \
		opam switch create . 4.14.1; \
	fi

update-upgrade:
	opam switch && opam update && opam upgrade
	opam install fileutils ocaml-lsp-server ocamlformat-rpc ocamlformat rocq-stdlib --yes

build_deps:
	$(MAKE) elpi
	$(MAKE) coq-elpi
	$(MAKE) tlc
	$(MAKE) stdpp
	$(MAKE) iris

opam-enter:
	eval $$(opam env --switch=. --set-switch)

elpi:
	cd elpi && opam install . --deps-only --yes && $(MAKE) build && opam pin add . --yes

coq-elpi:
	cd coq-elpi && opam install . --deps-only --yes && $(MAKE) build && $(MAKE) install

stdpp:
	cd stdpp && opam install . --deps-only --yes && $(MAKE) -j && $(MAKE) install
	
iris:
	cd iris && opam install . --deps-only --yes && $(MAKE) -j && $(MAKE) install

tlc:
	cd tlc && opam install . --deps-only --yes && $(MAKE) -j && opam pin add . --yes

.PHONY: elpi coq-elpi stdpp iris tlc