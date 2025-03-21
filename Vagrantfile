Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  # memoria y CPU
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"   
    vb.cpus = 2      
  end

  # reenvio de puertos
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # mapear carpeta
  config.vm.synced_folder ".", "/vagrant"

  #script de aprovisionamiento
  config.vm.provision "shell", inline: <<-SHELL

    # actualizar repositorios e instalar dependencias
    sudo apt-get update
    sudo apt-get upgrade -y

    # instalar Apache
    sudo apt-get install -y apache2
    sudo systemctl enable apache2
    sudo systemctl start apache2

    # instalar PHP y las extensiones necesarias
    sudo apt-get install -y php libapache2-mod-php php-cli

    # instalar Git
    sudo apt-get install -y git

    # clonar el repositorio en /var/www/html
    cd /var/www/html
    sudo rm -rf utn-devops-app #se elimina x si ya existe
    sudo git clone -b unidad-1 https://github.com/Fichen/utn-devops-app.git utn-devops-app

    #eliminar archivo
    cd /var/www/html/utn-devops-app
    sudo rm -f template_download.txt

    # cambiar el DocumentRoot de Apache
    sudo sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/utn-devops-app/public|' /etc/apache2/sites-available/000-default.conf

    # cambiar permisos para Apache
    sudo chown -R www-data:www-data /var/www/html/utn-devops-app/public
    sudo chmod -R 755 /var/www/html/utn-devops-app/public

    # reiniciar Apache para aplicar cambios
    sudo systemctl restart apache2
  SHELL
  
  #copiar archivo en VM
  config.vm.provision "file", source: "C:/Users/Nico/Desktop/UTN-DevOps/Vagrantfile", destination: "/home/vagrant/vagrant-config-ex/Vagrantfile"

  # acceso SSH
  config.ssh.insert_key = false
end