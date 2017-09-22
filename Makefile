all: appendix awstream

appendix:
	pdflatex -halt-on-error $@
	bibtex $@
	pdflatex $@
	pdflatex $@

awstream:
	pdflatex -halt-on-error $@
	bibtex $@
	pdflatex $@
	pdflatex $@

quick:
	pdflatex awstream.tex

join:
	"/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" \
		-o join.pdf awstream.pdf appendix.pdf

clean:
	rm -f ${filename}.{ps,pdf,log,aux,out,dvi,bbl,blg}
	rm -f appendix.{ps,pdf,log,aux,out,dvi,bbl,blg}
	rm -rf auto
