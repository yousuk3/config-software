#! /bin/sh

GATEWAY='192.168.1.1'
PASSWORD='abcd1234'

# batman設定
uci set network.bat0=interface
uci set network.bat0.proto='batadv'
uci set network.bat0.routing_algo='BATMAN_IV'
uci set network.bat0.aggregated_ogms='1'
uci set network.bat0.ap_isolation='0'
uci set network.bat0.bonding='0'
uci set network.bat0.bridge_loop_avoidance='1'
uci set network.bat0.distributed_arp_table='1'
uci set network.bat0.fragmentation='1'
uci set network.bat0.gw_mode='off'
uci set network.bat0.hop_penalty='30'
uci set network.bat0.isolation_mark='0x00000000/0x00000000'
uci set network.bat0.log_level='0'
uci set network.bat0.multicast_mode='1'
uci set network.bat0.multicast_fanout='16'
uci set network.bat0.network_coding='0'
uci set network.bat0.orig_interval='1000'
uci set network.bat0_hardif_mesh0=interface
uci set network.bat0_hardif_mesh0.proto='batadv_hardif'
uci set network.bat0_hardif_mesh0.master='bat0'
uci set network.bat0_hardif_mesh0.mtu='1536'
uci set network.bat0_hardif_mesh1=interface
uci set network.bat0_hardif_mesh1.proto='batadv_hardif'
uci set network.bat0_hardif_mesh1.master='bat0'
uci set network.bat0_hardif_mesh1.mtu='1536'
uci set network.bat0_hardif_eth0=interface
uci set network.bat0_hardif_eth0.disable='1'
uci set network.bat0_hardif_eth0.proto='batadv_hardif'
uci set network.bat0_hardif_eth0.master='bat0'
uci set network.bat0_hardif_eth0.mtu='1536'
#uci set network.bat0_hardif_eth0.device='eth0.1'
uci set network.bat0_hardif_eth0.hop_penalty='15'
uci set wireless.mesh0=wifi-iface
uci set wireless.mesh0.disabled='0'
uci set wireless.mesh0.device='radio0'
uci set wireless.mesh0.network='bat0_hardif_mesh0'
uci set wireless.mesh0.mode='mesh'
uci set wireless.mesh0.mesh_id='home-mesh'
uci set wireless.mesh0.encryption='sae'
uci set wireless.mesh0.key=${PASSWORD}
uci set wireless.mesh0.mesh_fwding='0'
uci set wireless.mesh0.mesh_ttl='1'
uci set wireless.mesh0.mcast_rate='24000'
uci set wireless.mesh0.mesh_rssi_threshold='0'
uci set wireless.mesh1=wifi-iface
uci set wireless.mesh1.disabled='1'
uci set wireless.mesh1.device='radio1'
uci set wireless.mesh1.network='bat0_hardif_mesh1'
uci set wireless.mesh1.mode='mesh'
uci set wireless.mesh1.mesh_id='home-mesh'
uci set wireless.mesh1.encryption='sae'
uci set wireless.mesh1.key=${PASSWORD}
uci set wireless.mesh1.mesh_fwding='0'
uci set wireless.mesh1.mesh_ttl='1'
uci set wireless.mesh1.mcast_rate='24000'
uci set wireless.mesh1.mesh_rssi_threshold='0'
uci add_list network.@device[0].ports='bat0'

uci commit

echo -e "\033[1;35m lan device: br-lan\033[0;39m"
