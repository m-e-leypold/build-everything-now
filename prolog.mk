# BEN - Build Everything Now
# Copyright (C) 2023  M E Leypold
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# TODO: Copy setup from toplevel make

BEN        ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
BEN        := $(BEN)
BEN-COMMON := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

all::
clean::
cleaner::
setup::
publish::
check::
quick-check::
full-check::
pre-release-check::
help::
setup-project::

DOCUMENTED-TARGETS = all clean cleaner setup publish \
                     check quick-check full-check

define HELP/check
  #
  # Target 'check' -- Run a check on the product
  # --------------------------------------------
  #
  # Run a "reasonable" check on the product. What exactly is run
  # depends on the project type and the product. Typically this is
  # more than for 'quick-check', but less than for 'full-check'.
  #

endef


.PHONY: all init clean cleaner setup

.ONESHELL:
export PS4 ==> 

# SET-SH := set -o pipefail; set -eux;
SET-SH := set -x
SHELL=bash
.SHELLFLAGS := -euc -o pipefail

# Note: .SHELLFLAGS also affects $(shell ...) calls which we do not
# want to be verbose. But we want for all shell fragments that they
# fail if any command fails, _especially_ when using .ONESHELL. So ATM
# $(SET-SH) gives us verbosity, but even if we forget it, recipes fail
# correctly.

cleaner:: clean
	rm -rf .build

$(info BEN-RULE-SET  = $(BEN-RULE-SET))
$(info BEN           = $(BEN))
$(info BEN-COMMON    = $(BEN-COMMON))
$(info )
$(info PRODUCT-NAME  = $(PRODUCT-NAME))

ifndef RELEASE
  VERSION := $(shell $(BEN-COMMON)/git-version)

  ifneq ($(strip $(filter release,$(MAKECMDGOALS))),)
    $(error When target is 'release', $$(RELEASE) must be given)
  endif
else
  VERSION := $(RELEASE)
  ifneq ($(strip $(filter release,$(MAKECMDGOALS))),release)
     $(error When RELEASE is given, the make target must be 'release' (and only this))
  endif
  ifneq ($(strip $(filter-out release,$(MAKECMDGOALS))),)
     $(error With target 'release' no other targets can be specified)
  endif
endif

$(info VERSION       = $(VERSION))

include $(BEN-COMMON)/ben.mk
include $(BEN-COMMON)/setup-project.mk
