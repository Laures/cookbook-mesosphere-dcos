#
# Cookbook Name:: mesosphere_dcos
# Recipe:: agent
#
# Copyright 2016
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mesosphere_dcos::default'

bash 'install agent' do
  guard_interpreter :bash
  cwd '/tmp/dcos/'
  code 'dcos_install.sh slave'
end
