require 'puppet/provider/parsedfile'

hosts = nil
case Facter.value(:osfamily)
when "Solaris"; hosts = "/etc/inet/hosts"
when "windows"
  require 'win32/resolv'
  hosts = Win32::Resolv.get_hosts_path
else
  hosts = "/etc/hosts"
end


Puppet::Type.type(:host_entry).provide(:parsed,:parent => Puppet::Provider::ParsedFile,
  :default_target => hosts,:filetype => :flat) do
  confine :exists => hosts

  text_line :comment, :match => /^#/
  text_line :blank, :match => /^\s*$/
  hosts_pattern = '^(([0-9a-f:]\S+)\s+([^#\s+]\S+))\s*(.*?)?(?:\s*#\s*(.*))?$'
  record_line :parsed, :fields => %w{name ip hostname host_aliases comment},
    :optional => %w{host_aliases comment},
    :match    => /#{hosts_pattern}/,
    :post_parse => proc { |hash|
      # Fix name
      ip, hostname = hash[:name].split(/\s+/)
      name = "#{hostname} at #{ip}"
      hash[:name] = name
      # An absent comment should match "comment => ''"
      hash[:comment] = '' if hash[:comment].nil? or hash[:comment] == :absent
      unless hash[:host_aliases].nil? or hash[:host_aliases] == :absent
        hash[:host_aliases].gsub!(/\s+/,' ') # Change delimiter
      end
    },
    :to_line  => proc { |hash|
      hash[:hostname] = hash[:name] if hash[:hostname].nil?
      [:ip, :hostname].each do |n|
        raise ArgumentError, _("%{attr} is a required attribute for hosts") % { attr: n } unless hash[n] and hash[n] != :absent
      end
      str = "#{hash[:ip]}\t#{hash[:hostname]}"
      if hash.include? :host_aliases and !hash[:host_aliases].nil? and hash[:host_aliases] != :absent
        str += "\t#{hash[:host_aliases]}"
      end
      if hash.include? :comment and !hash[:comment].empty?
        str += "\t# #{hash[:comment]}"
      end
      str
    }

  text_line :incomplete, :match => /(?! (#{hosts_pattern}))/
end
