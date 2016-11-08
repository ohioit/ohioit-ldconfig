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
#   [*snippits_hiera_merge*] - Boolean, defaults to true, enables hiera hash
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
class ldconfig (
  $snippits = undef,
  $snippits_hiera_merge = true,
) {
  $basedir = '/etc/ld.so.conf.d'

  if is_string($snippits_hiera_merge) {
    $snippits_hiera_merge_real = str2bool($snippits_hiera_merge)
  } else {
    $snippits_hiera_merge_real = $snippits_hiera_merge
  }
  validate_bool($snippits_hiera_merge_real)

  if $snippits != undef {
    if $snippits_hiera_merge_real == true {
      $snippits_real = hiera_hash('ldconfig::snippits', {})
    } else {
      $snippits_real = $snippits
    }
    validate_hash($snippits_real)
    create_resources('ldconfig::snippit',$snippits_real)
  }

  exec { 'ldconfig-rebuild':
    refreshonly => true,
    path        => '/sbin',
    command     => '/sbin/ldconfig',
  }
}
