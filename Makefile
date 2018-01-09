all: awstream

awstream:
	pdflatex -halt-on-error $@
	bibtex $@
	pdflatex $@
	pdflatex $@
	rm -f awstream.{ps,log,aux,out,dvi,bbl,blg}

quick:
	pdflatex awstream.tex

clean:
	rm -f awstream.{ps,pdf,log,aux,out,dvi,bbl,blg}
	rm -rf auto
