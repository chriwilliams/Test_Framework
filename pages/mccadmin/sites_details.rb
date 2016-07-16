require_relative 'common_page'

module Mccadmin

  # Elements and methods for 'Study Detail page'
  class SitesDetails < Mccadmin::CommonPage
    #define elements on site details page
    element :site_details, '#study-site-details'
    element :cancel_ses, '#cancel-save-study-env-site'
    element :save_ses, '#save-study-env-site'

    element :mf_name, 'div[class^="site-medical-facility-name"]'
    element :cd_site_number, 'div[class^="client-division-site-number"]'
    element :site_pi_name, 'div[class^="site-pi-name"]'
    element :ses_site_number, '#study-env-site-number'
    element :pi_email, 'div[class^="site-pi-email"]'
    element :address, 'div[class^="site-address"]'


    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Updates the Study Environment Site number (study site number)
    # @param new_num [string] the new study site number
    def update_study_site_num(new_num)
      ses_site_number.set new_num
      save_ses.click
    end

  end
end
