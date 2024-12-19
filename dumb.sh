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
# IPV4

# モデル名を取得
MODEL_NAME=$(cat /etc/board.json | jsonfilter -e '@["model"]["name"]')
# モデル名に応じてポートを追加
if [ "$MODEL_NAME" = "Buffalo WSR-2533DHP2" ]; then
    uci add_list network.@device[0].ports='eth0.2'
elif [ "$MODEL_NAME" = "Meraki MR52" ]; then
    uci add_list network.@device[0].ports='eth1'
else
#    uci add_list network.@device[0].ports='wan'
fi

BRIDGE='lan'
uci set network.${BRIDGE}=interface
uci set network.${BRIDGE}.proto='static'
uci set network.${BRIDGE}.device=${LAN_DEVICE}
uci set network.${BRIDGE}.ipaddr=${IPADDR}
uci set network.${BRIDGE}.netmask='255.255.255.0'
uci set network.${BRIDGE}.gateway=${GATEWAY}
uci set network.${BRIDGE}.dns=${GATEWAY}
uci set network.${BRIDGE}.delegate='0'
# IPV6
BRIDGE6='lan6'
uci set network.${BRIDGE6}=interface
uci set network.${BRIDGE6}.proto='dhcpv6'
uci set network.${BRIDGE6}.device=@${BRIDGE}
uci set network.${BRIDGE6}.reqaddress='try'
uci set network.${BRIDGE6}.reqprefix='no'
# uci set network.${BRIDGE6}.type='bridge'
# 既存のワイヤレスネットワークを変更する
uci set wireless.default_radio0.network=${BRIDGE}
uci set wireless.default_radio1.network=${BRIDGE}
# NTPサーバー
uci set system.ntp=timeserver
uci set system.ntp.enable_server='0'
uci set system.ntp.use_dhcp='1'
uci set system.ntp.server=${GATEWAY}
# マルチキャスト
uci set network.globals.packet_steering='1'
# uci set network.globals.igmp_snooping='1' # igmp_snoopingはglobalsの設定項目にない
uci set network.@device[0].igmp_snooping='1'
#
uci set dropbear.@dropbear[0].Interface=${BRIDGE}
# band steering
# BROADCAST_IP="${IPADDR%.*}.255"
# # uci set dawn.@network[0].broadcast_ip=$BROADCAST_IP
# # uci set dawn.@metric[0].kicking=1
# uci set dawn.global.kicking='1'
# uci set dawn.@local[0].loglevel='5'
# uci set dawn.802_11a.ht_support='0'
# uci set dawn.802_11a.vht_support='0'
# uci set dawn.802_11g.ht_support='0'
# uci set dawn.802_11g.vht_support='0'
# uci del_list umdns.@umdns[0].network='lan'
# uci add_list umdns.@umdns[0].network=${BRIDGE}
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
# wpa_supplicantを無効にする(STA WiFiインターフェースがない場合)
# rm /usr/sbin/wpa_supplicant
# {
# デーモンを永続的に無効にする
# for i in firewall dnsmasq odhcpd; do
#   if /etc/init.d/"$i" enabled; then
#     /etc/init.d/"$i" disable
#     /etc/init.d/"$i" stop
#   fi
# done
# }
# 複数の AP にわたってホスト名を表示できるようにする
opkg update
opkg install fping
opkg install arp-scan
sed -i "/exit 0/d" /etc/rc.local
echo "arp-scan -qxlN -I br-lan | awk '{print $1}' | xargs fping -q -c1" >> /etc/rc.local 
echo "exit 0" >> /etc/rc.local
echo "0 */1 * * * arp-scan -qxlN -I br-lan | awk '{print $1}' | xargs fping -q -c1" >> /etc/crontabs/root
echo -e "\033[1;35m ${BRIDGE} device: br-lan\033[0;39m"
