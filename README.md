# Openwrt setting custom
This configuration file is a customized version of site-u2023/config-software.
For detailed information, please refer to https://github.com/site-u2023/config-software.
This file is for OpenWrt 23.05.5 (October 4, 2024).

## New settings All-in-one script Suitable for beginners

### [SSH access](https://openwrt.org/docs/guide-quick-start/sshadministration)

If you cannot SSH
Reset SSH login information:
In Windows PowerShell, use Clear-Content .ssh\known_hosts -Force
In MacOS Terminal, use ssh-keygen -R 192.168.xx.xx
 
### ttyd installation and configuration

- ttyd.sh
```sh:SSH
mkdir -p /etc/opwrt-config; wget --no-check-certificate -O /etc/opwrt-config/ttyd.sh https://raw.githubusercontent.com/yousuk3/opwrt-config/main/ttyd.sh; sh /etc/opwrt-config/ttyd.sh

```

### Run Script

Permited only from LAN side

No login authentication

:warning: Can be changed from ttyd settings

- Run from browser: 
**[openwrt.lan:8888](http://openwrt.lan:8888)** [(192.168.1.1:8888)](http://192.168.1.1:8888)

- Run from command
```sh:SSH
confsoft

```
:warning: forced termination：`Ctrl`+`c`

### Remove
```sh :SSH
rm -rf /etc/opwrt-config
rm -rf /usr/bin/confsoft

```

## Access

### [LuCi](https://qiita.com/site_u/items/a23d165201081817cb00#luciweb%E7%AE%A1%E7%90%86%E7%94%BB%E9%9D%A2)

- Run from LuCi:
**[openwrt.lan](http://openwrt.lan)** [(192.168.1.1)](http://192.168.1.1)
  - User Name：`root`
  - Password：`Password you set`

### [TTYD](https://qiita.com/site_u/items/a23d165201081817cb00#ttyd)
Filer (used like Explorer with WinSCP)

- Run from browser:
**[openwrt.lan:7681](http://openwrt.lan:7681)** [(192.168.1.1:7681)](http://192.168.1.1:7681)

- Run from LuCi:
**[openwrt.lan/ttyd](openwrt.lan/cgi-bin/luci/admin/services/ttyd)** [(http://192.168.1.1/ttyd)](http://192.168.1.1/cgi-bin/luci/admin/services/ttyd)

### [SFTP](https://qiita.com/site_u/items/a23d165201081817cb00#sftp-server)

- Download: [WinSCP](https://winscp.net/eng/download.php)
  
  Start WinSCP

- Session
  - Host Nmae：`192.168.1.1`
  - User Name：`root`
  - Password：`Password you set`
  - login `Click `

### [Guest Wi-Fi](https://qiita.com/site_u/items/f42be7c0953187b9428a#%E3%82%B2%E3%82%B9%E3%83%88%E3%81%AE%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E5%8C%96-qr%E3%82%B3%E3%83%BC%E3%83%89%E7%99%BA%E8%A1%8C%E3%81%A8%E3%83%A9%E3%83%B3%E3%83%80%E3%83%A0%E3%83%91%E3%82%B9%E3%83%AF%E3%83%BC%E3%83%89)

- QR Code Issuance:
**[openwrt.lan/guest.html](http://openwrt.lan/guest.html)** [(192.168.1.1/guest.html)](http://192.168.1.1/guest.html)

### [AdGuard HOME](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc#adguard-home)

- initial value:
**[openwrt.lan:3000](http://openwrt.lan:3000)** [(192.168.1.1:3000)](http://192.168.1.1:3000)

## Initialization

### [Factory reset (initialization)](https://openwrt.org/docs/guide-user/troubleshooting/failsafe_and_factory_reset#soft_factory_reset)
```sh
# attention required
firstboot && reboot now

```
`This will erase all settings and remove any installed packages. Are you sure? [N/y]`
- `y`

### [Device reset button](https://openwrt.org/docs/guide-user/troubleshooting/failsafe_and_factory_reset#reset_button)
Press and hold the reset button on the device for 5 seconds


## Qiita

[Beginner's memorandum Introduced from Windows](https://qiita.com/site_u/items/39fbac482c06c98b229b)
