#version=DEVEL

install
text
url --url=http://172.18.230.250/cobbler/ks_mirror/CentOS-5.11-x86_64/
lang en_US.UTF-8
keyboard us
network --onboot no --device eth0 --bootproto dhcp --noipv6
network --onboot no --device eth1 --bootproto dhcp --noipv6
rootpw  --iscrypted $6$0BmIf94pSAa03FNN$RmM1MfAyVGxdovDDEFWdEOvUW7yOdyiWsDUecsQkdBfoZ..vhtPYBUY3aBFqG9vnTHIxOtjSbZDav49/tgsSy/
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Asia/Shanghai
skipx

bootloader --location=mbr --driveorder=sda,sdb --append="crashkernel=auto rhgb quiet"
zerombr

# The following is the partition information you requested
# Note that any partitions you deleted are not expressed
# here so unless you clear all partitions first, this is
# not guaranteed to work
#clearpart --linux --drives=sda,sdb
clearpart --all --initlabel

part /boot --fstype=ext4 --asprimary --size=200
part swap --asprimary --size=4096
part / --fstype=ext4 --asprimary --size=100000
part /tol --fstype=ext4 --grow --size=200



%packages --nobase
@core
%end
