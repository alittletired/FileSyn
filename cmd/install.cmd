@echo off
set /p user=�������ύʹ���û���
set /p email=�������ύʹ�õ�����
git config --global push.default simple
git config --global http.postBuffer 943704000
git config --global user.name "%user%"
git config --global user.email "%email%"
echo ��ʼ��װ...
cd \
d:
mkdir web
cd d:\web\
rd fliesyn /s /q
git clone  http://admin:admin@42.96.167.177:81/Git.aspx/filesyn

cd filesyn
start npm install -g nodemon

npm install
echo ��װ���