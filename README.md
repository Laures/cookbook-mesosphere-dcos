mesosphere_dcos Cookbook
========================

This cookbook installs the enterprise version of mesosphere.io DCOS.
Depending on the recipe the cookbook will either install an bootstrap node, master, agent or public_agent.

Requirements
------------

#### packages

none

Attributes
----------

#### mesosphere_dcos::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['dcos']['installer']['url']</tt></td>
    <td>String</td>
    <td>Url of the dcos_generate_config.sh</td>
    <td><tt>'https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh'</tt></td>
  </tr>
  <tr>
    <td><tt>['dcos']['cluster']['ipdetect']</tt></td>
    <td>String</td>
    <td>Type of IP-detection used during installation. Valid values are: 'aws' for Amazon EC2 instances, 'gce' for Google Container Engine instances and 'eth0' to use the eth0 Interface ip.</td>
    <td><tt>'eth0'</tt></td>
  </tr>
  <tr>
    <td><tt>['dcos']['cluster']['name']</tt></td>
    <td>String</td>
    <td>Name of the Cluster. Used in the generated config</td>
    <td><tt>'Data Center Operation System'</tt></td>
  </tr>
  <tr>
    <td><tt>['dcos']['cluster']['masters']</tt></td>
    <td>Array of IPs</td>
    <td>All nodes intended as Masters (default: all nodes tagged with dcos_master)</td>
    <td><tt>search(:node, 'tags:dcos_master')</tt></td>
  </tr>
  <tr>
    <td><tt>['dcos']['bootstrap']['host']</tt></td>
    <td>String</td>
    <td>host of the bootstrap node to get dcos from</td>
    <td><tt>null</tt></td>
  </tr>
  <tr>
    <td><tt>['dcos']['bootstrap']['port']</tt></td>
    <td>int</td>
    <td>port of the http server on the bootstrap node</td>
    <td><tt>80</tt></td>
  </tr>
</table>

Usage
-----

Just include `mesosphere_dcos` in your node's `run_list` whith the correct recipe do identify the dcos node type:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[mesosphere_dcos::bootstrap]",
    "recipe[mesosphere_dcos::agent]",
    "recipe[mesosphere_dcos::public]",
    "recipe[mesosphere_dcos::master]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
MIT License
