#!/usr/bin/env bash
set -eu
exec > >(tee /tmp/devops-evidence/s2-admin.txt) 2>&1
sudo -n true
sudo adduser --disabled-password --gecos '' aditya-devops-test
id aditya-devops-test
getent passwd aditya-devops-test
sudo deluser --remove-home aditya-devops-test
ps -p 1 -o comm=
sudo journalctl -u cron.service -n 5 --no-pager
sudo logger -t aditya-devops-course 'Session 2 journal test'
sudo journalctl -t aditya-devops-course -n 5 --no-pager
