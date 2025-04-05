class jenkins {
  exec { 'add_jenkins_key':
    command => '/usr/bin/curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -',
    unless  => '/usr/bin/apt-key list | grep -q "Jenkins"',
    before  => Apt::Source['jenkins'],
  }

  apt::source { 'jenkins':
    location => 'https://pkg.jenkins.io/debian-stable',
    release  => 'binary/',
    key      => {
      id     => '9B7D32F2D50582E6',
      source => 'https://pkg.jenkins.io/debian-stable/jenkins.io.key',
    },
  }

  package { 'jenkins':
    ensure  => installed,
    require => Apt::Source['jenkins'],
  }

  service { 'jenkins':
    ensure  => running,
    enable  => true,
    require => Package['jenkins'],
  }
}
