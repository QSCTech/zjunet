# zjunet

适用于 ZJU 的 VPN, WLAN 和 DNS 命令行工具。

## 功能

- 支持 ZJU VPN 连接。

- 支持 ZJUWLAN 连接。

- 路由器支持。

- 多拨支持（多账户负载均衡）。

- ZJUWLAN 与 ZJUVPN 带宽叠加（1 WLAN + N VPN，在 ZJUWLAN 下） 

- DNS 自动测试设置（适用于 DNS 坏掉的情况）

## 依赖

- xl2tpd

- curl

- `dig` （在不同平台的包不同）

## 安装

### Debian / Ubuntu (deb)

#### 直接安装 deb 包

从 [Releases 页](https://github.com/QSCTech/zjunet/releases) 下载 deb 包，
双击安装或运行 `sudo apt-get install ./zjunet_（版本）_all.deb` 。

### Fedora / CentOS (rpm)

#### 直接安装 rpm 包

从 [Releases 页](https://github.com/QSCTech/zjunet/releases) 下载 rpm 包，
双击安装或运行 `sudo yum localinstall zjunet-（版本）.noarch.rpm` 。

**注意** CentOS 7 中需要 epel 源提供 xl2tpd 。

### OpenWrt (opk)

从 [Releases 页](https://github.com/QSCTech/zjunet/releases) 下载 opk 包到路由器上，
运行 `opkg install ./zjunet_（版本）_all.opk` 。

### Other linux (源代码安装)

```bash
# 在合适的目录下
git clone https://github.com/QSCTech/zjunet.git
cd zjunet
sudo ./install.sh
# 如果想要更新请在 zjunet 目录下运行 git pull 并再次 sudo ./install.sh
```

**注意** 运行 `./install.sh` 时 **不会** 确认必要依赖是否已经安装。
您应当运行 `xl2tpd -v` 、 `curl -V` 和 `dig -v` 确认安装。

## 疑难解答

### 丢包

这是一个已知问题。在同时连接 VPN 和 ZJUWLAN 时，
在有的机子上会丢包（因为设定的路由使用了 nexthop ）。

暂时没有人来解决这个问题，欢迎有志者贡献（可以考虑用 `iptables` ）

### OpenWrt 上的 ppp0 消失了

将 /etc/ppp/options 中的 lcp-echo-failure 调大。

可见于 #39

### 我还有其它问题

如果你还有其它问题，请与我们联系。

您可以发送邮件至 tech@zjuqsc.com 。

## 如何贡献

求是潮成员可以直接向这个仓库 Push 而不用发起 Pull requests。

有任何疑虑都可以提 Issue ，也可以与现任 Maintainer 联系。

**本项目也接受非求是潮成员发起的 PR 。**

### 开发指南

开发信息请查看 [英文 README](README.md#packaging-instruction) 。
