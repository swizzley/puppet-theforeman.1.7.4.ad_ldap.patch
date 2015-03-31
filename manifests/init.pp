# this module is to make AD LDAP work with ver. 1.7.4 upgrades from > ver 1.6
# basically it just decodes the CA and links the hash to /etc/pki/cert.pem
# foreman 1.6 -> 1.7.4 users using missing ldap certificate authority certificate

class theforeman_174_ad_ldap_patch {
  # [param]: $your_ca = your exported CA certificate using BASE-64 format for your ldap provider in swizzley88-theforemanpr132patch 
  $your_ca = ['some_org.cer']
  $cert_source = "puppet:///theforemanpr132patch/${your_ca}"
  $patch = "ln -s $(openssl x509 -noout -hash -in /etc/pki/tls/certs/${your_ca}).0 /etc/pki/tls/certs/certs.pem"

  file { "/pki/tls/certs/${your_ca}":
    ensure  => 'present',
    content => $cert_source,
    owner   => 'root',
    mode    => '0644',
  } ->
  exec { "patch_theforeman_1.7.4_ad_ldap_provider":
    shell   => 'bash',
    path    => '/bin:/usr/bin:/pki/tls:/etc/pki/tls/certs',
    command => "unlink /etc/pki/tls/certs/certs.pem && ${patch}",
    unless  => "test -L /etc/pki/tls/certs/${your_ca}",
  } ->
  file { ["/etc/pki/tls/certs/${your_ca}.0", "/etc/pki/tls/cert.pem"]:
    ensure => 'present',
    target => 'link',
  }

}