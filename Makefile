TEX := master_resume_cjnowacek.tex
BASE := master_resume_cjnowacek
IT_OUT := exports/CJ-Nowacek-IT-Resume.pdf
TA_OUT := exports/CJ-Nowacek-TechArt-Resume.pdf

LATEXMK := latexmk -pdf -interaction=nonstopmode -halt-on-error

# Cross-platform "open" command detection
UNAME := $(shell uname -s)
ifeq ($(UNAME),Darwin)
    OPEN_CMD := open
else ifeq ($(UNAME),Linux)
    OPEN_CMD := xdg-open
else
    # Windows (Git Bash, WSL, etc.)
    OPEN_CMD := start
endif

.PHONY: it techart clean realclean open-it open-techart help

# Default target shows help
help:
	@echo "Available targets:"
	@echo "  make it          - Build IT/DevOps resume"
	@echo "  make techart     - Build Technical Artist resume"
	@echo "  make open-it     - Build and open IT resume"
	@echo "  make open-techart- Build and open TechArt resume"
	@echo "  make clean       - Remove temp files (keep PDFs)"
	@echo "  make realclean   - Remove all generated files"

it:
	@printf "\\ITtrue\n\\TechArtfalse\n" > profile_toggle.tex
	@echo "Building IT resume..."
	@mkdir -p exports
	@$(LATEXMK) $(TEX) || { echo "❌ LaTeX compilation failed"; exit 1; }
	@test -f $(BASE).pdf || { echo "❌ PDF not generated"; exit 1; }
	@cp $(BASE).pdf $(IT_OUT)
	@echo "✓ Successfully built $(IT_OUT)"
	@latexmk -c

techart:
	@printf "\\ITfalse\n\\TechArttrue\n" > profile_toggle.tex
	@echo "Building TechArt resume..."
	@mkdir -p exports
	@$(LATEXMK) $(TEX) || { echo "❌ LaTeX compilation failed"; exit 1; }
	@test -f $(BASE).pdf || { echo "❌ PDF not generated"; exit 1; }
	@cp $(BASE).pdf $(TA_OUT)
	@echo "✓ Successfully built $(TA_OUT)"
	@latexmk -c

open-it: it
	@${OPEN_CMD} $(IT_OUT) 2>/dev/null || echo "⚠️  Could not open PDF. Find it at: $(IT_OUT)"

open-techart: techart
	@${OPEN_CMD} $(TA_OUT) 2>/dev/null || echo "⚠️  Could not open PDF. Find it at: $(TA_OUT)"

clean:
	@latexmk -c
	@rm -f profile_toggle.tex
	@echo "✓ Cleaned temporary files"

realclean:
	@latexmk -C
	@rm -f profile_toggle.tex $(IT_OUT) $(TA_OUT)
	@echo "✓ Removed all generated files"
