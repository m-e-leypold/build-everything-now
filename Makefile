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

all::   init
init::
clean::
cleaner::

$(info )

# * Initializing the work bench & and handling branches ------------------------
#
#   In the context of BEN, the toplevel branches (those without a '/'
#   in their name and with the exception of 'main') are makefile
#   systems to be integrated into a project via 'git subtree'.
#

BRANCHES := $(shell git branch | grep -v '^[*]'    \
                               | sed 's|^ *||'     \
                               | grep -v '^main$$' \
                               | grep -v '/')

$(info BRANCHES = $(BRANCHES))

init::  $(BRANCHES:%=%/.git)

$(BRANCHES:%=%/.git): %/.git:
	git clone --single-branch -b "$*" . "$*"


# * Epilog ---------------------------------------------------------------------

$(info )



