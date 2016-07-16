module MIST
  class FakerHelper
    ObjectiveType = ['Primary', 'Secondary', 'Tertiary', 'Other']
    EndpointType = ['Primary', 'Secondary', 'Tertiary', 'Other', 'Exploratory']
    EndpointSubtype = ['Efficacy', 'Safety', 'Pharmacodynamic', 'Pharmacoeconomic', 'Pharmacogenomic', 'Bio-availability', 'Bio-equivalency', 'Food effect', 'Tolerability', 'Exploratory', 'Other']

    class << self

      def stringify(param, *params)
        "#{param}#{params.join()}"
      end

      def scenario
        stringify('Scenario ', Array(1..9).sample, DateTime.now.strftime("%H%M%S%6N"))
      end

      def objective
        ObjectiveType.sample
      end

      def objectiveDescription(type = 'Primary')
        stringify(type, ' Objective created on ', DateTime.now.strftime("%m-%d-%Y:%H%M%S.%6N"))
      end

      def endpoint
        EndpointType.sample
      end

      def endpointDescription(type = 'Primary')
        stringify(type, ' Endpoint created on ', DateTime.now.strftime("%m-%d-%Y:%H%M%S.%6N"))
      end

      def endpointSubtype
        EndpointSubtype.sample
      end

    end
  end
end