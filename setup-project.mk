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

ifeq ($(strip $(filter setup-project,$(MAKECMDGOALS))),setup-project)
  SETUP-PROJECT = yes
  LICENSE      ?= gpl-3.0
  LICENSE      := $(LICENSE)
else
  undefine SETUP-PROJECT
endif

setup-project:: LICENSE .gitignore Makefile

LICENSE: $(BEN-COMMON)/license-templates/$(LICENSE).txt
	: Generate LICENSE $(LICENSE)
	$(SET-SH)
	awk '(s){print;next}/^#/{next}/^([^#]|$$)/{print ;s=1}' <$< >$@.tmp
	mv $@.tmp $@
	:

.gitignore::
	: Add general and BEN specific ignore patterns
	$(SET-SH)
	cat $(BEN-COMMON)/gitignore-template >$@
	:

Makefile:
	: Create toplevel makefile
	$(SET-SH)
	sed 's/__PRODUCT-NAME__/$(PRODUCT-NAME)/g' <$(BEN)/makefile-template >$@.tmp
	mv $@.tmp $@
	:
