# Render Client

File rendering engine for clusters, groups, and nodes

## Overview

## Installation

### Preconditions

The following are required to run this application:

* OS:     Centos7
* Ruby:   2.6+
* Bundler

### Manual installation

Start by cloning the repo, adding the binaries to your path, and install the gems:

```
git clone https://github.com/openflighthpc/render-client
cd nodeattr-client
bundle install --without development test --path vendor
```

### Configuration

These application needs a couple of configuration parameters to specify which server to communicate with. Refer to the [reference config](etc/config.yaml.reference) for the required keys. The configs needs to be stored within `etc/config.yaml`.

```
cd /path/to/client
touch etc/config.yaml
vi etc/config.yaml
```

## Basic Usage

### Note About Cluster/Groups/Nodes

This application is designed to work with a preconfigured cluster. Refer to the [render server](https://github.com/openflighthpc/render-server#configuration) on how to setup the cluster. There is no capacity to configure the server from the client. The server may or may not
be configured with a `cluster`.

The following commands can be used to view the currently available nodes:

```
# View the available nodes:
bin/engine list-nodes

# View the available groups:
bin/engine list-groups
```

### Managing Templates

Whilst the `cluster`/`groups`/`nodes` can not be modified from the `client`, the `templates` can be. The following can be used to manage the saved `templates`.

```
# Create a blank template and the upload a file to it [2 Steps]
bin/engine template create test.sh
bin/engine template upload test.sh /path/to/file.sh

# The above is equivalent to [1 Step]
bin/engine template create test.sh /path/to/file.sh

# The view the template details
bin/engine template show test.sh

# The file can then be modified via the system editor
bin/engine template edit test.sh

# To permanently delete the template
bin/engine template delete test.sh

# List all the available templates
bin/engine list-templates
```

### Rendering Templates

All templates are rendered using the `download` command. The name of the `templates` are given as the first position argument as a comma separated list. Then it must be combined with at least one of the following flags: `--nodes`, `--nodes-in`, `--groups`, and `--cluster`. The purpose of the flag is to give the rendering context, nothing will happen without one.

By default the templates will be rendered in the current working directory, this can be overridden using the `--output`/`-o` flag. Missing templates and contexts are ignored by this command to allow the existing entries to be downloaded. Existing files will not be replaced without the `--force` flag.

```
# Render a template for a node
> bin/engine download test.sh --nodes node1 --output /tmp
Download: /tmp/nodes/node1/test.sh

# Render multiple templates
> bin/engine download test.sh,other.sh,missing.sh -o node1 /tmp
Skipping: /tmp/nodes/node1/test.sh
Download: /tmp/nodes/node1/other.sh

# Force replace a download
> bin/engine download test.sh,other.sh,missing.sh -n node1 -o /tmp --force
Forced:   /tmp/nodes/node1/test.sh
Forced:   /tmp/nodes/node1/other.sh

# Download for multiple named nodes
> bin/engine download test.sh -n node1,node2,missing -o /tmp/other
Download: /tmp/other/nodes/node1/test.sh
Download: /tmp/other/nodes/node2/test.sh
```

The following options are also available if the service has been integrated with `nodeattr-server`. Otherwise they will be ignored.

```
# Render a template for all the nodes with a group
> bin/engine download test.sh --nodes-in nodes -o /tmp/grouped
Download: /tmp/grouped/nodes/node1/test.sh
Download: /tmp/grouped/nodes/node2/test.sh

# Or using the short flag:
> bin/engine download test.sh -N nodes -o /tmp/grouped-other
Download: /tmp/grouped-other/nodes/node1/test.sh
Download: /tmp/grouped-other/nodes/node2/test.sh

# Render a template for a group
> bin/engine download test.sh --groups nodes -o /tmp/group
Download: /tmp/group/groups/nodes/test.sh

# Or using the short flag:
> bin/engine download test.sh -g nodes -o /tmp/group-other
Download: /tmp/group-other/groups/nodes/test.sh

# Render a template for the cluster
> bin/engine download test.sh --cluster -o /tmp/cluster
Download: /tmp/cluster/cluster/test.sh

# Or using the short flag:
> bin/engine download test.sh -c -o /tmp/cluster-other
Download: /tmp/cluster-other/cluster/test.sh
```

# Contributing

Fork the project. Make your feature addition or bug fix. Send a pull
request. Bonus points for topic branches.

Read [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

# Copyright and License
Eclipse Public License 2.0, see LICENSE.txt for details.

Copyright (C) 2019-present Alces Flight Ltd.

This program and the accompanying materials are made available under the terms of the Eclipse Public License 2.0 which is available at https://www.eclipse.org/legal/epl-2.0, or alternative license terms made available by Alces Flight Ltd - please direct inquiries about licensing to licensing@alces-flight.com.

RenderClient is distributed in the hope that it will be useful, but WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more details.

