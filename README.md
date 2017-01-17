# WordPress Vagrant

## Requirements
* Install VirtualBox 5.0.16
    * [OSX](http://download.virtualbox.org/virtualbox/5.0.16/VirtualBox-5.0.16-105871-OSX.dmg)
    * [Windows](http://download.virtualbox.org/virtualbox/5.0.16/VirtualBox-5.0.16-105871-Win.exe)
    * [Ubuntu 32 14.04](http://download.virtualbox.org/virtualbox/5.0.20/virtualbox-5.0_5.0.20-106931~Ubuntu~trusty_i386.deb)
    * [Ubuntu 64 14.04](http://download.virtualbox.org/virtualbox/5.0.20/virtualbox-5.0_5.0.20-106931~Ubuntu~trusty_amd64.deb)
* Install Vagrant 1.8.4
    * [OSX](https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4.dmg)
    * [Windows](https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4.msi)
    * [Ubuntu 32](https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_i686.deb)
    * [Ubuntu 64](https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_x86_64.deb)

## Getting Started
* Update the `project_title` variable in `./Vagrantfile`
* Run `vagrant up` from the repo root
    * Vagrant will take about 2 minutes to provision the first time if the OS doesn't need to be downloaded. If the OS does need downloaded then it can take about 6-8 minutes to download and provision the environment image.
* Once completed, run the output hosts edit script and record the provided logins