#!/usr/bin/env bash
set -euo pipefail
current_date=$(date '+%Y-%m-%d %H:%M:%S %Z')
host_name=$(hostname)
user_name=$(whoami)
echo "Current date: $current_date"
echo "Hostname: $host_name"
echo "Username: $user_name"
echo 'Disk usage:'
df -h .
echo 'Running processes:'
ps -e -o pid,comm
read -r -p 'Enter your name: ' student_name
read -r -p 'Enter your roll number: ' roll_number
read -r -p 'Enter a comment: ' comment
read -r -p 'Enter output directory: ' output_dir
if [[ -z "$output_dir" ]]; then
 echo 'Output directory cannot be empty.' >&2
 exit 1
fi
mkdir -p -- "$output_dir"
touch -- "$output_dir/process.log"
ps -e -o pid,comm > "$output_dir/process.log"
echo "Student: $student_name"
echo "Roll Number: $roll_number"
echo "Comment: $comment"
echo "Process information saved to: $output_dir/process.log"
