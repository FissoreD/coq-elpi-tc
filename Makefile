opam-enter='eval $$(opam env --switch=. --set-switch)'

create_switch:
	@if [ ! -d "_opam" ]; then \
		echo "Creating OPAM switch 4.14.1..."; \
		opam switch create . 4.14.1; \
	fi
	opam update && opam upgrade
	eval $$(opam env --switch=. --set-switch)
	opam install fileutils ocaml-lsp-server ocamlformat-rpc ocamlformat rocq-stdlib --yes
	$(MAKE) elpi
	$(MAKE) coq-elpi
	$(MAKE) tlc
	$(MAKE) stdpp
	$(MAKE) iris

elpi:
	cd elpi && opam install . --deps-only --yes && $(MAKE) build && opam pin add . --yes

coq-elpi:
	cd coq-elpi && opam install . --deps-only --yes && $(MAKE) build && opam pin add . --yes

stdpp:
	cd stdpp && opam install . --deps-only --yes && $(MAKE) -j && opam pin add . --yes
	
iris:
	cd iris && opam install . --deps-only --yes && $(MAKE) -j && opam pin add . --yes

tlc:
	cd tlc && opam install . --deps-only --yes && $(MAKE) -j && opam pin add . --yes

.PHONY: elpi coq-elpi stdpp iris tlc