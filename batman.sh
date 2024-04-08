#! /bin/sh

IPADDR='192.168.1.2'
GATEWAY='192.168.1.1'
PASSWORD='****'

BRIDGE='lan'
BRIDGE6='lan6'

# batman設定
uci set network.bat0=interface
uci set network.bat0.proto='batadv'
uci set network.bat0.routing_algo='BATMAN_IV'
uci set network.bat0.bridge_loop_avoidance='1'
uci set network.bat0.gw_mode='off'
uci set network.bat0.hop_penalty='30'
uci set network.batmesh=interface
uci set network.batmesh.proto='batadv_hardif'
uci set network.batmesh.master='bat0'
uci set wireless.wifinet2=wifi-iface
uci set wireless.wifinet2.device='radio0'
uci set wireless.wifinet2.mode='mesh'
uci set wireless.wifinet2.encryption='sae'
uci set wireless.wifinet2.mesh_id='mesh_an'
uci set wireless.wifinet2.mesh_fwding='0'
uci set wireless.wifinet2.mesh_rssi_threshold='0'
uci set wireless.wifinet2.key='${PASSWORD}'
uci set wireless.wifinet2.network='batmesh'
uci add_list network.@device[0].ports='bat0.99'

uci commit

echo -e "\033[1;35m ${BRIDGE} device: br-lan\033[0;39m"
