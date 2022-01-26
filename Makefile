btlx.num.analyzer.hfst: btlx.num.generator.hfst
	hfst-invert btlx.num.generator.hfst -o btlx.num.analyzer.hfst

btlx.num.generator.hfst: btlx.num.lexd
	lexd btlx.num.lexd | hfst-txt2fst -o btlx.num.generator.hfst
