# Public define ldconfig::snippet
#
# Creates file content in /etc/ld.so.conf.d from a string or source
#
define ldconfig::snippet (
  $ensure  = 'present',
  $content = '',
  $source  = ''
) {
  ldconfig::conf_snippet { "snippet-${name}":
    ensure   => $ensure,
    content  => $content,
    source   => $source,
    filename => $name,
    require  => Package['ldconfigPackage'],
  }
}
