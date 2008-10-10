all: pdf ps dvi html-split html-single css plain nroff

name = udoc

pdf: release/$(name).pdf
ps: release/$(name).ps
dvi: release/$(name).dvi
html-split: release/0.html
html-single: release/$(name).html
css: release/main.css
plain: release/$(name).txt
nroff: release/$(name).nrf

generated_sources = src/m_docid.ud src/m_docid.txt src/m_pkg.ud src/m_supp.ud \
	src/m_title.ud src/m_title.txt

#----------------------------------------------------------------------
# meta

src/m_docid.txt: src/m_docid.sh
	(cd src && ./m_docid.sh > m_docid.txt.tmp && mv m_docid.txt.tmp m_docid.txt)
src/m_docid.ud: src/m_docid_ud.sh src/m_docid.txt
	(cd src && ./m_docid_ud.sh > m_docid.ud.tmp && mv m_docid.ud.tmp m_docid.ud)
src/m_pkg.ud: src/m_pkg_ud.sh src/m_pkg.txt
	(cd src && ./m_pkg_ud.sh > m_pkg.ud.tmp && mv m_pkg.ud.tmp m_pkg.ud)
src/m_supp.ud: src/m_supp.sh
	(cd src && ./m_supp.sh m_supp.txt > m_supp.ud.tmp && mv m_supp.ud.tmp m_supp.ud)
src/m_title.txt: src/m_title.sh src/m_pkg.txt
	(cd src && ./m_title.sh > m_title.txt.tmp && mv m_title.txt.tmp m_title.txt)
src/m_title.ud: src/m_title_ud.sh src/m_title.txt
	(cd src && ./m_title_ud.sh > m_title.ud.tmp && mv m_title.ud.tmp m_title.ud)

#----------------------------------------------------------------------

build/0.tex: src/main.ud $(generated_sources)
	(cd src && udoc-render -s 1 -r context main.ud ../build)

build/$(name).dvi: build/0.tex $(generated_sources)
	(cd build && texexec 0.tex && mv 0.dvi $(name).dvi)
release/$(name).dvi: build/$(name).dvi
	cp build/$(name).dvi release/$(name).dvi

build/$(name).pdf: build/0.tex
	(cd build && texexec --pdf 0.tex && mv 0.pdf $(name).pdf)
release/$(name).pdf: build/$(name).pdf
	cp build/$(name).pdf release/$(name).pdf

build/$(name).ps: build/$(name).pdf
	(cd build && pdf2ps $(name).pdf $(name).ps)
release/$(name).ps: build/$(name).ps
	cp build/$(name).ps release/$(name).ps

release/$(name).html: src/main.ud $(generated_sources)
	(cd src && udoc-render -s 0 -r xhtml main.ud ../build)
	cp build/0.html release/$(name).html

release/0.html: src/main.ud $(generated_sources)
	(cd src && udoc-render -s 2 -r xhtml main.ud ../build)
	cp build/*.html release

release/main.css: src/main.css
	cp src/main.css build
	cp build/main.css release

release/$(name).txt: src/main.ud $(generated_sources)
	(cd src && udoc-render -r plain main.ud ../build)
	cp build/0.txt release/$(name).txt

release/$(name).nrf: src/main.ud $(generated_sources)
	(cd src && udoc-render -r nroff main.ud ../build)
	cp build/0.nrf release/$(name).nrf

image-data:
	cp src/*.png build
	cp build/*.png release

#----------------------------------------------------------------------

clean:
	rm -f $(generated_sources)
	rm -f build/*
	rm -f release/*

clean-all: clean
