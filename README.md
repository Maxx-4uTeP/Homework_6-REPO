# Домашка 6 "Управление пакетами. Дистрибьюция софта"
## Описание решения.
### Cоздать свой RPM
Был собран nginx с поддержкой ssl по методичке.  
Был написан скрипт для provision секции для Vagrant _server.sh_ в папке _files_.  
OpenSSL использовал явно версию 1.1.1 потому как с latest не завелось.
```sh
sudo yum install -y nano redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
sudo rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
wget https://www.openssl.org/source/openssl-1.1.1l.tar.gz
sudo tar -xvf openssl-1.1.1l.tar.gz
sudo yum-builddep -y /root/rpmbuild/SPECS/nginx.spec
sudo cp /home/vagrant/nginx.spec /root/rpmbuild/SPECS/nginx.spec
sudo rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
sudo ls /root/rpmbuild/RPMS/x86_64/
sudo yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
systemctl enable nginx
systemctl start nginx
```
#### Последовательность действий:

```sh
vagrant up
vagrant ssh
sudo systemctl status nginx
sudo cat /root/rpmbuild/SPECS/nginx.spec | grep with-openssl
```

### Cоздать свой репо и разместить там свой RPM
Был реализован репозиторий по методичке.  
Был написан скрипт для provision секции для Vagrant: _createrepo.sh_
```sh
#!/bin/bash
sudo mkdir /usr/share/nginx/html/repo
sudo cp /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
sudo wget https://downloads.percona.com/downloads/percona-release/percona-release-1.0-9/redhat/percona-release-1.0-9.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-1.0-9.noarch.rpm
sudo createrepo /usr/share/nginx/html/repo/
sudo sed -i -E "s/index.+index.html.+index.htm;/index index.html index.htm;\n        autoindex on;/"  /etc/nginx/conf.d/default.conf
sudo nginx -s reload
sudo bash -c "echo -e \"[otus]\nname=otus-linux\nbaseurl=http://localhost/repo\ngpgcheck=0\nenabled=1\" >> /etc/yum.repos.d/otus.repo"
sudo yum install percona-release -y
```

#### Проверка:

```sh
curl -a http://localhost/repo/
```