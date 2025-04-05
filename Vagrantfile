Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 3
  end

  config.vm.network "forwarded_port", guest: 8080, host: 8080 # Jenkins
  config.vm.network "forwarded_port", guest: 8140, host: 8140 # Puppet

  config.vm.provision "shell", inline: <<-SHELL
    # Actualizar sistema
    sudo apt-get update -y
    sudo apt-get upgrade -y

    # Instalar Puppet
    wget https://apt.puppetlabs.com/puppet7-release-jammy.deb
    sudo dpkg -i puppet7-release-jammy.deb
    sudo apt-get update -y
    sudo apt-get install -y puppet-agent puppetserver

    # Gestionar usuario y grupo de Puppet
    if ! id "puppet" &>/dev/null; then
      sudo useradd -r -m -d /opt/puppet -s /bin/bash puppet
    fi

    if ! getent group puppet &>/dev/null; then
      sudo groupadd puppet
    fi

    sudo usermod -aG puppet puppet

    # Crear estructura completa de directorios
    sudo mkdir -p /etc/puppetlabs/code/environments/production/{manifests,modules,data}

    # Copiar todos los archivos de configuración
    sudo rsync -av --exclude='.git/' /vagrant/puppet/ /etc/puppetlabs/code/environments/production/

    # Instalar Java
    sudo apt-get install -y openjdk-17-jre

    # Instalar Jenkins
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y jenkins

    # Habilitar e iniciar Jenkins
    sudo systemctl enable jenkins
    sudo systemctl start jenkins

    # Habilitar y arrancar servicios Puppet
    sudo systemctl enable puppetserver
    sudo systemctl start puppetserver
    sleep 30
    sudo systemctl enable puppet
    sudo systemctl start puppet
    sudo /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
  SHELL
end