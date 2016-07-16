require_relative '../common/base_page'
require_relative 'sections'

module Imedidata

  class CreateNewSite < Common::BasePage

    section :header, Header, '#header'
    section :tab_navigation, TabNavigation, 'div[class="tabs"]'
    section :flash_notice, FlashNotice, '#flash-notice'

    element :study_study_sites, 'input[id$="attributes_0_name"]'
    element :site_number, 'input[id$="attributes_0_site_attributes_number"]'
    element :study_site_number, 'input[id$="attributes_0_number"]'
    element :site_notes, 'input[id$="attributes_0_notes"]'
    element :active_submit, '#save'
    element :inactive_submit, '.buttons [title="lbAction negative button"]'

    # Creates a new site with the following hash of params
    # @param [Object] params includes site name, site number and study_site number
    def new_site_create(params={})
      study_study_sites.set params[:site_name]
      site_number.set params[:site_number]
      study_site_number.set params[:study_site_number]
    end

    # Click "Save" button on create new site page
    def new_site_save
      active_submit.click
    end

    # Click "Cancel" button on create new site page
    def new_site_cancel
      inactive_submit.click
    end

  end
end
