@echo off
cd \
%5
cd %2%3
git reset --hard
git pull --force