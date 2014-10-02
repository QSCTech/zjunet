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

### Debian / Ubuntu

https://github.com/QSCTech/zjunet/releases 
下载 deb，双击安装就是。

### Openwrt

https://github.com/QSCTech/zjunet/releases 
下载 opk，然后 `opkg install` 就是。

### From source

一般来说 master 分支是稳定的，dev 分支会有破坏性变更。

```bash
git clone https://github.com/QSCTech/zjunet.git
cd zjunet
sudo ./install.sh
```

## Known Issues

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
master分支请尽可能保持稳定，
如果要做破坏性变更的话，
进 dev 分支，
或者拉开发分支。

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
