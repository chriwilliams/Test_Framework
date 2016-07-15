require 'FirstFramework/utils/exceptions'

module FirstFramework
  # Enables FirstFramework to interact with available resources. It depends on resource adapters that implement
  # a set of require methods. The underlying adapters have the knowledge of the type resource with which
  # it communicates.
  module Services
    # @return [ResourcesMgr] a new instance of ResourceMgr
    def self.new
      ResourcesMgr.new
    end

    class ServiceConfigurationMissing < FirstFramework::Utils::Exceptions::FirstFrameworkException; end
    class ResourceAdapterLoadError < FirstFramework::Utils::Exceptions::FirstFrameworkException; end
    class ResourceAdapterMissing < FirstFramework::Utils::Exceptions::FirstFrameworkException; end
    class ResourceAdapterMethodMissing < FirstFramework::Utils::Exceptions::FirstFrameworkException; end
    class ResourceAdapterConfigurationMissing < FirstFramework::Utils::Exceptions::FirstFrameworkException; end
    class ResourceAdapterRequestError < FirstFramework::Utils::Exceptions::FirstFrameworkException; end
  end
end

require_relative 'services/resources_mgr'