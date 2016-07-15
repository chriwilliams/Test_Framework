module FirstFramework
  module Services
    module Clients
      class MockAdapter
        def configure
          @resources = {}
          @resources[:countries] = Countries.new
          @resources[:medidations] = Medidations.new
        end

        def load(resource)
          @resources[resource] if @resources.include?(resource)
        end

        def deployed?(resource)
          true
        end

        def connected?(resource)
          true
        end

        def stage
          :sandbox
        end
      end

      class Countries
        def initialize
          @getResponse = [CountriesGetResponse.new]
        end

        def get(*args)
          @getResponse
        end
      end

      class CountriesGetResponse
        def name;
          'United States of America';
        end

        def uuid;
          '123-ab-345';
        end

        def country_code;
          'USA';
        end
      end

      class Medidations
        def initialize
          @getResponse = [MedidationsGetResponse.new]
        end

        def get(*args)
          @getResponse
        end
      end

      class MedidationsGetResponse
        def uuid;
          '123-456';
        end

        def status;
          'active';
        end

        def job_title_uuid;
          'sponsor';
        end
      end
    end
  end
end
