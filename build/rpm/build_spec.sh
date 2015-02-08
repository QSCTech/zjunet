#!/bin/sh

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
echo "Packager: Senorsen <sen@senorsen.com>" >> zjunet.spec
echo "Requires: xl2tpd >= 1.3.1, curl" >> zjunet.spec
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
echo 'install -m 644 lib/version $RPM_BUILD_ROOT/usr/lib/zjunet/version' >> zjunet.spec
echo 'install -m 644 qsc.public.key $RPM_BUILD_ROOT/usr/share/zjunet/qsc.public.key' >> zjunet.spec
echo 'install -m 644 qsc.repo $RPM_BUILD_ROOT/usr/share/zjunet/qsc.repo' >> zjunet.spec
echo "" >> zjunet.spec
echo "%files" >> zjunet.spec
echo "%defattr(-,root,root)" >> zjunet.spec
echo "/usr/bin/zjunet" >> zjunet.spec
echo "/usr/share/zjunet/qsc.public.key" >> zjunet.spec
echo "/usr/share/zjunet/qsc.repo" >> zjunet.spec
echo "/usr/share/zjunet/zjunet-postinst" >> zjunet.spec
cd lib
for f in *; do
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
echo "%changelog" >> zjunet.spec
echo "* Sun Feb 08 2015 Senorsen <sen@senorsen.com> - 0.2.4" >> zjunet.spec
echo "- Genrate debian and opkg packages using fakeroot (in case of wrong uid)" >> zjunet.spec
echo "- Replace test IP with a more stable one" >> zjunet.spec
echo "* Sun Nov 23 2014 Zeno Zeng <zenoofzeng@gmail.com> - 0.2.3" >> zjunet.spec
echo "- build.sh & zjunet.sh now share lib/version" >> zjunet.spec
echo "- fork when calling xl2tpd-control" >> zjunet.spec
echo "* Sat Nov 22 2014 Senorsen <sen@senorsen.com> - 0.2.2" >> zjunet.spec
echo "- P-t-P server address issues" >> zjunet.spec
echo "- comment typo fixed" >> zjunet.spec
echo "* Wed Nov 12 2014 Zeno Zeng <zenoofzeng@gmail.com> - 0.2.1" >> zjunet.spec
echo "- xqyww123 fixed the compatibility with systemd" >> zjunet.spec
echo "- chaosink fixed the string escape problem in user.sh" >> zjunet.spec
echo "* Wed Oct 15 2014 Zeno Zeng <zenoofzeng@gmail.com> - 0.2.0" >> zjunet.spec
echo "- Use xl2tpd.conf, abandon \$HOME/.zjunet/" >> zjunet.spec
echo "- Setup route after connect / disconnect wlan" >> zjunet.spec
echo "* Mon Oct 13 2014 Zeno Zeng <zenoofzeng@gmail.com> - 0.1.2" >> zjunet.spec
echo "* Thu Oct 02 2014 Zeno Zeng <zenoofzeng@gmail.com> - 0.1.0" >> zjunet.spec
echo "- Initial version of the package" >> zjunet.spec

