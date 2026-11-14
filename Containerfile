# Same LaTeX as the CI runner (.github/workflows/build.yml; ubuntu-latest was 26.04
# on 2026-11-13: bump this when the runner moves, or page breaks will differ):
#   make local-image   (once)
#   make local         (both resumes into exports/)
FROM docker.io/library/ubuntu:26.04
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      make latexmk texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra cm-super \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /work
