[Adding Puppet modules]: #adding-puppet-modules
[Module description]: #module-description
[Puppetfile]: Puppetfile
[Ruby]: https://www.ruby-lang.org/en/downloads/
[Vagrant]: https://www.vagrantup.com/downloads.html
[Vagrantfile]: Vagrantfile.example
[Vagrant setup]: #vagrant-setup
[Virtualbox]: https://www.virtualbox.org/wiki/Downloads

[credentials]: .aws.example/credentials
[vagrant_nodes.yaml]: vagrant_nodes.yaml.example

[<img src="https://avatars2.githubusercontent.com/u/11023632?v=3&s=50">](http://versent.com.au/)
puppet-control
==============

#### Table of Contents

1. [Module Description - What the module does and why it is useful][Module description]
2. [Adding Puppet modules][Adding Puppet modules]
3. [Vagrant setup][Vagrant setup]

## Module Description

The 'puppet-control' module acts as central place holder which manages the whole Puppet setup (i.e);

* Data
* Code
* Private/Public Modules

## Adding Puppet modules

Declare what Puppet modules are required.

```bash
mod 'profile',
  :local => true
mod 'role',
  :local => true
...
..
# Add more modules if required
```

## Vagrant setup

1. Download and install [Vagrant][]

2. Download and install [Virtualbox][]

3. Ensure that you have newer version of [Ruby][](ideally greater than or equal to version 2.x) and RubyGems installed on your OS.

4. Ensure GIT client is installed

5. Clone Puppet control repo

    ```bash
    git clone '<repo_url>' puppet
    cd puppet
    ```

6. Install bundler gem.

    ```bash
    gem install bundler --no-ri --no-rdoc
    bundle install
    ```

7. Make a copies of Vagrant specific config files which will be used for your own Vagrant development.

    ```bash
    find . -name "*.example" -not -path "./modules" | while read i; do cp -a ${i} ${i%.example}; done
    ```

8. Pull down Puppet modules as listed in [Puppetfile][] via r10k

    ```bash
    r10k puppetfile install -v
    ```

9. Add your AWS credentials to .aws/[credentials][] (**optional**: used when downloading artefacts via S3).

10. Boot up vagrant box

    ```bash
    vagrant up <box_name>
    ```
    
### Vagrant configuration options

#### Proxy settings

To enable proxy, edit the following configuration to `true` in [Vagrantfile][].

```bash
proxy = {
  enabled: true,
  host: 'proxy.example.com',
  port: '8080'
}
```

#### AWS API credentials

To upload your AWS credentials to the Vagrant machine, edit the following configuration to `true` in [Vagrantfile][].

```bash
aws_credentials = {
  upload: true,
  source: './.aws'
}
```

> By default, the AWS credentials directory will be only uploaded to the `vagrant` and `root` users' home directories. If you want other users(i.e jenkins) to perform
aws cli commands, add the following to [vagrant_nodes.yaml][].

```bash
-
  :hostname: jenkins
  ....
  ...
  # Add users to the following key name
  :awscli_users:
    - jenkins
```
