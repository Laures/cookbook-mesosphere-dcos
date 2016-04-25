default['dcos']['installer']['url']='https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh'

default['dcos']['bootstrap']['port'] = 8080

default['dcos']['cluster']['ipdetect'] = 'eth0'
default['dcos']['cluster']['name'] = 'Data Center Operation System'

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  default['dcos']['cluster']['masters'] = search(:node, 'tags:dcos_master')
end
