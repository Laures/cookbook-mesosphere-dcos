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

# create overwite service config; triger daemon-reload and restart on change
template '/etc/systemd/system/docker.service.d/override.conf' do
  source 'systemd.overwride.conf.erb'
  action :create
  variables({
    :args => node['dcos']['docker']['args']
  })
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
  notifies :restart, 'service[docker]'
end

execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  action :nothing
end

# install docker package and some things we will need later
package 'docker-engine = 1.11.2-1.el7.centos'
package ['tar', 'xz', 'unzip', 'curl', 'ipset']

## start docker
service 'docker' do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true
  action [:start, :enable]
end

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
