# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Clone Location

Clone to `C:\dev\resume-with-tex` on Windows, `~/dev/resume-with-tex` on Linux.

## What This Is

CJ Nowacek's dual-profile LaTeX resume. One source file (`master_resume_cjnowacek.tex`, moderncv class) compiles to two PDFs via `\ifIT`/`\ifTechArt` conditionals: an IT/DevOps profile and a TechArt profile. Profile-gated entries: Yaggy Trucking is IT-only; freelance rigging and the Hi-Rez internship are TechArt-only.

## Commands

```bash
make it        # Build Pipeline/IT resume -> exports/CJ-Nowacek-Pipeline-Resume.pdf
make techart   # Build TechArt resume  -> exports/CJ-Nowacek-TechArt-Resume.pdf
make clean     # Remove temp files, keep PDFs
make local-apply TITLE="Senior Tools Engineer" EXTRA_SKILLS="C++ (familiar)"   # application copy: that title, optional extra skill, no degree year; PROFILE=it for the Pipeline base; never synced to the site
make local     # Both resumes via podman, same LaTeX as CI (run `make local-image` once); a few seconds
```

The Makefile writes `profile_toggle.tex` (gitignored) to flip the conditionals, then runs latexmk. No LaTeX is installed on CJ's Windows machine; the GitHub Actions workflow (`.github/workflows/build.yml`, "Build Resumes") builds both PDFs on every push and uploads them as the `resumes` artifact (90-day retention). Verify changes by pushing and checking the run.

## Content Rules

- **No em dashes** anywhere in resume text; use colons, commas, or parentheses. LaTeX `--` en dashes in date ranges (`Jul 2026--Present`) are correct and stay.
- **IP-safe MediaLab wording:** no internal tool codenames, render-farm node counts, vendor names for the render-manager migration, client names, or deployment internals. Say "modern render-management platform", "the studio's Windows render farm".
- The only hard metric allowed is the ~25% asset-processing improvement from Hi-Rez.
- The built PDFs flow to the portfolio site automatically: on push to main, CI syncs `exports/*.pdf` into the php-website repo's `static/files/` (via the `WEBSITE_DEPLOY_KEY` secret, a write deploy key on php-website), which triggers that repo's SiteGround deploy. If the secret is missing the step skips gracefully; copy PDFs by hand in that case.
- Dates in experience and education entries are year-only by design (no months), e.g. `2026--Present`, `2023--2024`.
