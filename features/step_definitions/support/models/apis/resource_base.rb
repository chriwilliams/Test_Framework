# require 'eureka-client'
# require 'timeout'
# require 'active_support/inflector'

module APIs
  # Base object for all APIs
  class ResourceBase
    attr_reader :uuid

    # @param user [String] key in the $resource_env hash to access the checkmate_user_uuid for the impersonation header
    # @param uuid [String] uuid of the parent resource needed to make/get new child resource e.g. client division uuid to get a study, or study uuid to make a new scenario, etc.
    # @param resource [Euresource::Base, Hash] the resource to action on or a collection of resources
    def initialize(opt={}, resource = nil)
      @user = opt['user']
      @app = opt['app']
      @uuid = opt['uuid']
      @resource = resource
      @items = {}
      @current = nil
      if resource.is_a?(Hash)
        @current = {}
        resource.each_key { |key| @items[key] = {}; @current[key.to_s.singularize.to_sym] = nil }
      end
    end

    def include?(name, resource=nil)
      items(resource).include?(name)
    end

    # @param resource [Symbol] a managed resource for multiple resources
    def count(resource=nil, *)
      (@items) ? items(resource).count : 0
    end

    def current(resource=nil)
      raise "resource #{resource} not found in current collection" if @current.is_a?(Hash) && !@current.include?(resource)
      resource ? @current[resource] : @current
    end

    protected

    attr_reader :user

    # @param name [String] name of item name to switch context to
    # @param resource [Symbol] singular form of a managed resource e.g. objective, endpoint
    # @return [String, ResourceBase] string => uuid, ResourceBase => object inheriting ResourceBase
    def switch_to(name, resource=nil)
      set_current(name, resource)
    end

    def item(name, resource=nil)
      found = (block_given?) ? yield : items(resource)[name]
      raise %Q{#{resource ? resource.to_s.singularize : ''} "#{name}" not found in "#{self.class}"} unless found
      found
    end

    def items(resource=nil)
      return @items unless resource
      resource = resource.to_s.pluralize.to_sym unless resource.to_s.pluralize == resource.to_s
      raise "#{resource} resource not found in #{self.class}" unless @items.include?(resource)
      @items[resource]
    end

    def destroy
      @items = @current = nil
    end

    # @param opts [Hash] options for this method
    # @param resource [Symbol] the specific resource to use
    # @return [Euresource::Base]
    def index(opts={}, resource=nil)
      opts[:method] = :index
      do_request(:index, :all, opts, resource)
    end

    # @param uuid [String] uuid of the resource
    # @param opts [Hash] the options passed to get method
    # @param resource [Symbol] the specific resource to use
    # @return [Euresource::Base]
    def show(uuid, opts={}, resource=nil)
      opts[:method] ||= :show
      do_request(:show, uuid, opts, resource)
    end

    # @param body [Hash] request body
    # @param opts [Hash] options for this method
    # @param resource [Symbol] the specific resource to use
    # @return [Euresource::Base]
    def post(body=nil, opts={}, resource=nil)
      do_request(:post, body, opts, resource)
    end

    # @param body [Hash] request body
    # @param opts [Hash] options for this method
    # @param resource [Symbol] the specific resource to use
    # @return [Euresource::Base]
    def post!(body=nil, opts={}, resource=nil)
      do_request(:post!, body, opts, resource)
    end

    # @param body [Hash] request body
    # @param opts [Hash] options for this method
    # @param resource [Symbol] the specific resource to use
    # @return [Euresource::Base]
    def put(body={}, opts={}, resource=nil)
      do_request(:put, body, opts, resource)
    end

    # @param uuid [String] uuid of the resource to delete
    # @param resource [Symbol] resource to reference when multiple resources are mananged
    def delete(uuid, resource=nil)
      do_request(:delete, uuid, nil, resource)
    end

    def convert_case(string)
      rval = string.camelize.underscore.gsub(/([ -]+)/, '_').gsub(/_+/, '_')
      msg = yield(rval)
      raise UnknownEntityType, %Q{unknown #{msg[:type]} "#{string}". Excepting: #{msg[:types].inspect}} if msg
      rval
    end

    def impersonation_header
      {'MCC-Impersonate' => "com:mdsol:users:#{$config['utils']['apps'][@app][@user]}"}
    end

    private

    # @param request [Symbol]
    # @param body [Hash] request body appropriate for request
    # @param opts [Hash] other params, etc. appropriate for request
    # @param resource [Symbol] when managing multiple resources
    def do_request(request, body, opts, resource)
      opts ||= {}
      opts[:http_headers] = impersonation_header
      with_retries([Net::HTTP::Persistent::Error, Faraday::Error::ConnectionFailed, Faraday::Error::TimeoutError],
                   {timeout: 1, attempts: 1, logger: LoggingIt.new}) do
        case request
          when :index
            opts[:method] ||= :index
            resource(resource).get(:all, opts)
          when :show
            opts[:method] ||= :show
            resource(resource).get(body, opts)
          when :post
            opts[:method] ||= :create
            resource(resource).post(body, opts)
          when :post!
            opts[:method] ||= :create
            resource(resource).post!(body, opts)
          when :put
            opts[:method] ||= :update
            resource(resource).put!(body, opts)
          when :delete
            opts[:method] ||= :destroy
            resource(resource).delete(body, opts)
        end
      end
    rescue => e
      raise e, %Q{#{request}: #{body ? "body=#{body.inspect}" : nil} opts={#{opts.slice!(:http_headers).inspect}#{resource ? " on resource #{resource}" : nil}}}
    end

    def resource(resource=nil)
      return @resource if resource.nil?
      # must be a hash of multiple resources
      raise %Q{resource "#{resource}" not found} unless @resource.include?(resource)
      @resource[resource]
    end

    # @param args [Array, String] Array[name, resource], String name
    def set_current(name, resource)
      if @current.is_a?(Hash)
        @current[resource] = item(name, resource.to_s.pluralize.to_sym)
      else
        @current = item(name, resource)
      end
    end
  end

  class UnknownEntityType < Exception;
  end
  class LoggingIt
    def warn(msg)
      puts msg
    end
  end
end
