#
# Cookbook Name:: mesosphere_dcos
# Recipe:: public
#
# Copyright 2016
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mesosphere_dcos::default'

directory '/opt/dcos/genconf' do
  recursive true
end

# download dcos install script
remote_file '/opt/dcos/dcos_generate_config.sh' do
  source node['dcos']['installer']['url']
  action :create
  owner 'root'
  group 'root'
  mode  0755
  not_if { ::File.exists?('/opt/dcos/dcos_generate_config.sh') }
end

if node['dcos']['superuser']['password'] != nil
  bash 'generate enterprise build files' do
    user 'root'
    timeout 9000
    cwd '/opt/dcos/'
    code "/opt/dcos/dcos_generate_config.sh --hash-password #{node['dcos']['superuser']['password']} | tail -n 1 > /opt/dcos/password_hash"
  end

  # load password hash
#  password_hash = File.read('/opt/dcos/password_hash')
#  Chef::Log.Info('Using password_hash=' + password_hash)
else
  bash 'generate build files' do
    user 'root'
    timeout 9000
    cwd '/opt/dcos/'
    code "/opt/dcos/dcos_generate_config.sh"
  end
end

# create config
template '/opt/dcos/genconf/config.yaml' do
  source 'config.yaml.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables lazy { ({
    :masters => search(:node, node['dcos']['cluster']['masters']),
    :clusterName => node['dcos']['cluster']['name'],
    :bootstrapHost => node['dcos']['bootstrap']['host'],
    :bootstrapPort => node['dcos']['bootstrap']['port'],
    :customerKey => node['dcos']['customerKey'],
    :superuser_password_hash => File.open('/opt/dcos/password_hash').read,
    :superuser_username => node['dcos']['superuser']['name']
  }) }
end

# create ip-detect script
cookbook_file '/opt/dcos/genconf/ip-detect' do
  source "ipdetect.#{node['dcos']['cluster']['ipdetect']}"
  action :create
end

# start docker container
script 'start docker container' do
  interpreter "bash"
  cwd '/opt/dcos/'
  code "docker run -d -p #{node['dcos']['bootstrap']['port']}:80 -v $PWD/genconf/serve:/usr/share/nginx/html:ro nginx"
end
