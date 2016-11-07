# Class: ldconfig
# ===========================
#
# Authors
# -------
#
# garrett honeycutt <garrett@puppetlabs.com> 20110405
# Robert Foreman <foremar1@ohio.edu> 20161107
#
class ldconfig {
  $basedir = '/etc/ld.so.conf.d'

  package { 'glibc':
    ensure => installed,
    alias  => 'ldconfigPackage',
  }

  exec { 'ldconfig-rebuild':
    refreshonly => true,
    path        => '/sbin',
    command     => '/sbin/ldconfig',
  }
}
