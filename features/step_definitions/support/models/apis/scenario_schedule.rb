module APIs
  class ScenarioSchedule < ResourceBase
    attr_reader :scenario_schedule_uuid, :schedule_name

    # @param uuid [Hash] uuids for scenario schedule and schedule
    # @option uuid [String] :uuid scenario schedule
    # @option uuid [String] :schedule_uuid apollo's schedule
    def initialize(app, user, uuid)
      @scenario_schedule_uuid = uuid[:uuid]
      @schedule_uuid = uuid[:schedule_uuid]
      @schedule_name = uuid[:schedule_name]
      super({'app' => app, 'user' => user, 'uuid' => uuid[:schedule_uuid]},
            # super(user, uuid[:schedule_uuid],
            schedule: Euresource::Schedule,
            study_activities: Euresource::StudyActivities,
            study_events: Euresource::StudyEvents,
            study_cells: Euresource::StudyCells)
      @visit_types =
          Euresource::VisitTypes.get(:all, http_headers: impersonation_header).collect { |visit_type|
            visit_type.name[/visit_type\.(.+)/, 1]
          }
      @encounter_types =
          Euresource::EncounterTypes.get(:all, http_headers: impersonation_header).collect { |encounter_type|
            encounter_type.name[/encounter_type\.(.+)/, 1]
          }
      @visit_optional_types =
          Euresource::StudyEventOptionalConditionalTypes.get(:all, http_headers: impersonation_header).collect { |visit_optional|
            visit_optional.name[/visit_optional\.(.+)/, 1]
          }
      @activity_optional_types =
          Euresource::ActivityOptionalConditionalTypes.get(:all, http_headers: impersonation_header).collect { |activity_optional|
            activity_optional.name[/activity_optional\.(.+)/, 1]
          }
    end

    # @param activities [Array] array of Hashes of activity {:name, :uuid} for making new study activities
    def add_study_activities(activities)
      activities.each { |activity| add_study_activity(activity) }
    end

    # @param body [Hash] parameters for making a new study activity
    # @option body [String] :name of activity
    # @option body [String] :uuid from activities resource
    def add_study_activity(body)
      @current[:study_activity] = @items[:study_activities][body[:name]] = {
          activity_uuid: body[:uuid],
          study_activity_uuid: post!(
              {activity_uuid: body[:uuid]}, {params: schedule_uuid, method: :create},
              :study_activities)
                                   .uuid
      }
    end

    def alias_study_activity(study_activity, attributes)
      put(attributes, {params: {uuid: @items[:study_activities][study_activity][:study_activity_uuid]}, method: :update}, :study_activities)
    end

    def study_activity(name=nil)
      switch_to(name, :study_activity) if name
      @current[:study_activity]
    end

    # @param activities [Array] array of Hashes of event bodies for making new study events
    def add_study_events(events)
      events.each { |event| add_study_event(event) }
    end

    # @param body [Hash] parameters for making a new event
    # @option body [String] :name of event
    # @option body [String] :encounter_type
    # @option v [String] :visit_type
    def add_study_event(body)
      body[:encounter_type] = encounter_type(body[:encounter_type])
      body[:visit_type] = visit_type(body[:visit_type])
      @current[:study_event] = @items[:study_events][body[:name]] =
          post!(body, {params: schedule_uuid, method: :create}, :study_events).uuid
    end

    def study_event(name=nil)
      switch_to(name, :study_event) if name
      @current[:study_event]
    end

    # @param cells [Array] array of cell paramter Hashes for making new cells
    # @note cells [Hash] :activity name
    # @note cells [Hash] :event name
    def add_study_cells(cells)
      post!(cell_request_body(cells), {params: schedule_uuid, method: :create}, :study_cells).study_cells.each do |cell|
        @current[:study_cell] =
            @items[:study_cells]["#{cell['study_activity_uuid']}/#{cell['study_event_uuid']}"] = cell['uuid']
      end
    end

    # @param cells [Array] Array of hashes [{activity: "", event: ""},...]
    # @return [Array] Array of hashes [{"activity/event" => "cell uuid"},...]
    def study_cells(cells)
      @items[:study_cells].collect { |cell| {"#{cell[:activity]}/#{cell[:event]}" => @items[:study_cells][cell_name(cell)]} }
    end

    def study_cell(activity=nil, event=nil)
      raise 'activity and event are either both nil or non-nil' if activity.nil? ^ event.nil?
      switch_to(cell_name(activity, event), :study_cell) if activity && event
      @current[:study_cell]
    end

    def cell_name(activity, event=nil)
      activity, event = activity.dup if activity.is_a? Array
      activity, event = activity.to_a if activity.is_a? Hash
      "#{@items[:study_activities][activity][:study_activity_uuid]}/#{@items[:study_events][event]}"
    end

    def update_cell(cells_data)
      cells_data.each do |data|
        uuid = @items[:study_cells]["#{@items[:study_activities][data[:activity]][:study_activity_uuid]}/#{@items[:study_events][data[:event]]}"]
        put(data[:attrs], {params: {uuid: uuid}, method: :update}, :study_cells)
      end
    end

    def update_study_events(study_event_data)
      study_event_data.each do |data|
        uuid = @items[:study_events][data[:event]]
        put(data[:attrs], {params: {uuid: uuid}, method: :update}, :study_events)
      end
    end


    def summary_benchmarks
      show(@schedule_uuid, {method: :summary_benchmarks}, :schedule).attributes.except('uuid')
    end

    def clean
      destroy
    end

    def include?(name, resource)
      super((resource == :study_cells) ? cell_name(name.split('/')) : name, resource)
    end

    private

    def schedule_uuid
      {schedule_uuid: uuid}
    end

    def cell_request_body(cells)
      {study_cells: cells.collect do |cell|
        raise MissingStudyActivity, %Q{activity "#{cell[:activity]}" not found in model} unless include?(cell[:activity], :study_activities)
        raise MissingStudyEvent, %Q{event "#{cell[:event]}" not found in model} unless include?(cell[:event], :study_events)
        {
            study_activity_uuid: @items[:study_activities][cell[:activity]][:study_activity_uuid],
            study_event_uuid: @items[:study_events][cell[:event]]
        }
      end}
    end

    def encounter_type(type)
      "encounter_type.#{convert_case(type) { |etype| {type: 'encounter type', types: @encounter_types} unless @encounter_types.include?(etype) }}"
    end

    def visit_type(type)
      "visit_type.#{convert_case(type) { |vtype| {type: 'visit type', types: @visit_types} unless @visit_types.include?(vtype) }}"
    end
  end

  class MissingStudyActivity < Exception;
  end
  class MissingStudyEvent < Exception;
  end
end
