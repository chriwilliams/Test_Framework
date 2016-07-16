require_relative 'common_page'

module Mccadmin

  # Study Sites Search
  class AddStudySites < Mccadmin::CommonPage

    element :add_new_site, '#cannot-find-site'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

  end

end
