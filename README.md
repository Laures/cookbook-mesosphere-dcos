mesosphere_dcos Cookbook
========================

This cookbook installs the enterprise version of mesosphere.io DCOS.
Depending on the recipe the cookbook will either install an agent or a public_agent.

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
    "recipe[mesosphere_dcos::agent]",
    "recipe[mesosphere_dcos::public]"
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
