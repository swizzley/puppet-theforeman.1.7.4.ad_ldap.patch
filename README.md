#theforeman_174_ad_ldap_patch

####Table of Contents

1. [Overview - What is the theforeman_174_ad_ldap_patch module?](#overview)
2. [Requirements - your certificate](#requirements)

# WARNING
Deprecated. There is a new branch to this repo for version 1.8. which does work, but the 1.7.4 module is now removed from the forge, but can still be found here: https://forge.puppetlabs.com/swizzley88/theforeman_174_ad_ldap_patch

##Overview
Puppet-module patch for theforeman 1.7.4 LDAP Authority SSL certificate trust error from a missing or untrusted LDAP certificate authority exported from 
Active Directory Certificate Services exported as Base-64 format from Enterprise PKI in the certificate export wizard.
See. theformanorg PR#362 https://github.com/theforeman/theforeman.org/pull/362


##Requirements

  1. Microsoft Server 2008 R2 trusted certificate authority provider certificate 
