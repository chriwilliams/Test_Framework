require 'euresource'

module FirstFramework
  module Services
    module Clients
      # The specific resource adapter for Euresource. It depends on the following configurations
      # * services.euresource
      #   * mauth_url
      #   * app_uuid
      #   * key_file : location of file containing private key
      #   * eureka_url
      #   * stage
      #   * mauth_logger (optional)
      #   * eureka_logger (optional)
      #   * authenticate_responses (optional)
      class EuresourceAdapter

        # verifies needs configuration items exist for eureka-client
        def initialize
          errs = []
          errs << 'euresource configuration' unless euresource_config
          if errs.empty?
            errs << 'eureka_url' unless euresource_config['eureka_url']
            errs << 'mauth_url' unless euresource_config['mauth_url']
            errs << 'app_uuid' unless euresource_config['app_uuid']
            errs << 'key_file' unless euresource_config['key_file']
            errs << 'stage' unless euresource_config['stage']
            errs << 'authenticate_responses' if euresource_config['authenticate_responses'].nil?
          end
          unless errs.empty?
            raise ResourceAdapterConfigurationMissing, 'Euresource Adapter Configurations: cannot find ' + errs.join(', ')
          end
        end

        # require configurations for eureka-client
        def configure
          cfg = euresource_config
          Euresource.configure do
            config.stage_defaults do |defaults|
              defaults.mauth(cfg['mauth_url']) do |mauth_config|
                mauth_config.app_uuid cfg['app_uuid']
                mauth_config.private_key_file cfg['key_file']

                # Only set if you want different logger for MAuth
                mauth_config.logger cfg['mauth_logger'].constantize.new if cfg['mauth_logger']
              end
              defaults.use MAuth::Faraday::RequestSigner, defaults.mauth_config

              # Turns on develop mode for local development, which adds extra logging and forces API deployments to Eureka
              # without having to delete prior versions of an API document for local development while making changes to an
              # API document.
              defaults.develop_mode false

              # Rails logger will be used for all logging if this is not set in Rails.
              defaults.logger EuresourceLogger.new if cfg['eureka_logger']

              #Un-comment this option if you want to skip authenticating eureka responses
              defaults.mauth_authenticate_responses cfg['authenticate_responses']

              defaults.use FaradayMiddleware::RackCompatible, CacheComplainer::Complainer
            end

            # This applies all default from above to configure a Eureka::Client instance for a specific eureka stage
            config.stage(cfg['eureka_url'], cfg['stage']) do |builder|
              builder.deployment_base_uri 'http://localhost:3000'
              builder.faraday_adapter :typhoeus
            end
          end
        end

        # @param resource [Symbol] the resource to get
        # @return [Euresource::Base] The anonymous class.
        def load(resource)
          Euresource.class_for_resource(resource)
        rescue => e
          raise ResourceAdapterLoadError, "Can't load resource #{resource}. Inner Exception: #{e.to_s}"
        end

        # @note not implemented
        # checks if the resource is deployed within eureka
        # @param resource [Symbol] the resource to check
        def deployed?(resource)
        end

        # @note not implemented
        # check if the resource is consumable
        # @param resource [Symbol] the resource to check
        def connected?(resource)
        end

        # @return [String] the stage value from the configuration
        def stage
          euresource_config['stage']
        end

        # @return [Symbol] the euresource clients by stage from euresource configuration
        def clients_by_stage
          Euresource.config.clients_by_stage
        end

        # @return [Symbol] the default stage from euresource configuration
        def default_stage
          Euresource.config.default_stage
        end

        private

        def euresource_config
          raise ServiceConfigurationMissing, "services not found in configuration" unless FirstFramework::Utils::Configuration['services']
          FirstFramework::Utils::Configuration['services']['euresource']
        end
      end
    end
  end
end