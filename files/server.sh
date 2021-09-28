#!/bin/bash
sudo yum install -y nano redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
sudo rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
wget https://www.openssl.org/source/openssl-1.1.1l.tar.gz #качаем версию 1.1.1 потому как с latest не завелось.
sudo tar -xvf openssl-1.1.1l.tar.gz
sudo yum-builddep -y /root/rpmbuild/SPECS/nginx.spec
sudo cp /home/vagrant/nginx.spec /root/rpmbuild/SPECS/nginx.spec
sudo rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
sudo ls /root/rpmbuild/RPMS/x86_64/
sudo yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
systemctl enable nginx
systemctl start nginx