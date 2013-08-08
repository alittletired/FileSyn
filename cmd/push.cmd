@echo off
cd\
%5
cd %2%3
git add .
git commit -am "%date%"
echo push to server,please wating.............

git push origin  master -f


