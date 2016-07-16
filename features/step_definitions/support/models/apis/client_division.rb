module APIs
  # ClientDivision is a collection of Studies
  class ClientDivision < ResourceBase
    def initialize(app, user, name)
      # super ({'app'=>app, 'user'=> user, 'uuid'=> $config['utils']['apps'][app][name]}, Euresource::Studies)
      # super({},Euresource::Studies)
      super({'app' => app, 'user' => user, 'uuid' => $config['utils']['apps'][app][name]}, Euresource::Studies)
    end

    # @param name [String] name of the study to get from the client division or nil for the current study
    # @return
    def add_study(name)
      raise %Q{cannot find physical study name "#{name}" for logical study name "#{name}" in configuration} unless $config['utils']['apps'][@app].include?(name)
      name = $config['utils']['apps'][@app][name]
      @current = @items[name] = Study.new({'app' => @app, 'user' => @user}, index(params: {name: name, client_division_uuid: uuid}).first)
    end

    # @param name [String] name of study to switch context to
    # @return [Study]
    def study(name=nil)
      switch_to(name) if name
      @current
    end

    def update_study_references(body)
      sleep 1
      post!(body, {params: {uuid: self.study.uuid}, method: :update})
      sleep 1
    end

    def include?(name, resource=nil)
      super($config['utils']['apps'][@app][name], resource)
    end

    def item(name, resource=nil)
      super($config['utils']['apps'][@app][name], resource)
    end

    def clean
      @items.each_value { |study| study.clean } if @items
      destroy
    end

    def clean_all
      @items.each_value { |study| study.clean_all } if @items
      destroy
    end
  end
end
