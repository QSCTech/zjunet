# zjunet

[查看中文README](README.zh.md)

Command Line Scripts for ZJU (VPN / WLAN / DNS)

## Features

- ZJU VPN (l2tp)

- ZJUWLAN

- Router support

- Overlap network dialing (with load balance)

- Overlap bandwidth of ZJUWLAN and ZJU VPN (1 WLAN + N VPN, Using ZJUWLAN) 

- Automatic DNS setting (in case DNS do not work)

## Requirements

- xl2tpd

- curl

- `dig` (Different package on different platform)

## Install

### Debian / Ubuntu (deb)

#### Install .deb package directly

Download .deb package from [Release Page](https://github.com/QSCTech/zjunet/releases),
Click or run `sudo apt-get install ./zjunet_<version>_all.deb` to install.

### Fedora / CentOS (rpm)

#### Install .rpm package directly

Download .rpm package from [Release Page](https://github.com/QSCTech/zjunet/releases),
Click or run `sudo yum localinstall zjunet-<version>.noarch.rpm` to install.

**ATTENTION** In CentOS 7, *xl2tpd* requires epel.

### OpenWrt (opk)

Download .opk package from [Release Page](https://github.com/QSCTech/zjunet/releases) (onto your router),
Run `opkg install ./zjunet_<version>_all.opk`.

### Other linux (Source Code)

```bash
# Under proper directory
git clone https://github.com/QSCTech/zjunet.git
cd zjunet
sudo ./install.sh
# If update is necessary, run `git pull` and `sudo ./install.sh`
```

**ATTENTION** Requirement check will **NOT** be done running `./install.sh`.
Please run `xl2tpd -v`, `curl -V` and `dig -v` to verify the installation.

## Troubleshooting

### Packet lose

This is a known issue.
When overlapping VPN and ZJUWLAN, network packet may be lost.
(because of nexthop in routing table).

Contributions to this issue are welcomed. (Maybe using `iptables`)

### ppp0 may disappears on OpenWrt

Set lcp-echo-failure larger in /etc/ppp/options.

See also #39

### Other problems?

Please send mail to tech@zjuqsc.com if you have any other problem.

## Contribute to this project

QSCers may Push directly without sending Pull Requests。

Please write an Issue if you have worries. Contact maintainer directly if necessary.

**PRs from non-QSCers are also welcomed.**

### Packaging Instruction

*(Not finished yet)*

#### Debian

```bash
sudo apt-get install build-essential autoconf automake autotools-dev dh-make \
  debhelper devscripts fakeroot xutils lintian pbuilder rpm
cd build
./build.sh
```

##### See Also

- http://www.webupd8.org/2010/01/how-to-create-deb-package-ubuntu-debian.html

- http://tldp.org/HOWTO/html_single/Debian-Binary-Package-Building-HOWTO/

#### OpenWrt

##### See Also

- http://lists.openmoko.org/pipermail/devel/2008-July/000496.html

### Links

- [Array in unix Bourne Shell](http://unix.stackexchange.com/questions/137566/array-in-unix-bourne-shell)

- [How do you tell if a string contains another string in Unix shell scripting?](http://stackoverflow.com/questions/2829613/how-do-you-tell-if-a-string-contains-another-string-in-unix-shell-scripting)
