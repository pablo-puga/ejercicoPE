#Instalamos apache mediante el módulo apache
class { 'apache': }

#Creamos el virtualhost centos.dev (root=/var/www)
apache::vhost { 'centos.dev':
  port    => '80',
  docroot => '/var/www',
  require => Package['httpd'],
}

#Creamos el virtualhost project1.dev (root=/var/www/project1)
apache::vhost { 'project1.dev':
  port    => '80',
  docroot => '/var/www/project1',
  require => Package['httpd'],
}

#Instalamos mysql con la contraseña 'vagrantpass' para el usuario root
case $operatingsystemrelease {
  /^6.*/: {
    class { "mysql":
      root_password => 'vagrantpass',
    }
  }
  /^7.*/: {
    #Si el SO es Centos 7, el paquete MySQL no viene en los repos por defecto, por lo que añadimos el repo de Mysql-community primero
    include ::yum::repo::mysql_community
    #Esta es la versión del repo de MySQL que se habilita por defecto al añadir el repo
    $enabled_version  = '56'
    class { "mysql":
      root_password => 'vagrantpass',
      require       => Yumrepo["mysql${enabled_version}-community"],
    }
  }
}

#Creamos la base de datos mpwar_test con la contraseña 'mpwardb' para el usuario 'vagrant'
mysql::grant { 'mpwar_test':
  mysql_user      => 'vagrant',
  mysql_password  => 'mpwardb',
  require         => Package['mysql']
}

#Instalamos PHP
class { 'php': }

#Habilitamos php en los virtualhost, si no project1.dev no parseaba php
class { '::apache::mod::php':
  content => "
AddHandler php5-script .php
AddType text/html .php\n",
  require => [Package['httpd'],Package['php']],
}

#Introducimos los host aliases
host { 'localhost':
       ensure => present,
       target => '/etc/hosts',
       ip => '127.0.0.1',
       host_aliases => ['mysql1','memcached1']
}

class { 'ejercicio3': }

include ::yum::repo::epel

package { 'memcached':
  ensure => installed,
  require => Yumrepo['epel'],
}