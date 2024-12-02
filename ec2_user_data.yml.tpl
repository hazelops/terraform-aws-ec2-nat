#cloud-config
hostname: ${hostname}
packages:
  - iptables-services
write_files:
  - path: /etc/sysctl.conf
    content: |
      net.ipv4.ip_forward = 1
runcmd:
  - sysctl -p /etc/sysctl.conf
  - iptables -t nat -A POSTROUTING -o ens5 -s 0.0.0.0/0 -j MASQUERADE
  - sysctl enable iptables
  - sysctl start iptables
