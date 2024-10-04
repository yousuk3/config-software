#!/bin/sh

cat <<"EOF" >> /usr/bin/confsoft
#!/bin/sh
mkdir -p /etc/config-software
wget --no-check-certificate -O /etc/config-software/openwrt-config.sh https://raw.githubusercontent.com/yousuk3/config-software/custom1/openwrt-config.sh
sh /etc/config-software/openwrt-config.sh
EOF
chmod +x /usr/bin/confsoft

UPDATE="/tmp/opkg-lists/openwrt_telephony"
if [ ! -e ${UPDATE} ]; then
opkg update
fi
opkg install ttyd
