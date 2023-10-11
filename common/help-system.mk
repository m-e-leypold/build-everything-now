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

HELP = @echo  '$(subst ','"'"',$(subst $(NEWLINE)  ,\n,$(HELP/$1)))' \
          | sed 's|^  ||;s|\\n|\n|g;' \
          | grep '^\#' | sed 's|^\# \{0,1\}||'; \
        echo

define NEWLINE


endef

define HELP/OVERVIEW

  # Help overview
  # -------------
  #
  # Use the following targets to print help pages for this build
  # system:
  #
  #   - help/$$(PAGE)     to see a specific help page.
  #   - help-index       to see the complete directory of help pages.
  #   - help/$$(TARGET)   to see the help for a target.
  #   - help-targets     to see an overview documented targets.
  #
  # Documented targets are: $(DOCUMENTED-TARGETS).
  #
  # Example:
  #
  #   $$ make help/check
endef

.ONESHELL:
help::
	$(call HELP,OVERVIEW,| )

help-targets:


help/%::
	$(call HELP,$*,| )
