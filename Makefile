all: pdf ps dvi html-split html-single css

pdf: release/udoc.pdf
ps: release/udoc.ps
dvi: release/udoc.dvi
html-split: release/0.html
html-single: release/udoc.html
css: release/main.css

build/0.tex: src/main.ud
	(cd src && udoc-render -s 1 -r context main.ud ../build)

build/udoc.dvi: build/0.tex
	(cd build && texexec --batch 0.tex && mv 0.dvi udoc.dvi)
release/udoc.dvi: build/udoc.dvi
	cp build/udoc.dvi release/udoc.dvi

build/udoc.pdf: build/0.tex
	(cd build && texexec --batch --pdf 0.tex && mv 0.pdf udoc.pdf)
release/udoc.pdf: build/udoc.pdf
	cp build/udoc.pdf release/udoc.pdf

build/udoc.ps: build/udoc.pdf
	(cd build && pdf2ps udoc.pdf udoc.ps)
release/udoc.ps: build/udoc.ps
	cp build/udoc.ps release/udoc.ps

release/udoc.html: build/0.html image-data
	(cd src && udoc-render -s 0 -r xhtml main.ud ../build)
	cp build/0.html release/udoc.html

release/0.html: src/main.ud image-data
	(cd src && udoc-render -s 2 -r xhtml main.ud ../build)
	cp build/*.html release

release/main.css: src/main.css
	cp src/main.css build
	cp build/main.css release

image-data:
	cp src/*.png build
	cp build/*.png release

clean:
	rm -f build/*
	rm -f release/*

clean-all: clean
