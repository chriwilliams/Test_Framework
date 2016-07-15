require 'mauth-client'
require 'faraday'
require 'faraday_middleware'

module MediTAF
  module Services
    module Clients
      # The specific resource adapter for MAuthClient. It depends on the following configurations
      # * services.mauth
      #   * mauth_url
      #   * mauth_api_version
      #   * app_uuid
      #   * key_file : location of file containing private key
      #   * mauth_logger (optional)
      #   * authenticate_responses (optional)
      class MauthAdapter

        # verifies needed configuration items exist for mauth-client
        # @raise [ResourceAdapterConfigurationMissing] lists the missing required configuration items
        def initialize
          errs = []
          errs << 'mauth configuration' unless mauth_config
          if errs.empty?
            errs << 'mauth_api_version' unless mauth_config[:mauth_api_version]
            errs << 'mauth_url' unless mauth_config[:mauth_baseurl]
            errs << 'app_uuid' unless mauth_config[:app_uuid]
            errs << 'key_file' unless mauth_config[:private_key_file]
            errs << 'authenticate_responses' if mauth_config[:authenticate_response].nil?
          end
          unless errs.empty?
            raise ResourceAdapterConfigurationMissing, 'Mauth Adapter Configurations: cannot find ' + errs.join(', ')
          end
        end

        # configure a new MAuth::Client based on configuration items
        # @note configures MAuth::Client to return all response in JSON format
        def configure
          @mauth_client = ::MAuth::Client.new(mauth_config)

          @connection = Faraday.new do |builder|
            builder.use MAuth::Faraday::MAuthClientUserAgent, "MediTAF Mauth Client Adapter"
            builder.use MAuth::Faraday::RequestSigner, :mauth_client => @mauth_client
            builder.use MAuth::Faraday::ResponseAuthenticator, :mauth_client => @mauth_client if mauth_config[:authenticate_response]
            builder.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
            builder.use FaradayMiddleware::ParseXml, content_type: /\bxml$/
            builder.adapter Faraday.default_adapter
          end
        end

        # loads a new MauthClient object for request on base_url
        # @param args [Hash] arguments
        # @option args [String] :baseurl the base url of this resource
        # @return [MediTAF::Services::Clients::MauthClient]
        # @raise [ResourceAdapterLoadError] when instantiating a new MauthClient
        def load(args)
          raise MauthClientBaseURLMissing, "supply a base url" unless args.is_a?(Hash) && args.has_key?(:baseurl)
          MauthClient.new(@connection, args[:baseurl])
        end

        private

        def mauth_config
          raise ServiceConfigurationMissing, "services not found in configuration" unless  MediTAF::Utils::Configuration['services']
          raise ServiceConfigurationMissing, "euresource not found in configuration" unless  MediTAF::Utils::Configuration['services']['mauth']
          unless @mauth_config
            cfg =  MediTAF::Utils::Configuration['services']['mauth']
            @mauth_config = {}
            @mauth_config[:mauth_baseurl] = cfg['mauth_url']
            @mauth_config[:private_key_file] = cfg['key_file']
            @mauth_config[:app_uuid] = cfg['app_uuid']
            @mauth_config[:mauth_api_version] = cfg['mauth_api_version']
            @mauth_config[:authenticate_response] = cfg['authenticate_responses']
          end
          @mauth_config
        rescue => e
          nil
        end
      end

      # A MauthClient object set to a specific base_url and uses the common MAuth::Client object
      # @note only MauthAdapter object instantiate objects of this type
      class MauthClient
        # @param connection [Faraday] defines the MAuth::Faraday parameters/handlers/response formats
        # @param base_url [String] the base url for all paths
        # @raise [MauthClientBaseURLMissing] when the no base url is given
        def initialize(connection, base_url)
          @connection, @base_url = connection, base_url
        end

        # @param [Hash] opts the arguments to do an HTTP request
        # @option opts [Symbol] :verb :get, :post, :put, or :delete
        # @option opts [Symbol] :resource
        # @option opts [Symbol] :body
        # @option opts [Symbol] :content_type
        # @return [Faraday::Response]
        # @raise [ResourceAdapterRequestError]
        def request(opts)
          headers = {}
          headers['Content-Type'] = opts[:content_type] if opts[:content_type]
          headers['Content-Type'] = 'application/json' if opts[:content_type].nil? && opts[:body]
          headers['Accept'] = opts[:accept] || 'text/html,application/xhtml+xml,application/xml,application/json'
          @connection.run_request(opts[:verb], @base_url + '/' + opts[:resource], opts[:body], headers)
        rescue MAuth::InauthenticError, MAuth::UnableToAuthenticateError => e
          raise ResourceAdapterRequestError, "Failed to #{opts[:verb]} #{opts[:resource]}. Inner Exception: #{e.to_s}"
        rescue => e
          raise ResourceAdapterRequestError, "#{opts}. Inner Exception: #{e.to_s}"
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
      end

      class MauthClientBaseURLMissing < MediTAF::Utils::Exceptions::MediTAFException; end
    end
  end
end
