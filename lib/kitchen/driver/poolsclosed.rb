# idk why this is needed, there is a file in test kitchen that does this
# for some reason my project isnt being aggreeable without it 
require "pathname"
require "thread"

require "kitchen/errors"
require "kitchen/logger"
require "kitchen/logging"
require "kitchen/shell_out"
require "kitchen/configurable"
require "kitchen/util"

require "kitchen/provisioner"
require "kitchen/provisioner/base"
require "kitchen/color"
require "kitchen/collection"
require "kitchen/config"
require "kitchen/data_munger"
require "kitchen/driver"
require "kitchen/driver/base"
require "kitchen/driver/ssh_base"
require "kitchen/driver/proxy"
require "kitchen/instance"
require "kitchen/transport"
require "kitchen/transport/base"
require "kitchen/loader/yaml"
require "kitchen/metadata_chopper"
require "kitchen/platform"
require "kitchen/state_file"
require "kitchen/ssh"
require "kitchen/suite"
require "kitchen/verifier"
require "kitchen/verifier/base"
require "kitchen/version"
require 'rubygems'
require 'kitchen'

require "rest-client"
require 'pry-byebug'
require 'kitchen/driver/poolsclosed_version'

module Kitchen

  module Driver 
    class PoolsClosed < Kitchen::Driver::Base
      

     kitchen_driver_api_version 2
     plugin_version Kitchen::Driver::POOLSCLOSED_VERSION
     # required_config :base_url
     # required_config :win_user
     # required_config :win_pass
     #required_config
     #default_config :base_url, 
     no_parallel_for :create, :destroy


      # invoked by kitchen create 
      def xcreate(state)
      RestClient::Request.new(method: :get,
                              url: "#{config[:baseurl]}/machine",
                              headers: { content_type: :json}).execute do |rsp, _request, _result|
        case rsp.code
        when 200
          [:success, rsp.to_str]
        else
          raise "Error, received response #{rsp.to_str}"
        end
      end
      end
    end
  end
end
