#!/bin/bash

VERSION=$1
REALVERSION=`echo "$VERSION" | cut -d'-' -f1`
RELEASE=`echo "$VERSION" | cut -d'-' -f2`

echo "Summary: Command Line Scripts for ZJU " > zjunet.spec
echo "Name: zjunet" >> zjunet.spec
echo "Version: $REALVERSION" >> zjunet.spec
echo "Release: $RELEASE" >> zjunet.spec
echo "License: GPL" >> zjunet.spec
echo "Group: Applications/Internet" >> zjunet.spec
echo "URL: https://github.com/QSCTech/zjunet/" >> zjunet.spec
echo "Vendor: Qiu Shi Chao Website of Zhejiang University" >> zjunet.spec
echo "Packager: Tespent <me@tespent.cn>" >> zjunet.spec
echo "Requires: xl2tpd >= 1.3.7, curl, bind-utils" >> zjunet.spec
echo "BuildRoot:  %{_builddir}/%{name}-root" >> zjunet.spec
echo "Source: %{name}-%{version}.tar.gz" >> zjunet.spec
echo "BuildArch: noarch" >> zjunet.spec
echo "" >> zjunet.spec
echo "%description" >> zjunet.spec
echo "Command Line Scripts for ZJU " >> zjunet.spec
echo "This script provides a VPN / WLAN / NEXTHOP for ZJUer. " >> zjunet.spec
echo "" >> zjunet.spec
echo "%prep" >> zjunet.spec
echo "%setup -q" >> zjunet.spec
echo "" >> zjunet.spec
echo "%build" >> zjunet.spec
echo 'echo $RPM_BUILD' >> zjunet.spec
echo "" >> zjunet.spec
echo "%install" >> zjunet.spec
echo 'rm -rf $RPM_BUILD_ROOT' >> zjunet.spec
echo 'mkdir -p $RPM_BUILD_ROOT/usr/bin' >> zjunet.spec
echo 'mkdir -p $RPM_BUILD_ROOT/usr/lib/zjunet' >> zjunet.spec
echo 'mkdir -p $RPM_BUILD_ROOT/usr/share/zjunet' >> zjunet.spec
echo 'install -m 755 zjunet $RPM_BUILD_ROOT/usr/bin/zjunet' >> zjunet.spec
echo 'install -m 755 zjunet-postinst $RPM_BUILD_ROOT/usr/share/zjunet/zjunet-postinst' >> zjunet.spec
cd lib
for f in *.sh; do
	echo "install -m 755 lib/$f \$RPM_BUILD_ROOT/usr/lib/zjunet/$f" >> ../zjunet.spec
done
cd ..
echo 'install -m 644 VERSION $RPM_BUILD_ROOT/usr/share/zjunet/VERSION' >> zjunet.spec
echo 'install -m 644 qsc.public.key $RPM_BUILD_ROOT/usr/share/zjunet/qsc.public.key' >> zjunet.spec
echo 'install -m 644 qsc.repo $RPM_BUILD_ROOT/usr/share/zjunet/qsc.repo' >> zjunet.spec
echo "" >> zjunet.spec
echo "%files" >> zjunet.spec
echo "%defattr(-,root,root)" >> zjunet.spec
echo "/usr/bin/zjunet" >> zjunet.spec
echo "/usr/share/zjunet/qsc.public.key" >> zjunet.spec
echo "/usr/share/zjunet/qsc.repo" >> zjunet.spec
echo "/usr/share/zjunet/zjunet-postinst" >> zjunet.spec
echo "/usr/share/zjunet/VERSION" >> zjunet.spec
cd lib
for f in *.sh; do
	echo "/usr/lib/zjunet/$f" >> ../zjunet.spec
done
cd ..
echo "" >> zjunet.spec
echo "%clean" >> zjunet.spec
echo 'rm -rf $RPM_BUILD_ROOT' >> zjunet.spec
echo "" >> zjunet.spec
echo "%post" >> zjunet.spec
echo "/usr/share/zjunet/zjunet-postinst || true" >> zjunet.spec
echo "" >> zjunet.spec

../../changelog.py rpm >> zjunet.spec
