node default {

  service { 'jenkins':
    ensure  => running,
    enable  => true,
  }

  # Instalar git
  package { 'git':
    ensure => installed,
  }
}
