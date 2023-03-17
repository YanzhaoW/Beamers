FIGURES=$(wildcard figures/*)
CONTENTS=$(wildcard *.tex *.bib)

all: main.pdf clean

main.pdf: $(FIGURES) $(CONTENTS)
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make main.tex

clean:
	latexmk -c
	rm main.bbl main.nav main.snm main.run.xml
