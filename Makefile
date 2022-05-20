.DEFAULT_GOAL := btlx.analyzer.tr.hfst

btlx.lexd: $(wildcard ava_*.lexd)
	cat btlx.*.lexd > btlx.lexd

# generate analyzer and generator
btlx.analyzer.hfst: btlx.generator.hfst
	hfst-invert btlx.generator.hfst -o btlx.analyzer.hfst
btlx.generator.hfst: btlx.lexd
	lexd btlx.lexd | hfst-txt2fst -o btlx.generator.hfst

# generate transliteraters
cy2la.transliterater.hfst: la2cy.transliterater.hfst
	hfst-invert la2cy.transliterater.hfst -o cy2la.transliterater.hfst
la2cy.transliterater.hfst: correspondence.hfst
	hfst-repeat -f 1 correspondence.hfst -o la2cy.transliterater.hfst
correspondence.hfst: correspondence
	hfst-strings2fst -j correspondence -o correspondence.hfst

# generate analyzer and generator for transcription
btlx.analyzer.tr.hfst: btlx.generator.tr.hfst
	hfst-invert $< -o $@
btlx.generator.tr.hfst: btlx.generator.hfst cy2la.transliterater.hfst
	hfst-compose $^ -o $@

# remove all hfst files
clean:
	rm *.hfst