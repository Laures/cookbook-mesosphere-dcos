#
# Cookbook Name:: mesosphere_dcos
# Recipe:: default
#
# Copyright 2016
#
# All rights reserved - Do Not Redistribute
#

### start docker service
docker_service 'default' do
  host [ "tcp://#{node['ipaddress']}:2376", 'unix:///var/run/docker.sock' ]
  daemon true
  host 'fd://'
  storage_driver 'overlay'
  misc_opts node['dcos']['docker']['args']
  install_method 'package'
  version '1.11.2'
  action [:create,:start]
end

# install some things we will need later
package ['tar', 'xz', 'unzip', 'curl', 'ipset']

### disable selinux
# TODO this should be done using the selinux cookbook if possible
script 'selinux_permissive' do
  interpreter "bash"
  code <<-EOH
    sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config
    EOH
end

group 'nogroup' do
  action :create
end

script 'disable_ipv6' do
  interpreter "bash"
  code <<-EOH
    sysctl -w net.ipv6.conf.all.disable_ipv6=1 &&
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
    EOH
end
