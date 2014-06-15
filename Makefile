# Rolf Niepraschk, 2014-06-15, Rolf.Niepraschk@gmx.de

.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

MAIN = overpic

PDFLATEX = pdflatex
TEX = tex
LATEX = latex

VERSION = $(shell awk -F"[{}]" '/fileversion/ {print $$2}' $(MAIN).dtx)

DIST_DIR = $(MAIN)
DIST_FILES = README README.de $(MAIN).sty
ARCHNAME = $(MAIN)-$(VERSION).zip

all : $(MAIN).sty

$(MAIN).sty : $(MAIN).dtx
	$(TEX) $(basename $<).ins

$(MAIN)-manual.pdf : $(MAIN)-manual.tex $(MAIN).sty
	$(PDFLATEX) $<

$(MAIN).pdf : $(MAIN).dtx
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(PDFLATEX) $<
	$(PDFLATEX) $<

% : %.md
	cat $< | awk '/^```/ {$$0=""} \
     /is also/ {exit} \
     {print}' > $@

dist : $(DIST_FILES)
	mkdir -p $(DIST_DIR)
	cp -p $+ $(DIST_DIR)
	zip $(ARCHNAME) -r $(DIST_DIR)
	rm -rf $(DIST_DIR)

clean :
	$(RM) *.aux *.log *.glg *.glo *.gls *.idx *.ilg *.ind *.toc

veryclean : clean
	$(RM) $(MAIN).pdf $(MAIN)-manual.pdf $(MAIN).sty README $(ARCHNAME)

debug :
	@echo $(ARCHNAME)
