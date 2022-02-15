.DEFAULT_GOAL := btlx.num.generator.tr.hfst

# generate analyzer and generator
btlx.num.analyzer.hfst: btlx.num.generator.hfst
	hfst-invert btlx.num.generator.hfst -o btlx.num.analyzer.hfst
btlx.num.generator.hfst: btlx.num.lexd
	lexd btlx.num.lexd | hfst-txt2fst -o btlx.num.generator.hfst

# generate transliteraters
cy2la.transliterater.hfst: la2cy.transliterater.hfst
	hfst-invert la2cy.transliterater.hfst -o cy2la.transliterater.hfst
la2cy.transliterater.hfst: correspondence.hfst
	hfst-repeat -f 1 correspondence.hfst -o la2cy.transliterater.hfst
correspondence.hfst: correspondence
	hfst-strings2fst -j correspondence -o correspondence.hfst

# generate analyzer and generator for transcription
btlx.num.analyzer.tr.hfst: btlx.num.generator.tr.hfst
	hfst-invert $< -o $@
btlx.num.generator.tr.hfst: btlx.num.generator.hfst cy2la.transliterater.hfst
	hfst-compose $^ -o $@

# remove all hfst files
clean:
	rm *.hfst