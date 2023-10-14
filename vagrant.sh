#!/usr/bin/bash

vagrant init ubuntu/focal64

cat <<EOF > vagrantfile
Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.box = "ubuntu/focal64"
    master.vm.network "private_network", type: "static", ip: "192.168.39.10"
    master.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt install sshpass -y
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
    sudo apt-get install -y avahi-daemon libnss-mdns
    SHELL
  end
   config.vm.define "slave" do |slave|
     slave.vm.hostname = "slave"
     slave.vm.box = "ubuntu/focal64"
     slave.vm.network "private_network", type: "static", ip: "192.168.39.11"
     slave.vm.provision "shell", inline: <<-SHELL
     sudo apt-get update && sudo apt-get upgrade -y
     sudo apt install sshpass -y
     sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
     sudo systemctl restart sshd
     sudo apt-get install -y avahi-daemon libnss-mdns
     SHELL
   end
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "2"
    end
end
EOF
vagrant up
source configurationmaster.sh
source configurationslave.sh
