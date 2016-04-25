#
# Cookbook Name:: mesosphere_dcos
# Recipe:: public
#
# Copyright 2016
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mesosphere_dcos::default'

bash 'install master' do
  user 'root'
  guard_interpreter :bash
  cwd '/tmp/dcos/'
  code '/tmp/dcos/dcos_install.sh master'
  not_if { ::File.exists?('/etc/mesosphere') }
end
