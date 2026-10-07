# Session 5 - Git and GitHub

Student: Aditya Prasad  
Roll Number: 24BCS10179

## Task 1: git commit -a -m versus git commit -m

Executed an isolated Git lab. After an initial commit, modified a tracked file and created an untracked file. `git commit -m` failed because nothing was staged. `git commit -a -m` committed the tracked modification but did not include the new file. `git add new.txt` was required before committing that file.

`-m` supplies a message. `-a` additionally stages modified/deleted tracked files; it does not add untracked files.

## Task 2: cherry-pick

Created three commits on main, then a feature branch with two separate commits. Used `git log --oneline` and `git rev-parse HEAD` to identify the first feature change. Switched to main and cherry-picked that commit. Assertions verified the chosen file/content reached main and the unrelated second feature file did not.

Cherry-pick applies one commit's change to the current branch; it does not merge all changes from the source branch. The selected commit identifier is printed by the actual lab, not hardcoded.

## Commands and actual evidence

```bash
bash -n verify-git.sh
bash verify-git.sh
```

[terminal-output.txt](terminal-output.txt) contains the actual command results and commit logs. `verify-git.sh` creates an independent temporary repository, never rewrites the coursework fork or another student's work, and deletes the temporary lab on exit. All assertions passed. This meets the Doc's option to submit Markdown/terminal output instead of screenshots.

## Sources

- [Assignment document](https://docs.google.com/document/d/1cjXFYf2Thm8cBEN-0C48B-v02cj3jGLd47lcO18prHE/edit?tab=t.0), Git Homework Tasks.
- Teacher session5-git-github/resources.md inspected for repository context.
