module APIs
  # representation of a study
  class Study < ResourceBase
    attr_reader :euresource

    def initialize(opt, study)
      @euresource = study
      @my_signature = "#{`whoami`.chop}_#{`hostname`.chop}_#{$config['utils']['apps'][opt['app']].include?('parallel_run') ? Process.pid : 1}"
      super(opt.merge({'uuid' => study.uuid}), Euresource::DesignScenarios)
    end

    def phase_uuid
      @euresource[:phase_uuid]
    end

    def primary_indication_uuid
      @euresource[:primary_indication_uuid]
    end

    def secondary_indication_uuid
      @euresource[:secondary_indication_uuid]
    end

    # @param params [Hash, String] params to create a new scenario, name of the scenario
    # @option params [String] :name
    # @option params [String] :description
    # @option params [String] :notes
    def add_design_scenario(params)
      body = params.dup
      body = {name: body} if body.is_a? String
      @current = @items[body[:name]] = DesignScenario.new(@app, @user, post(body, params: {study_uuid: @uuid}))
    end

    # @param friendly_name [String] name of scenario to switch context to
    # @return [DesignScenario]
    def design_scenario(friendly_name=nil)
      switch_to(friendly_name) if friendly_name
      @current
    end

    # @param friendly_name [String] name of scenario
    # @param resource [Symbol] not implemented in this object
    # @return [Boolean]
    def include?(friendly_name, resource=nil)
      items(resource).keys.detect { |stamped_name| to_friendly(stamped_name) == friendly_name }
    end

    # @param friendly_name [String] scenario name
    # @param resource [Symbol] not implemented in this object
    # @return [Object] either a collection or a UUID
    def item(friendly_name, resource=nil)
      super(friendly_name, resource) do
        @items[items(resource).keys.detect { |stamped_name| stamped_name if to_friendly(stamped_name) == friendly_name }]
      end
    end

    def clean
      @items.each_pair do |stamped_name, scenario|
        delete(scenario.uuid)
        scenario.clean
        purge(to_friendly(stamped_name))
      end if @items
      destroy
    end

    def clean_all
      index(params: {study_uuid: self.uuid}).each { |scenario| delete(scenario.uuid) }
      destroy
      @items = {}
    end

    # deletes any previous study
    # @param friendly_name [String] scenario name
    def purge(friendly_name)
      index(params: {study_uuid: uuid}).each do |scenario|
        if to_friendly(scenario.name) == friendly_name
          delete(scenario.uuid)
          @items.delete(scenario.name)
        end
      end
    end

    # @param name [String] scenario name
    # @return [String] scenario name without signature or timestamp
    def to_friendly(name)
      friendly_name = name[/#{@my_signature}_([^"]+)Scenario \d+/, 1]
      friendly_name ? friendly_name : (name[/#{@my_signature}_(Scenario \d+)/, 1] || name)
    end

    # @param name [String] scenario name without signature or timestamp
    # @return [String] scenario name with signature and timestamp
    def stamp_it(name)
      name[/^.*Scenario \d+$/] ? "#{@my_signature}_#{name}" : "#{@my_signature}_#{name}#{$faker.scenario}"
    end

    def api_show
      show(@uuid)
    end

    def update_reference(pbody)
      body = {'phase_uuid' => 'f2c3902e-6b17-40de-9b2a-d54d72c26481', 'primary_indication_uuid' => 'f3a9904b-63d7-11e1-b86c-0800200c9a66', 'secondary_indication_uuid' => 'f3a99045-63d7-11e1-b86c-0800200c9a66'}
      puts put(body, {params: @uuid, method: 'update'}, :studies)
    end
  end
end
