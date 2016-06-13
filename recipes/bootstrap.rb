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

# create config
template '/opt/dcos/genconf/config.yaml' do
  source 'config.yaml.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables({
    :masters => search(:node, node['dcos']['cluster']['masters']),
    :clusterName => node['dcos']['cluster']['name'],
    :bootstrapHost => node['dcos']['bootstrap']['host'],
    :bootstrapPort => node['dcos']['bootstrap']['port']
  })
end

# create ip-detect script
cookbook_file '/opt/dcos/genconf/ip-detect' do
  source "ipdetect.#{node['dcos']['cluster']['ipdetect']}"
  action :create
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

# execute dcos install script
bash 'generate build files' do
  user 'root'
  timeout 9000
  cwd '/opt/dcos/'
  code '/opt/dcos/dcos_generate_config.sh'
end

# start docker container
script 'start docker container' do
  interpreter "bash"
  cwd '/opt/dcos/'
  code "docker run -d -p #{node['dcos']['bootstrap']['port']}:80 -v $PWD/genconf/serve:/usr/share/nginx/html:ro nginx"
end
