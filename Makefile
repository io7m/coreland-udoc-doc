all: pdf ps dvi html-split html-single css plain nroff

pdf: release/udoc.pdf
ps: release/udoc.ps
dvi: release/udoc.dvi
html-split: release/0.html
html-single: release/udoc.html
css: release/main.css
plain: release/0.txt
nroff: release/0.nrf

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

release/udoc.html: build/0.html image-data css
	(cd src && udoc-render -s 0 -r xhtml main.ud ../build)
	cp build/0.html release/udoc.html

release/0.html: src/main.ud image-data css
	(cd src && udoc-render -s 2 -r xhtml main.ud ../build)
	cp build/*.html release

release/main.css: src/main.css
	cp src/main.css build
	cp build/main.css release

release/0.txt: src/main.ud
	(cd src && udoc-render -r plain main.ud ../build)
	cp build/0.txt release/0.txt

release/0.nrf: src/main.ud
	(cd src && udoc-render -r nroff main.ud ../build)
	cp build/0.nrf release/0.nrf

image-data:
	cp src/*.png build
	cp build/*.png release

clean:
	rm -f build/*
	rm -f release/*

clean-all: clean
