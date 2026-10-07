# Session 3 - Shell Scripting

Student: Aditya Prasad  
Roll Number: 24BCS10179

## Task

Create a system-information shell script that prints date, hostname, username, disk usage and running processes; uses variables and `read -p`; creates a directory and file with `mkdir`/`touch`; and redirects processes into that file.

## Implementation

`system_info.sh` stores the date, hostname and username in variables, prints the required system information, asks for student details and an output directory, and writes `ps -e -o pid,comm` output to `process.log` using `>`.

Quoted paths support spaces. `read -r` preserves input backslashes. `set -euo pipefail` stops on command errors. An empty output-directory input is rejected. The process output deliberately uses process names rather than full command arguments, which can contain secrets.

## Commands used

```bash
bash -n system_info.sh
bash verify.sh
bash system_info.sh
```

The last command is for an interactive run. Enter `Aditya Prasad`, `24BCS10179`, a comment, and an output directory. Inspect the resulting `process.log` in that directory. Do not commit unreviewed host/process logs.

## Actual verification

`verify.sh` executes the script with test input in a temporary directory. It checks required section labels, exact student details, a directory containing spaces, a nonempty process file with the expected header, and rejection of empty directory input. It deletes all temporary files on exit.

The executed results are in [verification.txt](verification.txt). All seven checks passed. Re-running `bash verify.sh` reproduces those checks. This verifies script behavior, not a Docker/Kubernetes deployment.

## Submission

Files are published on the independent `session-3` branch of the student's public fork. No teacher PR is required under the updated submission instructions.

## Sources

- [Assignment document](https://docs.google.com/document/d/1cjXFYf2Thm8cBEN-0C48B-v02cj3jGLd47lcO18prHE/edit?tab=t.0), Shell Scripting Homework Task.
- Teacher repository `session3-shell-scripting/task.md` inspected for context, not substituted for the Doc.
- [PR 311](https://github.com/Nency-Ravaliya/devops-heros/pull/311) checked for placement and README/script format only; no student code or outputs copied.
