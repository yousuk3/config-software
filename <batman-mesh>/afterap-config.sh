#! /bin/sh

function _func_Dumb_GATEWAY
while :
do
  echo -e "\033[1;37m Enter gateway of access point\033[0;39m"
  echo -e "\033[1;33m Example: 192.168.1.1\033[0;39m"
  read -p " gateway: " input_str_GATEWAY
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Mesh_PASSWORD ;;
    "n" ) _func_Dumb_GATEWAY ;;
    "r" ) break ;;
  esac
done

function _func_Mesh_PASSWORD
while :
do
  echo -e "\033[1;37m Enter mesh password\033[0;39m"
  read -p " password: " input_str_PASSWORD
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Dumb_confirmation ;;
    "n" ) _func_Mesh_PASSWORD ;;
    "r" ) break ;;
  esac
done

function _func_Dumb_confirmation
while :
do
  echo -e " \033[1;37mAccess point ----------------------------------------\033[0;39m"
  echo -e " \033[1;32mGateway: ${input_str_GATEWAY}\033[0;39m"
  echo -e " \033[1;32mPassword: ${input_str_PASSWORD}\033[0;39m"
  echo -e " \033[1;37m-----------------------------------------------------\033[0;39m"
  read -p " Please select key [y/n or r]: " num
  case "${num}" in
    "y" ) _func_Dumb_SET ;;
    "n" ) _func_Dumb_GATEWAY ;;
    "r" ) break ;;
  esac
done

function _func_Dumb_SET
{
wget --no-check-certificate -O /etc/config-software/afterap.sh https://raw.githubusercontent.com/yousuk3/config-software/main/afterap.sh
sed -i -e "s/GATEWAY='192.168.1.1'/GATEWAY='${input_str_GATEWAY}'/g" /etc/config-software/afterap.sh
sed -i -e "s/PASSWORD='abcd1234'/PASSWORD='${input_str_PASSWORD}'/g" /etc/config-software/afterap.sh
sh /etc/config-software/afterap.sh 2> /dev/null
read -p " Press any key (to reboot the device)"
reboot
}

OPENWRT_RELEAS=`cat /etc/banner | grep OpenWrt | awk '{ print $2 }' | cut -c 1-2`
if [ "${OPENWRT_RELEAS}" = "23" ] || [ "${OPENWRT_RELEAS}" = "22" ] || [ "${OPENWRT_RELEAS}" = "21" ] || [ "${OPENWRT_RELEAS}" = "SN" ]; then
 echo -e " \033[1;37mVersion Check: OK\033[0;39m"
 else
 read -p " Exit due to different versions"
 exit
fi

while :
do
  echo -e " \033[1;33mPrepare IPV4 address and gateway of access point\033[0;39m"
  echo -e " \033[1;31mAccess point -------------------------------------------------\033[0;39m"
  echo -e " \033[1;34m[e]: After ap settings\033[0;39m"
  echo -e " \033[1;31m[q]: Quit\033[0;39m"
  echo -e " \033[1;31m--------------------------------------------------------------\033[0;39m"
  read -p " Please select key [e or q]: " num
  case "${num}" in
    "e" ) _func_Dumb_GATEWAY ;;
    "q" ) exit ;;
  esac
done
