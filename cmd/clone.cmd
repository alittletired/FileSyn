@echo off
cd \
%5
cd %2
rd %3  /s /q
git clone %4%1".git" %3
