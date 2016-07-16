require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class FilterUsers < Common::BasePage

    section :header, Header, '.HeaderIconBar'

    element :last_name, 'input[id$="Content_LastNameBox"]'
    element :login_id, 'input[id$="Content_LoginBox"]'
    element :site_name, 'input[id$="Content_SiteFilterBox"]'
    element :site_group_select, 'select[id$=Content_SiteGroupDDL]'
    element :role_select, 'select[id$="Content_RoleDDL"]'
    element :study_select, 'select[id$="Content_StudyDDL"]'
    element :environment_select, 'select[id$=Content_AuxStudiesDDL]'
    element :auth_select, 'select[id$="Content_AuthenticatorDDL"]'
    element :search_button, 'input[id$="Content_FilterImgBtn"]'
    element :new_user_link, 'a[id$=NewUserLink]'
    elements :users_table, 'table[id$="Content_UserGrid"] > tbody > tr'

    set_url_matcher /\/medidatarave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # This function searches and verifies user assignment
    # @param [Hash] params contains values to search for user, study, site, role
    # @option params [String] :last_name Last Name
    # @option params [String] :login Username
    # @option params [String] :site Site name
    # @option params [String] :site_group Site Group
    # @option params [String] :role User role
    # @option params [String] :study Study Name
    # @option params [String] :environment Study Environment
    # @option params [String] :authenticator Authenticator
    def user_search(params = {})
      last_name.set params[:last_name] unless nil_or_empty? params[:last_name]
      login_id.set params[:login] unless nil_or_empty? params[:login]
      site_name.set params[:site] unless nil_or_empty? params[:site]
      site_group_select.select unless nil_or_empty? params[:site_group]
      role_select.set params[:role] unless nil_or_empty? params[:role]
      study_select.select params[:study] unless nil_or_empty? params[:study]
      unless nil_or_empty? params[:environment]
        if params[:environment].downcase == 'prod'
          env = 'Live: Prod'
        else
          env = 'Aux: ' + params[:environment].gsub(/[\W]/, '') # sanitize study string
        end
        environment_select.select env
      end
      auth_select.select params[:authenticator] unless nil_or_empty? params[:authenticator]
      search_button.click
      sleep 5 #TODO: Figure out a way to remove this ~MD
    end

    #Opens the details for specified user on User Admin page.
    #@param user_name[String] the name of the user (value from Log In column)
    def user_details_open(user_name)
      row = users_table.detect { |item| item.text.include? user_name }
      column = row.all(:css, 'td').detect { |item| item.text == user_name } if row
      if column
        row.all(:css, 'img[src$="arrow_right.gif"]').first.click
      else
        raise "User: '#{user_name}' does not exist on the page."
      end
    end

    #Clicks on link to add new user on User Admin page.
    def add_new_user()
      new_user_link.click
    end
  end
end
