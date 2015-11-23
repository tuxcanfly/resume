SRC = $(wildcard *.md)

PDFS=$(SRC:.md=.pdf)
HTML=$(SRC:.md=.html)
LATEX_TEMPLATE=./pandoc-templates/default.latex
PANDOCARGS=--variable mainfont="DejaVu Sans Mono" --variable fontsize=14pt --latex-engine=xelatex

all:    clean $(PDFS) $(HTML) deploy

pdf:   clean $(PDFS)
html:  clean $(HTML)

%.html: %.md
	python resume.py html $(GRAVATAR_OPTION) < $< | pandoc -T "Javed Khan | Resumé" -t html -c resume.css -o $@

%.pdf:  %.md $(LATEX_TEMPLATE)
	python resume.py tex < $< | pandoc $(PANDOCARGS) --template=$(LATEX_TEMPLATE) -H header.tex -o $@

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

deploy: resume.html resume.pdf
	cp resume.html ../tuxcanfly.me/raw/resume.html
	cp resume.css ../tuxcanfly.me/raw/resume.css
	cp resume.pdf ../tuxcanfly.me/content/extra/resume.pdf

.PHONY: deploy
