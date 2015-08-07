# this module is to make AD LDAP work with ver. 1.8.2 
# basically it just decodes the CA and links the hash to /etc/pki/cert.pem

class theforeman_182_ad_ldap_patch {
  # [param]: $your_ca = your exported CA certificate using BASE-64 format for your ldap provider in swizzley88-theforemanpr132patch 
  $your_ca = 'RootCA.cer'
  $cert_source = "puppet:///modules/theforeman_183_ad_ldap_patch/${your_ca}"
  $patch = "ln -s /etc/pki/tls/certs/${your_ca} /etc/pki/tls/certs/$(openssl x509 -noout -hash -in /etc/pki/tls/certs/${your_ca}).0 "

  file { "/pki/tls/certs/${your_ca}":
    ensure  => 'present',
    content => $cert_source,
    owner   => 'root',
    mode    => '0644',
    require => Package['foreman-installer'],
  } ->
  exec { "patch_comcast_ca_cert":
    provider => 'shell',
    path     => '/bin:/usr/bin:/pki/tls:/etc/pki/tls/certs',
    command  => "unlink /etc/pki/tls/certs/ca-bundle.crt && ${patch}",
    unless   => "test -L /etc/pki/tls/certs/$(openssl x509 -noout -hash -in /etc/pki/tls/certs/${your_ca}).0",
  } ->
  exec { "relink_ca_cert":
    provider => 'shell',
    path     => '/bin:/usr/bin:/pki/tls:/etc/pki/tls/certs',
    command  => "ln -s /etc/pki/tls/certs/$(openssl x509 -noout -hash -in /etc/pki/tls/certs/${your_ca}).0 /etc/pki/tls/certs/ca-bundle.crt",
    unless   => 'test -L /etc/pki/tls/certs/ca-bundle.crt',
  }
  package { 'foreman-installer': ensure => installed, }

  service { ['foreman-proxy', 'postgresql', 'httpd',]:
    ensure  => running,
    enable  => true,
    require => Package['foreman-installer']
  }
}
