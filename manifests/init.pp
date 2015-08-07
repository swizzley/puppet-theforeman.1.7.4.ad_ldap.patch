# this module is to make AD LDAP work with ver. 1.8.2 
# basically it just decodes the CA and links the hash to /etc/pki/cert.pem

class theforeman_182_ad_ldap_patch {
  # [param]: $your_ca = your exported CA certificate using BASE-64 format for your ldap provider in swizzley88-theforemanpr132patch 
  $your_ca = ['some_org.cer']
  $cert_source = "puppet:///theforemanpr132patch/${your_ca}"
  $patch = "ln -s /etc/pki/tls/certs/${your_ca} $(openssl x509 -noout -hash -in /etc/pki/tls/certs/${your_ca}).0 "

  file { "/pki/tls/certs/${your_ca}":
    ensure  => 'present',
    content => $cert_source,
    owner   => 'root',
    mode    => '0644',
  } ->
  exec { "patch_theforeman_1.8.2_ad_ldap_provider":
    shell   => 'bash',
    path    => '/bin:/usr/bin:/pki/tls:/etc/pki/tls/certs',
    command => "unlink /etc/pki/tls/certs/ca-bundle.crt && ${patch}",
    unless  => "test -L /etc/pki/tls/certs/${your_ca}.0",
  } ->
  file { '/etc/pki/tls/certs/ca-bundle.crt':
    ensure => 'link',
    target => "/etc/pki/tls/certs/${your_ca}.0",
  }

}
