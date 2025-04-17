node default {
  # Instalar dependencias comunes
  package { ['git', 'curl', 'wget']:
    ensure => installed,
  }

  # Instalar .NET Runtime
  exec { 'install_dotnet':
    command => '/usr/bin/wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && /usr/bin/dpkg -i packages-microsoft-prod.deb && /usr/bin/apt-get update && /usr/bin/apt-get install -y dotnet-sdk-6.0',
    unless  => '/usr/bin/dotnet --version',
  }

  # Configurar Jenkins
  class { 'jenkins':
  }

  # Instalar plugins necesarios para .NET
  jenkins::plugin { ['git', 'pipeline', 'blueocean', 'dotnet-sdk']:
    notify => Service['jenkins'],
  }
}