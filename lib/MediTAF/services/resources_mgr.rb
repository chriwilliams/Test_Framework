# ResourcesMgr manages the requested resources.
# the manager needs a specific adapter from where it will interact with resources
# if no adapter is specified in the configuration i.e. ['services']['adapter']
#   then 'euresource' adapter is used the default
# all resources are expressed as method
# each accessed resources exposes the underlying adapter implementation

require 'MediTAF/utils/configuration'
#require 'active_support/core_ext/string/inflections'

module MediTAF
  module Services
    class ResourcesMgr
      include Logging

      attr_reader :adapters
      attr_reader :resources
      attr_reader :stage

      # @note loads euresource adapter by default, otherwise attempts to load a specific adapter. adapters are
      #  specified in *MediTAF_configuration.services.adapter* value. the location of the adapter defaults
      #  to services/clients within MediTAF, otherwise it can be specified in *MediTAF_configuration.services.adapter_home*
      #  value. when MediTAF attempts to load the adapter and no location has been specified, MediTAF assumes that the
      #  adapter has been load into the environment.
      # @note the adapter must be in namespace *MediTAF::Services::Clients*
      # @raise [ResourceAdapterMethodMissing] when adapter does not respond to configure
      # @raise [ResourceAdapterLoadError] when adapter could not be loaded
      def initialize
        @resources = {}
        @adapters = {}

        raise ServiceConfigurationMissing, "services not found in configuration" unless MediTAF::Utils::Configuration['services']

        adapter_home =  MediTAF::Utils::Configuration['services']['adapter_home']
        adapter_home ||= "#{MediTAF.root}/lib/MediTAF/services/clients"

        adapters =  MediTAF::Utils::Configuration['services']['adapters']

        if adapters
          adapters.split(/ *, */).each do |adapter|
            begin
              require "#{adapter_home}/#{adapter}_adapter" if File.exist? "#{adapter_home}/#{adapter}_adapter.rb"
              @adapters[adapter.to_sym] = "MediTAF::Services::Clients::#{adapter.camelize}Adapter".constantize.new
              @adapters[adapter.to_sym].configure
            rescue NoMethodError => e
              raise ResourceAdapterMethodMissing, %Q|"#{adapter.camelize}Adapter" is missing required configure method|
            rescue NameError => e
              raise ResourceAdapterLoadError, %Q|Couldn't load resource adapter "#{adapter.camelize}Adapter". Inner Exception: #{e.to_s}|
            end
          end
        end
      end

      # removes all or one resource from the resources hash
      # @param resource [Symbol] the resource to remove
      def delete(resource=nil)
        if resource
          @resources.delete(resource) if @resources.include?(resource)
        else
          @resources.clear
        end
      end

      # checks if a resource has been deployed
      # @note not implemented
      # @param resource [Symbol] the resource to check
      def deployed?(resource)
        raise "not implemented"
      end

      # checks if a resource is consumable
      # @note not implemented
      # @param resource [Symbol] the resource to check
      def connected?(resource)
        raise "not implemented"
      end

      # @param adapter [Symbol] the adapter to get the stage from
      # @return [Symbol] gets the current stage set for the adapter
      def stage(adapter=:euresource)
        @adapters[adapter].stage.to_sym if @adapters.has_key? adapter
      end

      # @param adapter [Symbol] the adapter to get the stage from
      # @return [Symbol] gets the default stage set for the adapter
      def default_stage(adapter=:euresource)
        @adapters[adapter].default_stage if @adapters.has_key? adapter
      end

      # @param resource [Symbol] resource as a method name
      # @param args [Object] args are passed to underlying adapter
      # @return [Object] the specific resource adapter object
      # @raise [ResourceAdapterMethodMissing] when adapter does not respond to load
      def method_missing(resource, *args, &block)
        opts = args[0] || {}
        unless @resources.include?(resource)
          unless @adapters.has_key? opts[:adapter]
            raise ResourceAdapterMissing, %Q/'#{opts[:adapter]}' adapter not found/
          end
          adapter = @adapters[ opts[:adapter] ]
          opts.delete(:adapter)
          @resources[resource] = ( opts.nil? || opts.empty?) ? adapter.load(resource) : adapter.load(opts)
        end
        @resources[resource]
      rescue NoMethodError => e
        raise ResourceAdapterMethodMissing, "required load method missing"
      end
    end
  end
end