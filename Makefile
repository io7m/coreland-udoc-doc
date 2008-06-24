all: pdf ps dvi

pdf: release/udoc.pdf
ps: release/udoc.ps
dvi: release/udoc.dvi

build/0.tex: src/main.ud
	(cd src && udoc -s 1 -r context main.ud ../build)

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

clean:
	rm -f build/*
