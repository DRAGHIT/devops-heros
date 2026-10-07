#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
bash -n system_info.sh
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
printf 'Aditya Prasad\n24BCS10179\nSession 3 test\n%s\n' "$work/output directory" | bash system_info.sh > "$work/run.txt"
test -s "$work/output directory/process.log"
grep -q 'PID COMMAND' "$work/output directory/process.log"
grep -q 'Student: Aditya Prasad' "$work/run.txt"
grep -q 'Roll Number: 24BCS10179' "$work/run.txt"
for label in 'Current date:' 'Hostname:' 'Username:' 'Disk usage:' 'Running processes:'; do grep -q "$label" "$work/run.txt"; done
if printf 'Aditya Prasad\n24BCS10179\nEmpty directory test\n\n' | bash system_info.sh > "$work/empty.txt" 2>&1; then
 echo 'FAIL: empty output directory accepted';exit 1
fi
grep -q 'Output directory cannot be empty.' "$work/empty.txt"
printf 'bash -n system_info.sh: PASS\n'
printf 'Normal execution: PASS\n'
printf 'Required system-information sections: PASS\n'
printf 'Name and roll number preserved: PASS\n'
printf 'Output directory containing spaces: PASS\n'
printf 'Nonempty process.log with PID/COMMAND columns: PASS\n'
printf 'Empty output directory rejected: PASS\n'
printf 'Temporary test files cleaned up on exit.\n'
