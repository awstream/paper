all: appendix awstream

appendix:
	pdflatex -halt-on-error $@
	bibtex $@
	pdflatex $@
	pdflatex $@
	rm -f appendix.{ps,log,aux,out,dvi,bbl,blg}

awstream:
	pdflatex -halt-on-error $@
	bibtex $@
	pdflatex $@
	pdflatex $@
	rm -f awstream.{ps,log,aux,out,dvi,bbl,blg}

quick:
	pdflatex awstream.tex

join:
	"/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" \
		-o join.pdf awstream.pdf appendix.pdf

clean:
	rm -f awstream.{ps,pdf,log,aux,out,dvi,bbl,blg}
	rm -f appendix.{ps,pdf,log,aux,out,dvi,bbl,blg}
	rm -rf auto
