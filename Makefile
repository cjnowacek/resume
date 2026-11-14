TEX := master_resume_cjnowacek.tex
BASE := master_resume_cjnowacek
IT_OUT := exports/CJ-Nowacek-Pipeline-Resume.pdf
TA_OUT := exports/CJ-Nowacek-TechArt-Resume.pdf

# Application copies: make apply TITLE="Senior Tools Engineer" [PROFILE=it] [EXTRA_SKILLS="C++ (familiar)"]
PROFILE ?= techart
APPLY_SLUG := $(shell printf '%s' "$(TITLE)" | tr -cs 'A-Za-z0-9' '-' | sed 's/^-//;s/-$$//')
APPLY_OUT := exports/CJ-Nowacek-$(APPLY_SLUG)-Resume.pdf
ifeq ($(PROFILE),it)
APPLY_TOGGLES := '\ITtrue' '\TechArtfalse'
else
APPLY_TOGGLES := '\ITfalse' '\TechArttrue'
endif
ifneq ($(strip $(EXTRA_SKILLS)),)
APPLY_SKILLS := $(EXTRA_SKILLS), 
endif
CV_TEX := cv_teaching_cjnowacek.tex
CV_BASE := cv_teaching_cjnowacek
CV_OUT := exports/CJ-Nowacek-Rigging-Instructor-CV.pdf
REFS_TEX := references_cjnowacek.tex
REFS_BASE := references_cjnowacek
REFS_OUT := exports/CJ-Nowacek-References.pdf
PHIL_TEX := teaching_philosophy_cjnowacek.tex
PHIL_BASE := teaching_philosophy_cjnowacek
PHIL_OUT := exports/CJ-Nowacek-Teaching-Philosophy.pdf
SYL_TEX := syllabus_intro_rigging_cjnowacek.tex
SYL_BASE := syllabus_intro_rigging_cjnowacek
SYL_OUT := exports/CJ-Nowacek-Intro-Rigging-Syllabus.pdf

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

.PHONY: it techart apply local-apply cv refs philosophy syllabus clean realclean open-it open-techart open-cv help local local-image

# Default target shows help
help:
	@echo "Available targets:"
	@echo "  make it          - Build IT/DevOps resume"
	@echo "  make techart     - Build Technical Artist resume"
	@echo "  make cv          - Build rigging-instructor teaching CV"
	@echo "  make refs        - Build references page (placeholder template)"
	@echo "  make philosophy  - Build teaching philosophy statement"
	@echo "  make syllabus    - Build sample rigging course syllabus"
	@echo "  make open-it     - Build and open IT resume"
	@echo "  make open-techart- Build and open TechArt resume"
	@echo "  make local-apply TITLE=\"Job Title\" [PROFILE=it] [EXTRA_SKILLS=\"...\"] - Application copy with that title, in the container (make apply = same on host TeX)"
	@echo "  make local       - Build both resumes in the CI-matching container (podman; run make local-image once)"
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

apply:
	@test -n "$(TITLE)" || { echo '❌ usage: make apply TITLE="Job Title" [PROFILE=it] [EXTRA_SKILLS="..."]'; exit 1; }
	@printf '%s\n' $(APPLY_TOGGLES) '\Applytrue' '\renewcommand{\ApplyTitle}{$(TITLE)}' '\renewcommand{\ApplyExtraSkills}{$(APPLY_SKILLS)}' > profile_toggle.tex
	@echo "Building application copy: $(TITLE) ($(PROFILE))..."
	@mkdir -p exports
	@$(LATEXMK) $(TEX) || { echo "❌ LaTeX compilation failed"; exit 1; }
	@test -f $(BASE).pdf || { echo "❌ PDF not generated"; exit 1; }
	@cp $(BASE).pdf $(APPLY_OUT)
	@echo "✓ Successfully built $(APPLY_OUT)"
	@latexmk -c

cv:
	@echo "Building teaching CV..."
	@mkdir -p exports
	@$(LATEXMK) $(CV_TEX) || { echo "❌ LaTeX compilation failed"; exit 1; }
	@test -f $(CV_BASE).pdf || { echo "❌ PDF not generated"; exit 1; }
	@cp $(CV_BASE).pdf $(CV_OUT)
	@echo "✓ Successfully built $(CV_OUT)"
	@latexmk -c $(CV_TEX)

refs:
	@echo "Building references page..."
	@mkdir -p exports
	@$(LATEXMK) $(REFS_TEX) || { echo "❌ LaTeX compilation failed"; exit 1; }
	@test -f $(REFS_BASE).pdf || { echo "❌ PDF not generated"; exit 1; }
	@cp $(REFS_BASE).pdf $(REFS_OUT)
	@echo "✓ Successfully built $(REFS_OUT)"
	@latexmk -c $(REFS_TEX)

philosophy:
	@echo "Building teaching philosophy..."
	@mkdir -p exports
	@$(LATEXMK) $(PHIL_TEX) || { echo "❌ LaTeX compilation failed"; exit 1; }
	@test -f $(PHIL_BASE).pdf || { echo "❌ PDF not generated"; exit 1; }
	@cp $(PHIL_BASE).pdf $(PHIL_OUT)
	@echo "✓ Successfully built $(PHIL_OUT)"
	@latexmk -c $(PHIL_TEX)

syllabus:
	@echo "Building sample syllabus..."
	@mkdir -p exports
	@$(LATEXMK) $(SYL_TEX) || { echo "❌ LaTeX compilation failed"; exit 1; }
	@test -f $(SYL_BASE).pdf || { echo "❌ PDF not generated"; exit 1; }
	@cp $(SYL_BASE).pdf $(SYL_OUT)
	@echo "✓ Successfully built $(SYL_OUT)"
	@latexmk -c $(SYL_TEX)

open-it: it
	@${OPEN_CMD} $(IT_OUT) 2>/dev/null || echo "⚠️  Could not open PDF. Find it at: $(IT_OUT)"

open-techart: techart
	@${OPEN_CMD} $(TA_OUT) 2>/dev/null || echo "⚠️  Could not open PDF. Find it at: $(TA_OUT)"

open-cv: cv
	@${OPEN_CMD} $(CV_OUT) 2>/dev/null || echo "⚠️  Could not open PDF. Find it at: $(CV_OUT)"

clean:
	@latexmk -c
	@rm -f profile_toggle.tex
	@echo "✓ Cleaned temporary files"

realclean:
	@latexmk -C
	@rm -f profile_toggle.tex $(IT_OUT) $(TA_OUT) $(CV_OUT) $(REFS_OUT) $(PHIL_OUT) $(SYL_OUT)
	@echo "✓ Removed all generated files"

# Local builds with the same LaTeX as CI (see Containerfile). No host TeX needed.
# TMPDIR: podman stages layers in /var/tmp by default, which a small root disk cannot hold.
local-image:
	@mkdir -p $(HOME)/.cache/podman-tmp
	TMPDIR=$(HOME)/.cache/podman-tmp podman build -t resume-tex -f Containerfile .

local:
	podman run --rm -v "$(CURDIR)":/work resume-tex sh -c 'make it && make techart'

local-apply:
	TITLE='$(TITLE)' PROFILE='$(PROFILE)' EXTRA_SKILLS='$(EXTRA_SKILLS)' podman run --rm -e TITLE -e PROFILE -e EXTRA_SKILLS -v "$(CURDIR)":/work resume-tex make apply
