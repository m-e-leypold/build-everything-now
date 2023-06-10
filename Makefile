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

$(info )
PRODUCT-NAME = build-everything-now

# * Project integration --------------------------------------------------------

-include Project/Project.mk

# TODO: Make this dependent on presence of project branch, too, then
#       auto checkout.
#

# * Pulling in select modules and standard targets from common/ ----------------

COMMON-MODULES = prolog git epilog 

include $(COMMON-MODULES:%=common/%.mk)

$(COMMON-MODULES:%=common/%.mk): %: common/.git  # Automatic checkout of common if missing.


# * Generic rules --------------------------------------------------------------

clean::
	@$(SET-SH)
	rm -f *~


# * Initializing the work bench & and handling branches ------------------------
#
#   In the context of BEN, the toplevel branches (those without a '/'
#   in their name and with the exception of 'main') are makefile
#   systems to be integrated into a project via 'git subtree'.
#

BRANCHES := $(shell git branch | grep -v '^[*]'    \
                               | sed 's|^ *||'     \
                               | grep '^ben/'      \
                               | sed 's|^ben/||')
$(info )
$(info BRANCHES = $(BRANCHES))

setup::  $(BRANCHES:%=%/.git) Project/.git

$(BRANCHES:%=%/.git): %/.git:
	@$(SET-SH)
	git worktree add "$*" "ben/$*"

# Todo: Move the following into common/project.mk, 
#       make conditional from existence of branch project.
#

Project/.git:
	@$(SET-SH)
	git clone --single-branch -b "project" . "$(@D)"

cleaner::  # TODO: Check if branches have been checked in and automatically push
	@$(SET-SH)
	rm -rf $(BRANCHES) Project

# * Epilog ---------------------------------------------------------------------

$(info )



