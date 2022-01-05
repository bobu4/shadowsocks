#!/bin/bash
sudo systemctl stop tinyproxy
sudo apt remove tinyproxy -y
sudo systemctl disable tinyproxy
sudo rm /etc/systemd/system/tinyproxy.service
sudo apt install shadowsocks-libev
read -sp 'Password: ' passwd
printf "\n"
sudo tee <<EOF >/dev/null /etc/shadowsocks-libev/config.json
{
"server":["::0", "0.0.0.0"],
    "mode":"tcp_and_udp",
    "server_port":4433,
    "local_port":1080,
    "password":"$passwd",
    "timeout":60,
    "fast_open":true,
    "reuse_port": true,
    "no_delay": true,
    "method":"aes-256-gcm"
}
EOF
systemctl restart shadowsocks-libev.service
systemctl enable shadowsocks-libev.service
iptables -I INPUT -p tcp --dport 4433 -j ACCEPT
iptables -I INPUT -p udp --dport 4433 -j ACCEPT
echo "fs.file-max = 51200" >> /etc/sysctl.conf
echo "net.core.netdev_max_backlog = 250000" >> /etc/sysctl.conf
echo "net.core.somaxconn = 4096" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 0" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 1200" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 10000 65000" >> /etc/sysctl.conf
echo "net.core.netdev_max_backlog = 4096" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 8192" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_tw_buckets = 5000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_mtu_probing = 1" >> /etc/sysctl.conf
echo "net.core.rmem_max = 67108864" >> /etc/sysctl.conf
echo "net.core.wmem_max = 67108864" >> /etc/sysctl.conf
echo "net.ipv4.tcp_mem = 25600 51200 102400" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 87380 67108864" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 65536 67108864" >> /etc/sysctl.conf
echo "" >> /etc/sysctl.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sudo sysctl -p
