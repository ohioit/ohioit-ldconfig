# Class: ldconfig
# ===============
#
# Can add/remove resources to /etc/ld.so.conf.d and refreshes ldconfig. It does
# not purge existing resources unless ensure => absent is used.
#
# === Parameters
#
#   [*snippits*]             - Expects hash, defaults to undef, can be used
#                              instead of hiera if snippits_hiera_merge is
#                              set to false.
#
# === Hiera Hashes
#
#   [*ldconfig::snippits*] - A hash of ldconfig snippits passed to the
#                            ldconfig::snippit define via create_resources.
#
# Authors
# -------
#
# garrett honeycutt <garrett@puppetlabs.com> 20110405
# Robert Foreman <foremar1@ohio.edu> 20161107
#
class ldconfig {
  $basedir = '/etc/ld.so.conf.d'

  if versioncmp($::puppetversion, '4.0.0') < 0 {
    $snippets = hiera_hash('ldconfig::snippets', {})
  } else {
    $snippets = lookup('ldconfig::snippets', Hash, 'deep', {})
  }
  create_resources('ldconfig::snippet', $snippets)

  exec { 'ldconfig-rebuild':
    refreshonly => true,
    path        => '/sbin',
    command     => '/sbin/ldconfig',
  }

}
