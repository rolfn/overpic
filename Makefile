# Rolf Niepraschk, 2026-01-07, Rolf.Niepraschk@gmx.de

.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

MAIN = overpic

PDFLATEX = pdflatex
TEX = tex
LATEX = latex

VERSION = $(shell awk '/ProvidesPackage/ {print $$2}' $(MAIN).dtx)

DIST_DIR = $(MAIN)
DIST_FILES = README.md README.de.md $(MAIN).pdf $(MAIN).dtx $(MAIN).ins
ARCHNAME = $(MAIN)-$(VERSION).zip

all : $(MAIN).sty

$(MAIN).sty : $(MAIN).dtx
	$(TEX) $(basename $<).ins

$(MAIN)-readme.pdf $(MAIN)-readme-de.pdf : $(MAIN)-readme.tex $(MAIN).sty
	$(PDFLATEX) $<

$(MAIN).pdf : $(MAIN).dtx $(MAIN).sty
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(PDFLATEX) $<
	$(PDFLATEX) $<

dist : $(DIST_FILES)
	rm -rf $(DIST_DIR) $(ARCHNAME)
	mkdir -p $(DIST_DIR)
	cp -p $+ $(DIST_DIR)
	zip $(ARCHNAME) -r $(DIST_DIR)
	rm -rf $(DIST_DIR)

clean :
	$(RM) *.aux *.log *.glg *.glo *.gls *.idx *.ilg *.ind *.toc

veryclean : clean
	$(RM) $(MAIN).pdf $(MAIN).sty $(ARCHNAME)

debug :
	@echo $(ARCHNAME)
