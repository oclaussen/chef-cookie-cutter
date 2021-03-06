# frozen_string_literal: true

class Chef
  module CookieCutter
    module OhaiHelpers
      module NodeDSL
        %w[
          aix
          amazon
          arch
          centos
          debian
          fedora
          freebsd
          gentoo
          ios_xr
          linuxmint
          mac_os_x
          nexus
          omnios
          openbsd
          oracle
          raspbian
          redhat
          rhel
          scientific
          slackware
          smartos
          solaris2
          suse
          ubuntu
          windows
          wrlinux
        ].each do |name|
          define_method "#{name}?".to_sym do
            [
              node['platform_family'] == name,
              node['platform'] == name
            ].any?
          end
        end

        %w[
          azure
          cloud
          cloudstack
          digital_ocean
          ec2
          eucalyptus
          gce
          linode
          openstack
          rackspace
          vagrant
        ].each do |name|
          define_method "#{name}?".to_sym do
            node.key?(name)
          end
        end

        %w[
          kvm
          lxc
          openvz
          vbox
          vmware
        ].each do |name|
          define_method "#{name}?".to_sym do
            return false unless node.key?('virtualization')
            node['virtualization']['system'] == name
          end
        end

        def docker?
          ::File.exist?('/.dockerinit') || ::File.exist?('/.dockerenv')
        end

        def user_home(user = nil)
          user = node['current_user'] if user.nil?
          node['etc']['passwd'][user]['dir']
        rescue NoMethodError
          '/'
        end

        def user_group(user = nil)
          user = node['current_user'] if user.nil?
          gid = node['etc']['passwd'][user]['gid']
          matching_groups = node['etc']['group']
          matching_groups = matching_groups.select { |_, grp| grp['gid'] == gid }
          matching_groups.keys[0]
        rescue NoMethodError
          'root'
        end
      end
    end
  end
end
