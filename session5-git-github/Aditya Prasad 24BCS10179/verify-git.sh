#!/usr/bin/env bash
set -euo pipefail
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cd "$work"
git init -q -b main
git config user.name 'Aditya Prasad'
git config user.email '97846654+DRAGHIT@users.noreply.github.com'
printf '== git commit -m vs -a -m ==\n'
printf 'initial\n' > tracked.txt
git add tracked.txt
git commit -qm 'Initial tracked file'
printf 'updated\n' >> tracked.txt
printf 'new\n' > new.txt
if git commit -m 'No staged changes' > no-staged.txt 2>&1; then
 echo 'FAIL: unstaged change was committed';exit 1
fi
echo 'PASS: git commit -m did not stage tracked modification'
git commit -qam 'Update tracked file automatically'
test "$(git show HEAD:tracked.txt)" = "$(printf 'initial\nupdated')"
if git cat-file -e HEAD:new.txt 2>/dev/null; then echo 'FAIL: -a added an untracked file';exit 1;fi
echo 'PASS: -a committed tracked changes, not new.txt'
git add new.txt
git commit -qm 'Add new file explicitly'
printf '\nMain commits before feature branch:\n'
git log --oneline
printf '\n== cherry-pick ==\n'
git checkout -qb feature
printf 'chosen feature\n' > selected.txt
git add selected.txt
git commit -qm 'Feature change selected for cherry-pick'
selected=$(git rev-parse HEAD)
printf 'not selected\n' > other.txt
git add other.txt
git commit -qm 'Separate feature change not selected'
git log --oneline
git checkout -q main
git cherry-pick "$selected"
test -f selected.txt
test ! -f other.txt
grep -qx 'chosen feature' selected.txt
printf '\nMain after cherry-pick:\n'
git log --oneline
echo 'PASS: only selected feature change reached main'
