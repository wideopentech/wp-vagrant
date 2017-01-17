# -*- mode: ruby -*-
# vi: set ft=ruby :

# put your project title in here, ruby will handle the rest!
project_title = "Wide Open Technologies"


# Environment Settings vars
project_title = project_title.downcase.tr(" ","_")
semantic_name = project_title.tr("_","")
domain = "#{semantic_name}.dev"
api_version = 2
ip = "192.168.33.22"
mysql_root_password = "root"
database_name = semantic_name
database_user_name = semantic_name[0, 16]
database_user_password = semantic_name

# Virtualbox Settings vars
box_name = "WOTVAGRANT-#{project_title}"
box_memory = "2048"


Vagrant.configure(api_version) do |config|

    # Base box settings
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_url = "https://atlas.hashicorp.com/ubuntu/boxes/trusty64"


    # Box Networking
    # config.vm.hostname = domain
    config.vm.network :private_network, ip: ip


    # Synced Files and Permissions
    config.vm.synced_folder "./", "/var/www", id: "vagrant-root", :nfs => false, owner: "www-data", group: "www-data"


    # Provision BASH script
    config.vm.provision "shell" do |s|
        s.path = "provision.sh"
        s.args = [mysql_root_password, ip, domain, database_name, database_user_name, database_user_password]
    end


    # Virtualbox settings
    config.vm.provider "virtualbox" do |vb|
        vb.name = box_name
        vb.gui = false
        vb.memory = box_memory
    end

end