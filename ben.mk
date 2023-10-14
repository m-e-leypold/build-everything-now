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

ifdef   BEN-RULE-SET

BEN:
	: Create BEN worktree from local ben branch
	$(SET-SH)
	git worktree add BEN ben/$(BEN-RULE-SET)
	:

ben-split+merge: BEN
	: Split off .ben and merge to BEN
	$(SET-SH)
	$(BEN-COMMON)/ben-split+merge .ben BEN \
            "ben: Merging .ben to ben/$(BEN-RULE-SET) from $(PRODUCT-NAME) @ $(GIT-COMMIT)"
	:

ben-upstream: ben-split+merge BEN
	: Push ben branch to upstream
	$(SET-SH)
	git push BEN ben/$(BEN-RULE-SET)
	:

ben-update: BEN
	: Merge .ben from upstream
	$(SET-SH)
	cd BEN
	git pull BEN ben/$(BEN-RULE-SET)
	BEN_COMMIT="$$(git log -n 1 --oneline --no-abbrev-commit | awk '{print $$1}')"
	cd ..
	git subtree merge --prefix=.ben \
            -m "Updating .ben from ben/$(BEN-RULE-SET) @ $$BEN_COMMIT" \
           ben/$(BEN-RULE-SET) 
	:

endif
