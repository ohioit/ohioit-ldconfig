# Private define ldconfig::conf_snippet
#
# Creates file content in /etc/ld.so.conf.d from a string or source
#
define ldconfig::conf_snippet (
  $ensure   = 'present',
  $content  = '',
  $source   = '',
  $filename = ''
) {

  $real_name = $filename ? {
    ''      => $name,
    default => $filename
  }

  case $ensure {

    present: {
      case $content {

        '': {
          # no content means we grab a file
          $real_source = $source ? {
            ''      => "puppet:///modules/ldconfig/${real_name}.conf",
            default => $source
          } # $real_source
          file { "${ldconfig::basedir}/${real_name}.conf":
            ensure  => present,
            source  => $real_source,
            require => Package['ldconfigPackage'],
            notify  => Exec['ldconfig-rebuild'],
          }
        }

        default: {
          # use a template to generate the content
          file { "${ldconfig::basedir}/${real_name}.conf":
            ensure  => present,
            content => $content,
            require => Package['ldconfigPackage'],
            notify  => Exec['ldconfig-rebuild'],
          }
        }
      }
    }

    absent: {
      file { "${ldconfig::basedir}/${real_name}.conf":
        ensure => absent,
        notify => Exec['ldconfig-rebuild'],
      }
    }
  }
}
