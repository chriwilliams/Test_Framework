require 'MediTAF/utils/exceptions'

module MediTAF
  # Enables MediTAF to interact with available resources. It depends on resource adapters that implement
  # a set of require methods. The underlying adapters have the knowledge of the type resource with which
  # it communicates.
  module Services
    # @return [ResourcesMgr] a new instance of ResourceMgr
    def self.new
      ResourcesMgr.new
    end

    class ServiceConfigurationMissing < MediTAF::Utils::Exceptions::MediTAFException; end
    class ResourceAdapterLoadError < MediTAF::Utils::Exceptions::MediTAFException; end
    class ResourceAdapterMissing < MediTAF::Utils::Exceptions::MediTAFException; end
    class ResourceAdapterMethodMissing < MediTAF::Utils::Exceptions::MediTAFException; end
    class ResourceAdapterConfigurationMissing < MediTAF::Utils::Exceptions::MediTAFException; end
    class ResourceAdapterRequestError < MediTAF::Utils::Exceptions::MediTAFException; end
  end
end

require_relative 'services/resources_mgr'