#! /bin/sh

IPADDR='192.168.1.2'
GATEWAY='192.168.1.1'

LAN_DEVICE=`uci get network.lan.device`

# ネットワークを変更する
cp /etc/config/system /etc/config/system.dump.bak
cp /etc/config/network /etc/config/network.dump.bak
cp /etc/config/dhcp /etc/config/dhcp.dump.bak
cp /etc/config/firewall /etc/config/firewall.dump.bak
cp /etc/config/wireless /etc/config/wireless.dump.bak
cp /etc/config/dropbear /etc/config/dropbear.dump.bak
uci delete network.wan
uci delete network.wan6
uci delete network.lan
uci delete system.ntp.server
uci -q delete network.globals.ula_prefix
# WANポート追加
#uci add_list network.@device[0].ports='wan'
uci add_list network.@device[0].ports='eth0.2'
# IPV4
BRIDGE='bridge'
uci set network.${BRIDGE}=interface
uci set network.${BRIDGE}.proto='static'
uci set network.${BRIDGE}.device=${LAN_DEVICE}
uci set network.${BRIDGE}.ipaddr=${IPADDR}
uci set network.${BRIDGE}.netmask='255.255.255.0'
uci set network.${BRIDGE}.gateway=${GATEWAY}
uci set network.${BRIDGE}.dns=${GATEWAY}
uci set network.${BRIDGE}.delegate='0'
# IPV6
BRIDGE6='bridge6'
uci set network.${BRIDGE6}=interface
uci set network.${BRIDGE6}.proto='dhcpv6'
uci set network.${BRIDGE6}.device=@${BRIDGE}
uci set network.${BRIDGE6}.reqaddress='try'
uci set network.${BRIDGE6}.reqprefix='no'
uci set network.${BRIDGE6}.type='bridge'
# TTYD setup
uci set ttyd.@ttyd[0].interface=@${BRIDGE6}
uci set ttyd.ttyd.interface=@${BRIDGE6}
# 既存のワイヤレスネットワークを変更する
uci set wireless.default_radio0.network=${BRIDGE}
uci set wireless.default_radio1.network=${BRIDGE}
# ワイヤレス設定
uci set wireless.default_radio0.dtim_period='3'
uci set wireless.default_radio0.encryption='psk2'
uci set wireless.default_radio0.ieee80211r='1'
uci set wireless.default_radio0.mobility_domain='6781'
uci set wireless.default_radio0.ft_over_ds='0'
uci set wireless.default_radio0.ft_psk_generate_local='1'
uci set wireless.radio1.txpower='5'
uci set wireless.default_radio1.dtim_period='3'
uci set wireless.default_radio1.encryption='psk2'
# NTPサーバー
uci set system.ntp=timeserver
uci set system.ntp.enable_server='0'
uci set system.ntp.use_dhcp='1'
uci set system.ntp.server=${GATEWAY}
# マルチキャスト
uci set network.globals.packet_steering='1'
uci set network.globals.igmp_snooping='1'
#
uci set dropbear.@dropbear[0].Interface=${BRIDGE}

uci commit

# DHCPサーバーを無効にする
/etc/init.d/odhcpd disable
/etc/init.d/odhcpd stop
# DNSを無効にする
/etc/init.d/dnsmasq disable
/etc/init.d/dnsmasq stop
# ファイアウォールを無効にする
/etc/init.d/firewall disable
/etc/init.d/firewall stop
# wpa_supplicantを無効にする
#rm /usr/sbin/wpa_supplicant
# {
# デーモンを永続的に無効にする
# for i in firewall dnsmasq odhcpd; do
#   if /etc/init.d/"$i" enabled; then
#     /etc/init.d/"$i" disable
#     /etc/init.d/"$i" stop
#   fi
# done
# }

# wpad,batman,dawnをインストール
opkg update
opkg remove wpad-basic-mbedtls
opkg install wpad-openssl
opkg install luci-proto-batman-adv

# 複数の AP にわたってホスト名を表示できるようにする
#opkg update
opkg install fping
opkg install arp-scan
sed -i "/exit 0/d" /etc/rc.local
echo "arp-scan -qxlN -I br-lan | awk '{print $1}' | xargs fping -q -c1" >> /etc/rc.local 
echo "exit 0" >> /etc/rc.local
echo "0 */1 * * * arp-scan -qxlN -I br-lan | awk '{print $1}' | xargs fping -q -c1" >> /etc/crontabs/root

echo -e "\033[1;35m ${BRIDGE} device: br-lan\033[0;39m"
