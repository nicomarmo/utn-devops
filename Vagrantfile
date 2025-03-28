Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"   
    vb.cpus = 2      
  end

  # Cambiado a 8080 para coincidir con docker-compose
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.synced_folder ".", "/vagrant"

  # Enviar archivos clave a la VM
  config.vm.provision "file", source: "./docker-compose.yml", destination: "/home/vagrant/docker-compose.yml"
  config.vm.provision "file", source: "./init.sql", destination: "/home/vagrant/init.sql"
  config.vm.provision "file", source: "./Dockerfile", destination: "/home/vagrant/Dockerfile"

  config.vm.provision "shell", inline: <<-SHELL
    # Actualizar sistema
    sudo apt-get update -y
    sudo apt-get upgrade -y

    # Limpiar instalaciones previas
    sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
    sudo apt-get remove -y --purge php libapache2-mod-php php-cli apache2

    # Instalar Docker
    curl -fsSL https://get.docker.com | sudo sh
    sudo usermod -aG docker vagrant
    sudo apt-get update && sudo apt-get install -y docker-compose-plugin

    # Iniciar servicios
    cd /home/vagrant
    docker compose up -d --build

    # Esperar con verificación activa
    echo "Esperando inicialización completa..."
    sleep 30  # Espera inicial para que los servicios se levanten
    SHELL

  config.ssh.insert_key = false
end