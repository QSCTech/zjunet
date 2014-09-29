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

### vpn

- xl2tpd

### wlan

- curl

- iconv

## Install

```bash
git clone https://github.com/QSCTech/zjunet.git
cd zjunet
sudo ./install.sh
```

## Dev

QSCer 可以直接向这个 repo push 而不用发 pull request。
有什么疑虑可以提 issue 问一下，
或者直接来办公室找我(zenozeng)。
master分支请尽可能保持稳定，
如果要做破坏性变更的话，
进 dev 分支，
或者拉开发分支。

### Build

#### DEB

```bash
sudo apt-get install build-essential autoconf automake autotools-dev dh-make debhelper devscripts fakeroot xutils lintian pbuilder
```

see also: http://www.webupd8.org/2010/01/how-to-create-deb-package-ubuntu-debian.html

## Links

- [Array in unix Bourne Shell](http://unix.stackexchange.com/questions/137566/array-in-unix-bourne-shell)

- [How do you tell if a string contains another string in Unix shell scripting?](http://stackoverflow.com/questions/2829613/how-do-you-tell-if-a-string-contains-another-string-in-unix-shell-scripting)
