node default {
  # Verificar que Jenkins esté instalado y corriendo
  service { 'jenkins':
    ensure  => running,
    enable  => true,
  }

  # Instalar git (opcional, pero útil)
  package { 'git':
    ensure => installed,
  }
}
