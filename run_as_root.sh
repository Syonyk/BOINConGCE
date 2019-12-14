#!/bin/bash

project_url=https://climateprediction.net
weak_account_key=744912_8bd218b7d007664a752bd3876c46a2ea

sudo apt update
sudo apt dist-upgrade -y
swapsize=$(expr `free -g | grep Mem | tr -s " " | cut -d' ' -f 2` + 1)
fallocate -l ${swapsize}g /swapfile
chmod 0600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
apt -y install uswsusp
sed -i "s/ttyS0/ttyS0 resume=\/dev\/sda1/" /etc/default/grub.d/50-cloudimg-settings.cfg
update-grub
mkdir -p /etc/systemd/system/systemd-hibernate.service.d
cat >/etc/systemd/system/systemd-hibernate.service.d/override.conf <<END
[Service]
ExecStart=
ExecStart=/usr/sbin/s2disk
ExecStartPost=/bin/run-parts -a post /lib/systemd/system-shutdown
END
sed -i "s/#HandlePowerKey=poweroff/HandlePowerKey=hibernate/" /etc/systemd/logind.conf
service systemd-logind restart

apt install -y lib32gcc1 lib32ncurses5 lib32stdc++6 lib32z1 lib32stdc++-6-dev
apt install -y boinc-client boinctui
boinccmd --project_attach $project_url $weak_account_key
