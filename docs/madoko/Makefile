
# This uses Madoko (https://madoko.codeplex.com/)

pdf:
	madoko -v --pdf thesis.mdk

html:
	madoko -v thesis.mdk

all: pdf

clean:
	cd out/
	rm -f *~ css.sty madoko.css madoko.sty *math-dvi.tex *math-pdf.tex *math-dvi.final.tex *math-pdf.final.tex  *.aux *.dim *.dvi *.log *.out *.upa *.dimx *.html *.log *.pdf *.upa *.upb *.bbl *.blg .*~
	rm -dfr math
