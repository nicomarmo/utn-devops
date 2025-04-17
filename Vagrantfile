Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "devops-vm"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 3
    vb.name = "UTN-DevOps"
  end

  # Forward de puertos
  config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true # Jenkins
  config.vm.network "forwarded_port", guest: 8140, host: 8140, auto_correct: true # Puppet
  config.vm.network "forwarded_port", guest: 5000, host: 5000, auto_correct: true # App .NET

  config.vm.provision "shell", inline: <<-SHELL
    # Actualizar sistema y paquetes base
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Instalar dependencias básicas
    sudo apt-get install -y git wget unzip tree build-essential

    # Configuración de zona horaria (importante para Jenkins/Puppet)
    sudo timedatectl set-timezone America/Argentina/Buenos_Aires

    # --- INSTALACIÓN DE .NET SDK ---
    echo "Instalando .NET SDK 6.0..."
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install -y dotnet-sdk-6.0

    # Configurar variables de entorno para .NET
    echo 'export DOTNET_ROOT=/usr/share/dotnet' | sudo tee -a /etc/profile
    echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' | sudo tee -a /etc/profile
    source /etc/profile

    # Corregir estructura de directorios de .NET
    sudo mkdir -p /usr/share/dotnet/host/fxr
    SDK_VERSION=$(ls /usr/share/dotnet/sdk | grep -E '^6\\.' | sort -r | head -1)
    sudo ln -s /usr/share/dotnet/sdk/$SDK_VERSION/host/fxr /usr/share/dotnet/host/fxr/$SDK_VERSION

    # --- INSTALACIÓN DE PUPPET ---
    echo "Instalando Puppet..."
    wget https://apt.puppetlabs.com/puppet7-release-jammy.deb
    sudo dpkg -i puppet7-release-jammy.deb
    sudo apt-get update
    sudo apt-get install -y puppet-agent puppetserver

    # Configurar Puppet Server
    sudo sed -i 's/-Xms2g -Xmx2g/-Xms1g -Xmx1g/' /etc/default/puppetserver

    # Configurar PATH para Puppet
    echo 'export PATH=$PATH:/opt/puppetlabs/bin' | sudo tee -a /etc/profile
    source /etc/profile

    # Crear estructura de directorios de Puppet
    sudo mkdir -p /etc/puppetlabs/code/environments/production/{manifests,modules,data,hieradata}

    # Copiar configuración de Puppet desde /vagrant
    sudo rsync -av --exclude='.git/' /vagrant/puppet/ /etc/puppetlabs/code/environments/production/

    # Aplicar configuración inicial de Puppet
    sudo /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp

    # --- INSTALACIÓN DE JENKINS ---
    echo "Instalando Jenkins..."
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y jenkins

    # Configurar Jenkins para usar .NET
    echo 'export DOTNET_ROOT=/usr/share/dotnet' | sudo tee -a /var/lib/jenkins/.bashrc
    echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' | sudo tee -a /var/lib/jenkins/.bashrc

    # Iniciar y habilitar servicios
    echo "Iniciando servicios..."
    sudo systemctl enable --now jenkins
    sudo systemctl enable --now puppetserver
    sleep 10
    sudo systemctl enable --now puppet

    # Verificar instalaciones
    echo "Verificando instalaciones..."
    dotnet --list-sdks
    /opt/puppetlabs/bin/puppet --version
    java -version

    # Mostrar información de acceso
    echo "----------------------------------------"
    echo "INSTALACIÓN COMPLETADA"
    echo "Jenkins disponible en: http://localhost:8080"
    echo "Contraseña inicial Jenkins:"
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    echo "----------------------------------------"
  SHELL
end