@echo off
set /p user=设置你提交使用用户名
set /p email=设置你提交使用的邮箱
git config --global push.default simple
git config --global http.postBuffer 943704000
git config --global user.name "%user%"
git config --global user.email "%email%"
echo 开始安装...
cd \
d:
mkdir web
cd d:\web\
rd fliesyn /s /q
git clone  http://administrator:yftech258456@42.121.119.196:8655/filesyn.git

cd filesyn
start npm install -g nodemon

npm install
echo 安装完毕