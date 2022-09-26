# @summary Manage `/etc/hosts`
#
# @example
#   include hosts
#
# @param hosts
#   Hash of host resource entries
#
class hosts (
  Hash $hosts = {},
) {

  $hosts.each |$name, $host| {
    host { $name:
      * => $host,
    }
  }
}
