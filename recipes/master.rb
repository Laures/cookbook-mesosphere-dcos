#
# Cookbook Name:: mesosphere_dcos
# Recipe:: public
#
# Copyright 2016
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mesosphere_dcos::default'

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

bash 'install master' do
  user 'root'
  timeout 9000
  cwd '/tmp/dcos/'
  code '/tmp/dcos/dcos_install.sh master'
  not_if { ::File.exists?('/etc/mesosphere') }
end
