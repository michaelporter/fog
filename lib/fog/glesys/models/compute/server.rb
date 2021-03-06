require 'fog/compute/models/server'

module Fog
  module Compute
    class Glesys

      class Server < Fog::Compute::Server
        extend Fog::Deprecation

        identity :serverid

        attribute :hostname
        attribute :datacenter
        attribute :cpucores
        attribute :memorysize
        attribute :disksize
        attribute :transfer
        attribute :templatename
        attribute :managedhosting
        attribute :platform
        attribute :cost
        attribute :rootpassword
        attribute :keepip
        attribute :state
        attribute :iplist
        attribute :ipversion
        attribute :ip
        attribute :description

        def ready?
          state == 'running'
        end

        def start
          requires :identity
          service.start(:serverid => identity)
        end

        def stop
          requires :identity
          service.stop(:serverid => identity)
        end

        def reboot
          requires :identity
          service.reboot(:serverid => identity)
        end

        def destroy
          requires :identity
          service.destroy(:serverid => identity, :keepip => keepip)
        end

        def save
          raise "Operation not supported" if self.identity
          requires :hostname, :rootpassword

          options = {
            :datacenter     => datacenter   || "Falkenberg",
            :platform       => platform     || "Xen",
            :hostname       => hostname,
            :templatename   => templatename || "Debian-6 x64",
            :disksize       => disksize     || "10",
            :memorysize     => memorysize   || "512",
            :cpucores       => cpucores     || "1",
            :rootpassword   => rootpassword,
            :transfer       => transfer     || "500",
          }
          data = service.create(options)
          merge_attributes(data.body['response']['server'])
          data.status == 200 ? true : false
        end

      end
    end
  end
end
