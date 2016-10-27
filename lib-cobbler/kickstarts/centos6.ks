#version=DEVEL

install
text
url --url=http://172.18.230.250/cobbler/ks_mirror/CentOS-6.8-x86_64/
lang en_US.UTF-8
keyboard us

#$SNIPPET('network_config')

#network --onboot no --device eth0 --bootproto dhcp --noipv6
#network --onboot no --device eth1 --bootproto dhcp --noipv6
#network --onboot yes --device eth2 --bootproto dhcp --noipv6
rootpw  --iscrypted $default_password_crypted
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Asia/Shanghai
skipx

bootloader --location=mbr --append="ipv6.disable=1 intel_iommu=on"

# The following is the partition information you requested
# Note that any partitions you deleted are not expressed
# here so unless you clear all partitions first, this is
# not guaranteed to work
#clearpart --linux --drives=sda,sdb

zerombr
clearpart --all --initlabel

part /boot --fstype=ext4 --asprimary --size=200 --ondisk sda
part swap --asprimary --size=4096 --ondisk sda
part / --fstype=ext4 --asprimary --size=100000 --ondisk sda
part /tol --fstype=ext4 --grow --size=200 --ondisk sda

reboot

%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
$SNIPPET('pre_anamon')
%end


%packages
@base
@core
@development


%post

#init ssh
ssh_cf="/etc/ssh/sshd_config"
sed -i "s/#UseDNS yes/UseDNS no/" $ssh_cf

$SNIPPET('log_ks_post')
$SNIPPET('post_init_command')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')

%end
