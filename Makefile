TEX := master_resume_cjnowacek.tex
BASE := master_resume_cjnowacek
IT_OUT := exports/CJ-Nowacek-IT-Resume.pdf
TA_OUT := exports/CJ-Nowacek-TechArt-Resume.pdf

LATEXMK := latexmk -pdf -interaction=nonstopmode -halt-on-error

.PHONY: it techart clean realclean open-it open-techart

it:
	@printf "\\ITtrue\n\\TechArtfalse\n" > profile_toggle.tex
	$(LATEXMK) $(TEX)
	@cp $(BASE).pdf $(IT_OUT)
	@latexmk -c

techart:
	@printf "\\ITfalse\n\\TechArttrue\n" > profile_toggle.tex
	$(LATEXMK) $(TEX)
	@cp $(BASE).pdf $(TA_OUT)
	@latexmk -c

open-it: it
	@${OPEN_CMD} $(IT_OUT) 2>/dev/null || true

open-techart: techart
	@${OPEN_CMD} $(TA_OUT) 2>/dev/null || true

clean:
	@latexmk -c
	@rm -f profile_toggle.tex

realclean:
	@latexmk -C
	@rm -f profile_toggle.tex $(IT_OUT) $(TA_OUT)

# Cross-platform "open" (macOS `open`, Linux `xdg-open`, Windows `start`)
OPEN_CMD := firefox
