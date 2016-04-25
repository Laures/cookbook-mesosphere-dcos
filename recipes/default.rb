#
# Cookbook Name:: mesosphere_dcos
# Recipe:: default
#
# Copyright 2016
#
# All rights reserved - Do Not Redistribute
#

### Intall docker
# TODO this should be done using the docker cookbook if possible

#add docker repository
cookbook_file '/etc/yum.repos.d/docker.repo' do
  source 'docker.repo'
  action :create
end

# add docker to systemd
directory '/etc/systemd/system/docker.service.d' do
  recursive true
end

cookbook_file '/etc/systemd/system/docker.service.d/override.conf' do
  source 'systemd.overwride.conf'
  action :create
end

# install docker package and some things we will need later
package ['docker-engine', 'tar', 'xz', 'unzip', 'curl', 'ipset']

## start docker
service 'docker' do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

### disable selinux
# TODO this should be done using the selinux cookbook if possible
script 'extract_module' do
  interpreter "bash"
  code <<-EOH
    sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config &&
    sudo groupadd nogroup &&
    sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 &&
    sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
    EOH
end

### Install DCOS

# get install script
directory '/tmp/dcos' do
  recursive true
end

remote_file '/tmp/dcos/dcos_install.sh' do
  source "http://#{node['dcos']['bootstrap']['host']}:#{node['dcos']['bootstrap']['port']}/dcos_install.sh"
  action :create
  owner 'root'
  group 'root'
  mode  0755
end
