module APIs
  # representation of a objective
  class Objective < ResourceBase
    def initialize(app, user, objective_uuid)
      super({'app' => app, 'user' => user, 'uuid' => objective_uuid}, Euresource::Endpoints)
      @endpoint_types = Euresource::EndpointTypes.get(:all, http_headers: impersonation_header).collect { |endpoint_type|
        endpoint_type.name[/endpoint_type\.(.+)/, 1]
      }
      @endpoint_subtypes = Euresource::EndpointSubtypes.get(:all, http_headers: impersonation_header).collect { |endpoint_subtype|
        endpoint_subtype.name[/endpoint_subtype\.(.+)/, 1]
      }
    end

    # @param body [Hash] parameters for making a new endpoint
    # @option body [String] :endpoint_type
    # @option body [String] :endpoint_subtype
    # @option body [String] :description name of new endpoint
    def add_endpoint(body)
      type = body[:endpoint_type] = type(body[:endpoint_type])
      subtype = body[:endpoint_subtype] = subtype(body[:endpoint_subtype])

      @items[type] ||= {}
      @items[type][subtype] ||= {}

      @current = @items[type][subtype][body[:description]] =
          post!(body, {params: {objective_uuid: uuid}, method: 'create'}).uuid
    end

    # @param params [Hash] endpoint details
    # @option params [String] :endpoint_type
    # @option params [String] :endpoint_subtype
    # @option params [String] :description
    def endpoint(params=nil)
      switch_to(params) if params
      @current
    end

    # @param params [Hash] endpoint details
    # @option params [String] :type
    # @option params [String] :subtype
    # @option params [String] :description
    # @param resource [Symbol] not used
    def include?(params, resource=nil)
      @items[type(params[:type])][subtype(params[:subtype])].include?(params[:description])
    end

    # @param resource [Symbol] not used
    # @param params [Hash] endpoint details
    # @option params [String] :type
    # @option params [String] :subtype
    def count(resource=nil, params)
      return 0 unless @items
      (params[:subtype]) ?
          @items[type(params[:type])][subtype(params[:subtype])].count :
          @items[type(params[:type])].count
    end

    # @param params [Hash]
    # @option params [String] :type endpoint
    # @option params [String] :subtype endpoint
    # @option params [String] :description endpoint
    # @return [Object]
    def item(params, resource=nil)
      super(params, resource) do
        @items[(type(params[:type]))][subtype(params[:subtype])][params[:description]]
      end
    end

    def clean
      destroy
    end

    private

    def type(type)
      "endpoint_type.#{convert_case(type) { |etype| %Q{unknown endpoint type "#{etype}". Excepting: #{@endpoint_types.inspect}} unless @endpoint_types.include?(etype) }}"
    end

    def subtype(subtype)
      "endpoint_subtype.#{convert_case(subtype) { |esubtype| {type: 'endpoint subtype', types: @endpoint_subtypes} unless @endpoint_subtypes.include?(esubtype) }}"
    end
  end
end

