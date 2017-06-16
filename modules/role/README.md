# role

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with role](#setup)
    * [Beginning with role](#beginning-with-role)
3. [Usage - Configuration options and additional functionality](#usage)

## Module Description
The role module assigns a particular role to node(s). A role is essentially a collection oof classes that are assigned depending on its role.

## Setup

### Beginning with role
Roles are divided into two sub modules `packer` and `startup`
* `packer`: A packer role will consist of classes that are required for an AMI bake. All configuration will be static, hence most values are picked up from `common.yaml` hiera file.
* `startup`: A startup role will consist of classes that executed at instance startup. All configuration values will be dynamic, i.e environment/account specific.

## Usage
Roles are included in nodes within the site manifest.

### Include a base role which is used during the packer AMI bake
```
include role::packer::base
```
### Include an orchestration role which is used during instance startup
```
include role::startup::orchestration
```
### Include an jenkins role which is used for vagrant development work
```
include role::vagrant::jenkins
```
