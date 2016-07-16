require_relative 'common_page'


# TODO: this is the old "add site" page
module Mccadmin

  # Add Study Sites
  class AddSites < Mccadmin::CommonPage

    element :site_name, '#site_name'
    element :client_division_site_number, '#site_client_division_site_number'
    element :site_number, '#site_site_number'
    element :address_1, '#site_address_1'
    element :address_2, '#site_address_2'
    element :zip_code, '#site_postal_code'
    element :city, '#site_city'
    element :country, '#site_country'
    element :state, '#site_state'
    element :study_env, '#site_study_environment_uuid'
    element :pi_email, '#site_investigator_email'
    element :pi_first_name, '#site_investigator_first_name'
    element :pi_last_name, '#site_investigator_last_name'
    element :pi_role, '#site_investigator_role_uuid'
    element :add_site_submit, '#add-site-submit'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Add new study site
    # @param [Hash] params New site parameters required to create
    # @option params [String] 'site_name' Site Name
    # @option params [String] 'client_division_site_number' Client Division Site Number
    # @option params [String] 'site_number' Study Environment Site Number
    # @option params [String] 'address_1' Primary Address or Address 1
    # @option params [String] 'address_2' Secondary Address or Address 2
    # @option params [String] 'zip_code' Zip code
    # @option params [String] 'city' City
    # @option params [String] 'country' Country
    # @option params [String] 'state' State
    # @option params [String] 'study_env' Study Environment
    # @option params [String] 'pi_email' Primary Investigator Email
    # @option params [String] 'pi_first_name' Primary Investigator's First Name
    # @option params [String] 'pi_last_name' Primary Investigator's Last Name
    # @option params [String] 'pi_role' Primary Investigator's Role
    def add_site(params = {})
      site_name.set params['site_name']
      client_division_site_number.set params['client_division_site_number']
      site_number.set params['site_number']
      address_1.set params['address_1']
      address_2.set params['address_2'] if params['address_2']
      zip_code.set params['zip_code']
      city.set params['city']
      country.select(params['country'], match: :first)
      sleep 2 # Wait for the state to be active #TODO: find a way to remove this sleep ~MD
      state.select(params['state']) unless state.disabled?
      study_env.select(params['study_env'])
      pi_email.set params['pi_email']
      pi_first_name.set(params['pi_first_name'])
      pi_last_name.set(params['pi_last_name'])
      pi_role.select(params['pi_role'])
      add_site_submit.click
      sleep 10 # Wait to create a site
    end

  end

end