SRC = $(wildcard *.md)

PDFS=$(SRC:.md=.pdf)
HTML=$(SRC:.md=.html)
LATEX_TEMPLATE=./pandoc-templates/default.latex
PANDOCARGS=--variable mainfont="DejaVu Sans Mono" --variable fontsize=14pt --latex-engine=xelatex
TMPMD=tmp.md

all:    clean $(PDFS) $(HTML)

pdf:   clean $(PDFS)
html:  clean $(HTML)

%.html: %.md
	python resume.py html $(GRAVATAR_OPTION) < $< > $(TMPMD)
	docker run --rm -v `pwd`:/data jpbernius/pandoc $(PANDOCARGS) -T "Javed Khan | Resumé" -t html -c resume.css -o $@ $(TMPMD)
	$(RM) $(TMPMD)

%.pdf:  %.md $(LATEX_TEMPLATE)
	python resume.py tex < $< > $(TMPMD)
	docker run --rm -v `pwd`:/data jpbernius/pandoc $(PANDOCARGS) --template=$(LATEX_TEMPLATE) -H header.tex -o $@ $(TMPMD)
	$(RM) $(TMPMD)

ifeq ($(OS),Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix
  RM = rm -f
endif

clean:
	$(RM) *.html *.pdf

$(LATEX_TEMPLATE):
	git submodule update --init
