filename=awstream

appendix:
	pdflatex appendix.tex
	bibtex appendix
	pdflatex appendix.tex
	pdflatex appendix.tex

pdf:
	pdflatex ${filename}.tex
	bibtex ${filename}
	pdflatex ${filename}.tex
	pdflatex ${filename}.tex

quick:
	pdflatex ${filename}.tex

join:
	"/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py" \
		-o join.pdf awstream.pdf appendix.pdf

clean:
	rm -f ${filename}.{ps,pdf,log,aux,out,dvi,bbl,blg}
	rm -f appendix.{ps,pdf,log,aux,out,dvi,bbl,blg}
