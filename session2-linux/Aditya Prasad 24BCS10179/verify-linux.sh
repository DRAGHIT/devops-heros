#!/usr/bin/env bash
set -eu
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cd "$work"
printf '== Soft link and hard link ==\n'
printf 'Linux link exercise\n' > original.txt
ln -s original.txt soft.txt
ln original.txt hard.txt
ls -li original.txt soft.txt hard.txt
test "$(stat -c %i original.txt)" = "$(stat -c %i hard.txt)"
test "$(readlink soft.txt)" = original.txt
rm original.txt
test ! -e soft.txt && test -L soft.txt
cat hard.txt
rm soft.txt hard.txt
printf 'PASS: shared hard-link inode; symlink becomes dangling after target deletion; cleanup verified\n'
printf '\n== Safe command practice ==\n'
printf 'pwd: '; pwd
mkdir practice
touch practice/file.txt
printf 'example\n' > practice/file.txt
cp practice/file.txt practice/copy.txt
mv practice/copy.txt practice/renamed.txt
grep example practice/renamed.txt
wc -l practice/renamed.txt
chmod 600 practice/file.txt
stat -c 'mode: %a' practice/file.txt
find practice -type f | sort
rm -r practice
printf 'PASS: directory, file, copy, move, search, permissions and deletion exercises\n'
printf '\n== Linux ip cheat sheet read-only commands ==\n'
for cmd in 'ip -br addr' 'ip -br link' 'ip route' 'ip maddr' 'ip neigh' 'ip -s link'; do
 printf '$ %s\n' "$cmd"
 bash -c "$cmd" 2>&1 || true
done
printf '\n== Permissions and logs ==\n'
id
printf '$ sudo -n true\n'
sudo -n true 2>&1 || true
printf '$ journalctl -u cron.service -n 5 --no-pager\n'
journalctl -u cron.service -n 5 --no-pager 2>&1 || true
