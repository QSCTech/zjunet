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

根据发行版的不同，安装方式略有区别。为了更好的为您提供服务，建议您从求是潮网站的仓库下载。
（求是潮网站在校内也可以访问，安装时不需要先从仓库手动下载。）

考虑到需要安装 zjunet 的机器通常没有办法访问外网，建议配合 [浙大源](https://mirrors.zju.edu.cn/) 安装。

下面将按照不同的发行版分别列出安装步骤。如果你在安装前后遇到任何问题，请向下浏览本文件的“疑难解答”部分。

### Debian / Ubuntu (deb)

1. 使用 [浙大源配置生成器](https://mirrors.zju.edu.cn/#generator) 生成需要的浙大源配置，并按照提示将 `/etc/apt/sources.list` 替换为显示的内容。
2. 依次输入并执行下列命令：

``` bash
curl https://dl.zjuqsc.com/linux/qsc.public.key | sudo apt-key add -
curl https://dl.zjuqsc.com/linux/debian/qsc.list | sudo tee /etc/apt/sources.list.d/qsc.list
sudo apt-get update
sudo apt-get install zjunet
```

3. 安装结束！您可以输入 `zjunet version` 查看安装的版本，输入 `zjunet usage` 查看用法。
4. 如果你是服务器用户，建议运行 `zjunet wlan disable` 来彻底禁用 WLAN 功能。

### Fedora / CentOS (rpm)

1. 使用 [浙大源配置生成器](https://mirrors.zju.edu.cn/#generator) 生成需要的浙大源配置，并按照提示修改 `/etc/yum.repos.d` 中的文件。
2. 执行这些步骤以使用 [浙大源 EPEL](https://mirrors.zju.edu.cn/epel/) （以 CentOS 为例）：
	1. 运行 `yum install epel-release` 以安装 EPEL 。
	2. 编辑 `/etc/yum.repos.d/epel.repo` ，将所有以 `#baseurl=` 开头的行取消注释（删除行首 `#` 符号）并注释以 `mirrorlist=` 开头的行（在行首添加 `#` 符号）
	3. 继续编辑 `/etc/yum.repos.d/epel.repo` ，将所有 `https://download.fedoraproject.org/pub` 替换为 `https://mirrors.zju.edu.cn`。

3. 依次输入并执行下列命令：

```bash
curl https://dl.zjuqsc.com/linux/qsc.public.key | sudo tee /etc/pki/rpm-gpg/RPM-GPG-KEY-QSC-COMP66
curl https://dl.zjuqsc.com/linux/yum/qsc.repo | sudo tee /etc/yum.repos.d/qsc.repo
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-QSC-COMP66
sudo yum install zjunet
```

4. 安装结束！您可以输入 `zjunet version` 查看安装的版本，输入 `zjunet usage` 查看用法。
5. 如果你是服务器用户，建议运行 `zjunet wlan disable` 来彻底禁用 WLAN 功能。

### OpenWrt (opk)

从 [Releases 页](https://github.com/QSCTech/zjunet/releases) 下载 opk 包到路由器上，
运行 `opkg install ./zjunet_（版本）_all.opk` 。

### 其他 Linux (源代码安装)

```bash
xl2tpd -v; curl -V; dig -v # 检查依赖命令的安装情况。这句命令将输出三个版本号。
# 在合适的目录下
git clone https://github.com/QSCTech/zjunet.git
cd zjunet
sudo ./install.sh
# 如果想要更新请在 zjunet 目录下运行 git pull 并再次 sudo ./install.sh
# 如果你是服务器用户，建议运行 `zjunet wlan disable` 来彻底禁用 WLAN 功能。
```

**注意** 运行 `./install.sh` 时 **不会** 确认必要依赖是否已经安装。
您应当先运行 `xl2tpd -v` 、 `curl -V` 和 `dig -v` 确认安装。

## 疑难解答

### 出现了 `xl2tpd-control: command not found` 的提示但直接运行 `xl2tpd-control` 有效

出现这种情况通常是由于 `sudo` 的 `secure path` 被启用。

请编辑 `/etc/sudoers` 并在 `Defaults secure_path=xxxxxxx` 行添加 `xl2tpd-control` 所在路径（运行 `which xl2tpd-control` 查看）。编辑后的这行类似这样：

```
Defaults secure_path="/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin"
```

你可以运行 `sudo env | grep PATH` 来验证配置。显示的内容应当包括刚才添加的路径。

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
