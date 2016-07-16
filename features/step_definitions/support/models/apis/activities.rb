module APIs
  class Activities < ResourceBase
    def initialize(app, user)
      super({'app' => app, 'user' => user, 'uuid' => nil}, Euresource::Activities)
    end

    # @param opts [Hash|String] String - partial/complete name of an activity
    # @option opts [String] :name complete or partial name for search for [:take] number of activities
    # @option opts [Integer] :take number of activities to get
    # @option opts [Hash] :attributes additional filters for activities search
    # @return [Hash|Array] Hash {:name, :uuid}, or Array of Hashes of size [:take]
    def collect(opts)
      activities =
          case opts
            when String
              search_by_string(opts)
            when Hash
              if opts.key?(:take)
                search_by_take(opts[:name], opts[:take])
              elsif opts.key?(:attributes)
                search_by_attributes(opts[:name], opts[:attributes])
              else
                raise "invalid options hash supplied. expecting {:name, :attributes} or {:name, :take}. got: #{opts.inspect}"
              end
            else
              raise "invalid parameter type supplied. expecting a String or a Hash. got: #{opts.class}"
          end
      raise "no activities found with supplied criteria: #{opts.inspect}" if activities.nil? || activities.size == 0
      add_to_collection(activities)
    end

    def clean
      destroy
    end

    private

    def add_to_collection(activities)
      if activities.is_a?(Hash)
        @items[activities[:name]] = activities[:uuid]
      else
        activities.each { |activity| @items[activity[:name]] = activity[:uuid] }
      end
      activities
    end

    # @param name [String] partial or complete name
    # @return [Hash]
    #  * name: name supplied
    #  * uuid: activity uuid
    def search_by_string(name)
      {name: name, uuid: activities(name).first.uuid}
    end

    # @param name [String] partial or complete name
    # @param n [Integer] number of activities to take
    # @return [Array<Hash>]
    #  * name: name supplied
    #  * uuid: activity uuid
    def search_by_take(name, n)
      activities(name).take(n).collect.with_index { |activity, index| {name: "activity #{index+1}", uuid: activity.uuid} }
    end

    # @param name [String] partial or complete name
    # @param attributes [Hash] filter on activity attributes
    # @return [Hash]
    #  * name: name supplied
    #  * uuid: activity uuid
    def search_by_attributes(name, attributes)
      attributes.stringify_keys!
      activity = activities(name).detect do |activity|
        attributes.all? do |attribute|
          activity.attributes.any? do |activity_attribute|
            activity_attribute[1].is_a?(String) ?
                activity_attribute == attribute :
                activity_attribute.map(&:to_s) == attribute.to_a
          end
        end
      end
      {name: name, uuid: activity.uuid}
    end

    def activities(search_term)
      index(params: {search_term: search_term}) || []
    end
  end
end
