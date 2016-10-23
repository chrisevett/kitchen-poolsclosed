# idk why this is needed, there is a file in test kitchen that does this
# for some reason my project isnt being aggreeable without it
require 'pathname'
require 'thread'

require 'kitchen/errors'
require 'kitchen/logger'
require 'kitchen/logging'
require 'kitchen/shell_out'
require 'kitchen/configurable'
require 'kitchen/util'

require 'kitchen/provisioner'
require 'kitchen/provisioner/base'
require 'kitchen/color'
require 'kitchen/collection'
require 'kitchen/config'
require 'kitchen/data_munger'
require 'kitchen/driver'
require 'kitchen/driver/base'
require 'kitchen/driver/ssh_base'
require 'kitchen/driver/proxy'
require 'kitchen/instance'
require 'kitchen/transport'
require 'kitchen/transport/base'
require 'kitchen/loader/yaml'
require 'kitchen/metadata_chopper'
require 'kitchen/platform'
require 'kitchen/state_file'
require 'kitchen/ssh'
require 'kitchen/suite'
require 'kitchen/verifier'
require 'kitchen/verifier/base'
require 'kitchen/version'
require 'rubygems'
require 'kitchen'

require 'rest-client'
require 'pry-byebug'
require 'kitchen/driver/poolsclosed_version'

module Kitchen
  module Driver
    class PoolsClosed < Kitchen::Driver::Base
      kitchen_driver_api_version 2
      plugin_version Kitchen::Driver::POOLSCLOSED_VERSION

      required_config :poolsclosed_baseurl
      no_parallel_for :create, :destroy

      def verify_dependencies
        super
        os_type = instance.platform.os_type
        raise Kitchen::UserError, /Error. Only windows is supported./ unless os_type == 'windows'
      end

      # this is defined in the base plugin
      def create(state)
        newhost = poolsclosed_machine
        raise Kitchen::InstanceFailure, 'Error, no available instances in poolsclosed' if newhost.nil?
        state[:hostname] = newhost
      end

      def poolsclosed_machine
        RestClient::Request.new(method: :get,
                                url: "#{config[:poolsclosed_baseurl]}machine",
                                headers: { content_type: :json }).execute do |rsp, _request, _result|
          case rsp.code
          when 200
            rsp.machineRelease[0]
          else
            raise Kitchen::InstanceFailure, "Error, could not obtain machine name from poolsclosed. Error code #{rsp.code}"
          end
        end
      end

      # this will generate false positives, but poolsclosed should handle it
      def delete(state)
        hostname = state[:hostname]
        poolsclosed_delete(hostname)
        state.delete(:hostname)
      end

      def poolsclosed_delete(hostname)
        RestClient::Request.new(method: :delete,
                                url: "#{config[:poolsclosed_baseurl]}machine",
                                headers: { content_type: :json, params: { machineName: hostname } }).execute do |rsp, _request, _result|
          case rsp.code
          when 200
            rsp.machineRelease[0]
          else
            raise Kitchen::InstanceFailure, "Error, could not delete machine from poolsclosed. Error code #{rsp.code}"
          end
        end
      end
    end
  end
end
