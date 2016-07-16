require_relative '../../../lib/helpers/faker_helper'
require_relative '../../../lib/helpers/async_helper'

# begin
#    $async = MIST::AsyncHelper
#   # $wait_until = MIST::AsyncHelper.wait_until{yield}
# end

Before  do
  $async = MIST::AsyncHelper
  $scenario_name = MIST::FakerHelper.scenario
  $objective = MIST::FakerHelper.objective
  $objectiveDescription = MIST::FakerHelper.objectiveDescription($objective)
  $endpoint = MIST::FakerHelper.endpoint
  $endpointDescription = MIST::FakerHelper.endpointDescription($endpoint)
  $endpointSubtype = MIST::FakerHelper.endpointSubtype
end

After  do
  $async = nil
  $scenario_name = nil
  $objective = nil
  $objectiveDescription = nil
  $endpoint = nil
  $endpointSubtype = nil
  $endpointDescription = nil
end
