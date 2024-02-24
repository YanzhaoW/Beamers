CONTENTS=$(wildcard *.tex *.bib)

PNGS=$(shell find ./figures/* -name '*.png')
JPEGS=$(shell find ./figures/* -name '*.jpeg')

.PHONY: all clean

all: main.pdf clean

main.pdf: $(CONTENTS) $(JPEGS) $(PNGS) 
	# echo "sucess"
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make main.tex

clean:
	latexmk -c
	rm -f main.bbl main.nav main.snm main.run.xml

# %.png:
# 	sips -g dpiHeight $@
# 	# echo $@
