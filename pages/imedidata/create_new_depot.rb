require_relative '../common/base_page'
require_relative 'sections'

module Imedidata

  class CreateNewDepot < Common::BasePage

    section :header, Header, '#header'

    element :name, '#depot_name'
    element :number, '#depot_number'
    element :country, '#depot_country'
    element :save, '.buttons button[type="submit"]'


    # Creates a depot
    # @param depot_name [string] the name of the depot
    # @param depot_number [string] the number of the depot
    # @param depot_country [string] the country of the depot
    def create_depot(depot_name, depot_number, depot_country)
      name.set depot_name
      number.set depot_number
      country.select depot_country
      save.click
    end

  end
end

