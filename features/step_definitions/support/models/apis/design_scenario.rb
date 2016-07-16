module APIs
  class DesignScenario < ResourceBase
    # @param scenario_uuid [String] scenario's uuid
    # @note available resources [:objectives, :endpoints]
    def initialize(app, user, scenario)
      @scenario = scenario

      super({'app' => app, 'user' => user, 'uuid' => scenario.uuid},
            objectives: Euresource::Objectives, purposes: Euresource::Purposes,
            scenario_schedules: Euresource::ScenarioSchedules)
      @objective_types =
          Euresource::ObjectiveTypes.get(:all, http_headers: impersonation_header).collect { |objective_type|
            objective_type.name[/objective_type\.(.+)/, 1]
          }
      @other_purpose_types = Hash[
          Euresource::OtherPurposeTypes.get(:all, http_headers: impersonation_header).map { |other_type|
            [other_type.description[/other_purpose_type\.(.+)/, 1], other_type.uuid]
          }
      ]
    end

    def real_name
      @scenario.name
    end

    # @param body [Hash] parameters for making a new objective
    # @option body [String] :description name of the objective
    # @option body [String] :objective_type objective type [primary, secondary, tertiary, other]
    def add_objective(body)
      body[:design_scenario_uuid] = uuid
      body[:objective_type] = objective_type(body[:objective_type])
      @items[:objectives][body[:objective_type]] ||= {}
      @current[:objective] =
          @items[:objectives][body[:objective_type]][body[:description]] =
              Objective.new(@app, @user, post!(body, {params: {design_scenario_uuid: uuid}, method: 'create'}, :objectives).uuid)
    end

    # @param params [Hash] objective details
    # @option params [String] :type of objective
    # @option params [String] :description of objective
    def objective(params=nil)
      @current[:objective] = @items[:objectives][objective_type(params[:objective_type])][params[:objective_description]] if params
      @current[:objective]
    end

    # @param cells [Hash] study cells for add purpose associations to
    # @option cells [String] :activity name
    # @option cells [String] :event name
    # @param purposes [Hash] purpose associations to add to each study cell
    # @option purposes [Symbol] :purpose_type ['endpoint']
    # @option purposes [String] :purpose name of associated purpose e.g. name of associated endpoint (optional)
    # @option purposes [String] :activity name (optional)
    # @option purposes [String] :event name (optional)
    def add_purposes(cells, purposes)
      post!({study_cells: associated_study_cells(cells), purpose_associations: associated_study_purposes(purposes)},
            {params: {design_scenario_uuid: uuid}, method: :associate},
            :purposes)
    end

    # @param cells [Array<Hash>] associated study cell
    # @option cell [String] :activity
    # @option cell [String] :event
    def purposes(cells)
      post!({study_cells: associated_study_cells(cells)},
            {params: {design_scenario_uuid: uuid}, method: :purposes_for_studycells},
            :purposes)
    end

    # @param body [Hash, String, Nil] parameters for making a new schedule, schedule name,
    # @option body [String] :name of schedule
    def add_scenario_schedule(body=nil)
      body = {name: body} if [String, NilClass].include?(body.class)
      schedule = post!(body, {params: {design_scenario_uuid: uuid}, method: :create}, :scenario_schedules)
      body[:name] = schedule.name.dup unless body[:name]
      @current[:scenario_schedule] = @items[:scenario_schedules][body[:name]] =
          ScenarioSchedule.new(@app, @user, {uuid: schedule.uuid, schedule_uuid: schedule.schedule_uuid, schedule_name: schedule.name})
    end

    # @param name [String] scenario_schedules to switch current context to
    def scenario_schedule(name=nil)
      switch_to(name, :scenario_schedule) if name
      @current[:scenario_schedule]
    end

    def clean
      @items[:scenario_schedules].each_value { |schedule| schedule.clean } if @items
      destroy
    end

    # @param params [Hash, String] String => a scenario schedule name
    # @option params [String] :type objective
    # @option params [String] :description objective
    # @param resource [Symbol] :objectives, :scenario_schedules
    # @return [Boolean]
    def include?(params, resource)
      case resource
        when :objectives
          items(resource)[objective_type(params[:type])].include?(params[:description])
        when :scenario_schedules
          items(resource).include?(params)
        else
          raise "unknown resource '#{resource}'. expecting :objectives, or :scenario_schedules"
      end
    end

    # @param resource [Symbol] :objectives, :scenario_schedules
    # @param params [Hash] for objectives
    # @option params [String] :type
    def count(resource, params=nil)
      return 0 unless @items
      params ? items(resource)[objective_type(params[:type])].count : items(resource).count
    end


    # @param params [Hash, String] String => a scenario schedule name
    # @option params [String] :type objective
    # @option params [String] :description objective
    # @param resource [Symbol] :objectives, :scenario_schedules
    # @return [Object]
    def item(params, resource)
      super(params, resource) do
        collection = items(resource)
        case resource
          when :objectives
            collection[objective_type(params[:type])][params[:description]]
          when :scenario_schedules
            collection[params]
          else
            raise "got resource: #{resource}. excepting only resources :objectives or :scenario_schedules"
        end
      end
    end

    private

    # @param cells [Array<Hash>] names of the cells to associate with the purposes
    # @option cell [String] :activity
    # @option cell [String] :event
    def associated_study_cells(cells)
      schedule = @current[:scenario_schedule]
      cells.collect do |cell|
        raise 'must specify both activity and event or none. got: cell.inspect' unless (cell[:activity] && cell[:event])
        begin
          schedule.study_cell(cell[:activity], cell[:event])
        rescue => e # couldn't find the cell, so add it
          schedule.add_study_cells([cell])
        end
        {study_cell_uuid: schedule.study_cell}
      end
    end

    # @param purposes [Array<Hash>] names of the purposes to associate with the cells
    # @option purpose [Symbol] :purpose_type ['endpoint', 'other']
    # @option purpose [String] :purpose name of associated purpose e.g. name of associated endpoint (optional)
    # @option purpose [String] :type [of an endpoint or other purpose type]
    # @option purpose [String] :subtype for endpoints
    # @option purpose [String] :activity name (optional)
    # @option purpose [String] :event name (optional)
    def associated_study_purposes(purposes)
      purposes.collect do |purpose|
        purpose_uuid = case purpose[:purpose_type]
                         when 'endpoint'
                           body = purpose[:purpose] ? {description: purpose[:purpose], type: purpose[:type], subtype: purpose[:subtype]} : nil
                           objective({objective_type: purpose[:objective_type], objective_description: purpose[:objective_description]}).
                               endpoint(body)
                         when 'other'
                           other_type(purpose[:type])
                         else
                           raise NotImplementedError, 'other purpose association types are not implemented, yet'
                       end
        {purpose_uuid: purpose_uuid, association_flag: 'all'}
      end
    end

    private

    def objective_type(type)
      "objective_type.#{convert_case(type) { |otype| {type: 'objective type', types: @objective_types} unless @objective_types.include?(otype) }}"
    end

    def other_type(type)
      @other_purpose_types[convert_case(type) { |otype|
                             {type: 'other purpose type', types: @other_purpose_types} unless @other_purpose_types.key?(otype)
                           }]
    end
  end
end
