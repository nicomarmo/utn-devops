Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 3
  end

  config.vm.network "forwarded_port", guest: 8080, host: 8080 # Jenkins
  config.vm.network "forwarded_port", guest: 8140, host: 8140 # Puppet
  config.vm.network "forwarded_port", guest: 5000, host: 5000 # Para la app .NET

  config.vm.provision "shell", inline: <<-SHELL
    # Actualizar sistema
    sudo apt-get update -y
    sudo apt-get upgrade -y

    # Instalar dependencias básicas
    sudo apt-get install -y git curl wget unzip

    # Instalar .NET SDK
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install -y dotnet-sdk-6.0

    # Instalar Puppet
    wget https://apt.puppetlabs.com/puppet7-release-jammy.deb
    sudo dpkg -i puppet7-release-jammy.deb
    sudo apt-get update -y
    sudo apt-get install -y puppet-agent puppetserver

    # Configurar Puppet Server
    sudo sed -i 's/-Xms2g -Xmx2g/-Xms1g -Xmx1g/' /etc/default/puppetserver

    # Crear estructura de directorios de Puppet
    sudo mkdir -p /etc/puppetlabs/code/environments/production/{manifests,modules,data}

    # Copiar configuración de Puppet
    sudo rsync -av --exclude='.git/' /vagrant/puppet/ /etc/puppetlabs/code/environments/production/

    # Aplicar configuración de Puppet
    sudo /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp

    # Instalar Jenkins
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y jenkins

    # Iniciar servicios
    sudo systemctl enable --now jenkins
    sudo systemctl enable --now puppetserver
    sleep 30
    sudo systemctl enable --now puppet
  SHELL
end