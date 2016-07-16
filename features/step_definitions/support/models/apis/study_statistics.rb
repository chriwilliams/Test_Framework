module APIs
  class StudyStatistics < ResourceBase
    def initialize(app, user)
      super({'app' => app, 'user' => user, 'uuid' => nil}, Euresource::StudyStatistics)
    end

    def collect(indication_uuid, phase_uuid)
      stats = study_statistics(indication_uuid, phase_uuid)
      raise "no study statistics found with supplied criteria: #{indication_uuid}, #{phase_uuid}" if stats.nil? || stats.size == 0
      add_to_collection(stats)
    end

    def clean
      destroy
    end

    private

    def add_to_collection(stats)
      if stats.is_a?(Hash)
        @items[stats[:name]] = stats[:uuid]
      else
        stats.each { |stat| @items[stat.send(:specificity)] = stat }
      end
      @items
    end

    def study_statistics(indication_uuid, phase_uuid)
      index(params: {indication_uuid: indication_uuid, phase_uuid: phase_uuid}) || []
    end
  end
end
