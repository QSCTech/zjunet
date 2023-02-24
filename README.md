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

## Installation

If you meet any problem during or after the installation, check Troubleshooting section below in this documentation.

### Debian / Ubuntu (deb)

1. Configure ZJU mirrors from manual. [Ubuntu](https://mirror.zju.edu.cn/docs/ubuntu/)/[Debian](https://mirror.zju.edu.cn/docs/debian/)
2. Run these command.

``` bash
curl https://dl.zjuqsc.com/linux/qsc.public.key | sudo apt-key add -
curl https://dl.zjuqsc.com/linux/debian/qsc.list | sudo tee /etc/apt/sources.list.d/qsc.list
sudo apt-get update
sudo apt-get install zjunet
```

3. The installation has completed.
4. If you are setting up a server, we suggest you run `zjunet wlan disable` to disable WLAN capability.

### Fedora / CentOS (rpm)

1. Configure ZJU mirrors from manual. [Fedora](https://mirror.zju.edu.cn/docs/fedora/)/[CentOS](https://mirror.zju.edu.cn/docs/centos/)
2. Configure [EPEL of ZJU mirrors](https://mirrors.zju.edu.cn/epel/) (Taking CentOS installation as an example)
	1. Run `yum install epel-release` to install EPEL.
	2. Edit `/etc/yum.repos.d/epel.repo` , uncomment lines begin with `#baseurl=` (Remove leading `#` sign) and comment lines begin with `mirrorlist=` (Prepend `#` sign)
	3. Edit `/etc/yum.repos.d/epel.repo` , replace `https://download.fedoraproject.org/pub` with `https://mirrors.zju.edu.cn` .

3. Run these command.

```bash
curl https://dl.zjuqsc.com/linux/qsc.public.key | sudo tee /etc/pki/rpm-gpg/RPM-GPG-KEY-QSC-COMP66
curl https://dl.zjuqsc.com/linux/yum/qsc.repo | sudo tee /etc/yum.repos.d/qsc.repo
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-QSC-COMP66
sudo yum install zjunet
```

4. The installation has completed.
5. If you are setting up a server, we suggest you run `zjunet wlan disable` to disable WLAN capability.

### OpenWrt (opk)

Download .opk package from [Release Page](https://github.com/QSCTech/zjunet/releases) (onto your router),
Run `opkg install ./zjunet_<version>_all.opk`.

### Arch Linux (AUR)

Simply run `yay zjunet` to build the package from AUR and install it.

Keep in mind that a fresh install without internet connection is almost impossible.
Please complete installation before connecting to the intranet.

### Other Linux (Build from source code)

```bash
xl2tpd -v; curl -V; dig -v # Check installation of dependencies. There should be 3 version numbers.
# Under proper directory
git clone https://github.com/QSCTech/zjunet.git
cd zjunet
sudo ./install.sh
# If update is necessary, run `git pull` and `sudo ./install.sh`
# If you are setting up a server, we suggest you run `zjunet wlan disable` to disable WLAN capability.
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
