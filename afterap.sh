#! /bin/sh

IPADDR='192.168.1.2'
GATEWAY='192.168.1.1'

# ファイアウォールとipv6オフ
BRIDGE='lan'
uci del dhcp.${BRIDGE}.ra
uci del dhcp.${BRIDGE}.ra_slaac
uci del dhcp.${BRIDGE}.ra_flags
uci del dhcp.${BRIDGE}.dhcpv6
uci del dhcp.${BRIDGE}.dns
uci set dhcp.${BRIDGE}.ignore='1'
uci del firewall.@device[0].network
uci del network.${BRIDGE}.dns
uci set add_list network.${BRIDGE}.dns=${GATEWAY}
uci commit
# wpad,batman,dawnをインストール
opkg update
opkg remove wpad-basic-mbedtls
opkg install wpad-openssl
opkg install luci-proto-batman-adv
opkg install luci-app-dawn

echo -e "\033[1;35m ${BRIDGE} device: br-lan\033[0;39m"
