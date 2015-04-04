# zjunet

Command Line Scripts for ZJU (VPN / WLAN / DNS)

## Features

- ZJU VPN (l2tp)

- ZJU WLAN

- 路由器支持（written in Bourne Shell）

- 多拨支持（多账户负载均衡）

- ZJUWLAN 与 ZJUVPN 带宽叠加（1 WLAN + N VPN，在 ZJUWLAN 下）

- DNS 自动测试设置（适用于 DNS 坏掉的情况）

## Requirements

- xl2tpd

- curl

## Install

### Debian / Ubuntu (deb)

Use only one of the methods below:

#### 1. From QSC website's linux repository
    
    wget -qO - https://dl.zjuqsc.com/linux/qsc.public.key | sudo apt-key add -
    sudo wget https://dl.zjuqsc.com/linux/debian/qsc.list -O /etc/apt/sources.list.d/qsc.list
    sudo apt-get update
    sudo apt-get install zjunet
    
#### 2. Download deb
https://github.com/QSCTech/zjunet/releases
下载 deb，双击安装就是。

### Fedora / CentOS (rpm)
在 Releases 中下载安装方法如上。注意 CentOS 7 中需要 epel 源提供 xl2tpd 

#### Install from QSC website's linux repository
    
    sudo wget https://dl.zjuqsc.com/linux/qsc.public.key -O /etc/pki/rpm-gpg/RPM-GPG-KEY-QSC-COMP66
	sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-QSC-COMP66
	sudo wget https://dl.zjuqsc.com/linux/yum/qsc.repo -O /etc/yum.repos.d/qsc.repo
	sudo yum install zjunet
    

### Openwrt

https://github.com/QSCTech/zjunet/releases
下载 opk，然后 `opkg install` 就是。

### From source

master分支是开发分支，请直接从 release 那里获取源码。

```bash
cd zjunet
sudo ./install.sh
```

## Known Issues

### 丢包

在有的机子上会丢包（因为用的是 nexthop ）。
等有空了也许会换成 iptables 来解决这个问题。

### ppp0 may disappear on openwrt

make /etc/ppp/options's lcp-echo-failure larger.

see also https://github.com/QSCTech/zjunet/issues/39

## Openwrt

Install xl2tpd:

https://downloads.openwrt.org/snapshots/trunk/ar71xx/packages/packages/

## Dev

QSCer 可以直接向这个 repo push 而不用发 pull request。
有什么疑虑可以提 issue 问一下，
或者直接来办公室找我(zenozeng)。

master分支就是开发分支。
但是请保证bump version的时候要稳定。

### Build

#### Debian

```bash
sudo apt-get install build-essential autoconf automake autotools-dev dh-make debhelper devscripts fakeroot xutils lintian pbuilder
```

##### see also

- http://www.webupd8.org/2010/01/how-to-create-deb-package-ubuntu-debian.html

- http://tldp.org/HOWTO/html_single/Debian-Binary-Package-Building-HOWTO/

#### Openwrt

##### see also

- http://lists.openmoko.org/pipermail/devel/2008-July/000496.html

## Links

- [Array in unix Bourne Shell](http://unix.stackexchange.com/questions/137566/array-in-unix-bourne-shell)

- [How do you tell if a string contains another string in Unix shell scripting?](http://stackoverflow.com/questions/2829613/how-do-you-tell-if-a-string-contains-another-string-in-unix-shell-scripting)
