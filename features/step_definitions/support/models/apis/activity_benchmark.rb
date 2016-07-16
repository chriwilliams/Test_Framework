module APIs
  class ActivityBenchmark < ResourceBase
    def initialize(app, user)
      super({'app' => app, 'user' => user, 'uuid' => nil}, Euresource::ActivityBenchmark)
    end

    def collect(schedule_uuid, indication_uuid, phase_uuid)
      activity_benchmarks = activity_benchmarks(schedule_uuid, indication_uuid, phase_uuid)
      if activity_benchmarks.nil?
        raise "no activity benchmarks found with supplied criteria: #{schedule_uuid}, #{indication_uuid}, #{phase_uuid}"
      end
      add_to_collection(activity_benchmarks)
    end

    def clean
      destroy
    end

    private

    def add_to_collection(stats)
      stats.attributes['activity_benchmarks'].each { |stat| @items[stat['activity_code']] = stat }
      @items
    end

    def activity_benchmarks(schedule_uuid, indication_uuid, phase_uuid)
      $study_statistics.items.keys.map { |num| $study_statistics.items[num] }.each do |stat|
        params = {indication_uuid: stat.indication_uuid, phase_uuid: stat.phase_uuid, schedule_uuid: schedule_uuid}
        benchmarks = post(params, method: 'list')
        return benchmarks if benchmarks.last_result.status == 200
      end
    end
  end
end
