SHORT-NAME     ?= $(shell echo "$(notdir $(CURDIR))" | sed 's|_.*||')
AUTHOR-ID      ?= m-e-leypold
GITLAB         ?= git@gitlab.com:$(AUTHOR-ID)/$(SHORT-NAME).git
GITHUB         ?= git@github.com:$(AUTHOR-ID)/$(SHORT-NAME).git
ORIGIN         ?= LSD:projects/$(SHORT-NAME).git

MAJOR-VERSIONS ?= 1 2 3 4 5 6 7 8 9 10

-DIRTY  ?= $(shell if test $$(git status -s | wc -l) -gt 0; then echo "-DIRTY"; fi)
VERSION ?= $(shell git describe --tags)$(-DIRTY)

$(info SHORT-NAME = $(SHORT-NAME))

.ONESHELL:

export PS4 = => 

pre-publication-check::

git-setup:                          # These are the upstream repositories
	set -eux
	git remote rm GITLAB || true
	git remote rm GITHUB || true
	git remote add GITLAB $(GITLAB)
	git remote add GITHUB $(GITHUB)
	git fetch GITLAB
	git fetch GITHUB
	cd Project
	git remote rm UPSTREAM || true
	git remote add UPSTREAM $(ORIGIN)
	git fetch UPSTREAM
	git merge UPSTREAM/project
	git push UPSTREAM project
	git push origin project


publish: publish-source publish-project

publish-project:
	set -eux
	( cd Project
	  git branch | grep '^[*] project$$' # We only release from project
	  if git status -s | grep -v '^??'; \
	     then git status -s ; false; \
	     else true; \
	  fi        
	  git push origin project
	)
	git push

publish-source: pre-publication-check
	set -eux
	git branch | grep '^[*] main$$' # We only release from main
	if git status -s | grep -v '^??'; \
	   then git status -s ; false; \
           else true; \
        fi
	git push GITLAB main
	git push GITLAB $(MAJOR-VERSIONS:%=refs/tags/%.*)
	git push GITHUB main
	git push GITHUB $(MAJOR-VERSIONS:%=refs/tags/%.*)
	git push --tags origin main
