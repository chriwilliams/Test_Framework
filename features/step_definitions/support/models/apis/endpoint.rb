module APIs
  # representation of an endpoint
  class Endpoint < ResourceBase
    def initialize(user, endpoint_uuid)
      super(user, endpoint_uuid, Euresource::Endpoint)
    end
  end
end