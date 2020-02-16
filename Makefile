## All Rmarkdown files in the working directory
SRC = $(wildcard *.Rmd)

## Location of Pandoc binaries
PANDOC = /usr/local/bin
#PANDOC = /Users/kjhealy/Source/pandoc-crossref/.cabal-sandbox/bin

## Location of Pandoc support files.
PREFIX = /Users/kjhealy/.pandoc

## Location of your working bibliography file
BIB = /Users/kjhealy/Documents/bibs/socbib-pandoc.bib

## This directory
LOCAL = /Users/kjhealy/Documents/data/fin-capability/svyglm

## CSL stylesheet (located in the csl folder of the PREFIX directory).
CSL = apsa

## Pandoc options to use
OPTIONS = markdown+simple_tables+table_captions+yaml_metadata_block+smart

## MS Word template
DOCXTEMPLATE = /Users/kjhealy/.pandoc/templates/rmd-minion-reference.docx

## pandoc-citeproc-preamble location
PREAMBLE = config/preamble.tex

MD=$(SRC:.Rmd=.md)
PDFS=$(SRC:.Rmd=.pdf)
HTML=$(SRC:.Rmd=.html)
TEX=$(SRC:.Rmd=.tex)
DOCX=$(SRC:.Rmd=.docx)

all:	$(MD) $(PDFS) $(HTML) $(TEX) $(DOCX)

pdf:	clean $(PDFS)

html:	clean $(HTML)
tex:	clean $(TEX)
docx:	clean $(DOCX)

%.md: %.Rmd
	R --slave -e "set.seed(100);knitr::knit('$<')"

%.html:	%.md 
	$(PANDOC)/pandoc -r $(OPTIONS) -w html  --template=$(PREFIX)/templates/html.template --css=$(PREFIX)/marked/kultiad-serif.css --filter $(PANDOC)/pandoc-crossref --filter $(PANDOC)/pandoc-citeproc --csl=$(PREFIX)/csl/$(CSL).csl --bibliography=$(BIB) -o $@ $<

%.tex:	%.md
	$(PANDOC)/pandoc -r $(OPTIONS) -w latex -s  --pdf-engine=pdflatex --template=$(PREFIX)/templates/rmd-latex.template --filter $(PANDOC)/pandoc-crossref --filter $(PANDOC)/pandoc-citeproc --csl=$(PREFIX)/csl/ajps.csl --bibliography=$(BIB) -o $@ $<


%.pdf:	%.Rmd
	R --slave -e "set.seed(100);rmarkdown::render('$<')"

%.docx:	%.md
	$(PANDOC)/pandoc -r $(OPTIONS) -s --filter $(PANDOC)/pandoc-crossref --filter $(PANDOC)/pandoc-citeproc --csl=$(PREFIX)/csl/$(CSL).csl --bibliography=$(BIB) --reference-doc=$(DOCXTEMPLATE) -o $@ $<

clean:
	rm -f *.md *.html *.pdf *.tex *.bbl *.bcf *.blg *.aux *.log *.docx

.PHONY:	clean