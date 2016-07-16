require_relative 'common_page'

module Mccadmin

  class RolesSections < Common::BaseSection

    element :role_name, 'input[id*=name]'
    element :role_category, 'select[id*=role_category_oid]'
    elements :app_name, 'td[class^=app_roles] > label'
    elements :app_role, 'td[class^=app_roles]'
    element :remove_button, 'a[id^=remove_button]'
    element :permissions_dropdown, '' #TODO: As feature is not implemented yet

  end

  class EditConfigurationRoles < Mccadmin::CommonPage

    sections :roles_sections, RolesSections, 'div[class=overflow-scroll] > table > tbody > tr'

    elements :all_rows, 'tr[id*=role_group_for]'
    element :add_role_button, '#add_role_button'
    element :submit_button, '#configuration-type-roles-submit'
    element :cancel_button, '#configuration-type-roles-cancel'
    element :loading_image, 'div[id=loading-image][style*=block]'

    set_url_matcher /.dalton./

    def initialize
      super
    end

    # Add a new roles
    # @param params [Hash] fetches and sets the attributes from parameters provided
    def add_roles(params = {})
      params.each do |param|
        add_role_button.click
        # self.wait_until_loading_image_invisible # Wait for role row to appear
        # the above code is commented out until they fix an issue where the 'spinner' stopped appearing, need
        # to wait 1 second as workaround until we get that fix
        sleep 3
        roles_sections.last.role_name.set(param[:name])
        roles_sections.last.role_category.select(param[:category])
        select_app_role(param[:app_role_hash])
      end
      submit_button.click
    end

    # Selects role for app depending on the parameters provided
    # @param [Hash] app_role matches and sets the roles for respective apps
    # @option app_role [String] :app is used as the key
    # @option app_role [String] :role is used as the value
    def select_app_role(app_role = {})
      apps_in_page = roles_sections.last.app_name
      roles = roles_sections.last.app_role
      app_role.each do |app, role|
        apps_in_page.each_with_index do |apps_roles, index|
          if apps_roles.text==app
            raise "Role:#{role} found in the page!" unless roles.at(index).text.include?(role)
            roles.at(index).select(role)
            break
          end
        end
      end
    end

    # Removes roles based on name
    # @param name [String] used to match the role name; specify multiple roles separated by , (i.e. Role1, Role2, etc)
    def remove_roles(name)
      roles = name.split(',')

      roles.each do |r|
        roles_sections.each do |role|
          if role.role_name[:value]
            role.remove_button.click if role.role_name[:value].match(/\b#{r}\b/)
            sleep(1)
          end
        end
      end
      submit_button.click
    end

    # New Edit configuration roles (Because the elements on this page are not unique there was no cleaner way). more params
    # can be added if needed
    # @param params [Hash] fetches and sets the attributes from parameters provided
    def edit_configuration_roles(params = {})
      params.each do |param|
        add_role_button.click
        sleep 3
        last_row = all_rows.last
        within (last_row) do
          name = find(:css, 'input[id*=name]')
          name.set(param[:name])
          category = find(:css, 'select[id*=role_category_oid]')
          category.select(param[:category])
          # Selector for both rave role drop downs (since they are the same)
          rave_roles_row = all(:css, 'td[class^=app_roles]')
          # Drill into the Rave Security Role Drop down
          security_role = rave_roles_row.detect {|role| role.text.include? 'Rave Architect Security'}
          select_security_role = security_role.find(:css, 'select[id*=configuration_type_roles]')
          select_security_role.select(param[:rave_arch_security])
          # Drill into the Rave Arch Role Drop Down
          architect_role = rave_roles_row.detect {|role| role.text.include? 'Rave Architect Roles'}
          select_architect_role = architect_role.find(:css, 'select[id*=configuration_type_roles]')
          select_architect_role.select(param[:rave_arch_roles])
          # The apps are already set as an array iterate through each value to select each required checkbox
          # Drill into the Rave Module Drop Down
          rave_module = rave_roles_row.detect {|role| role.text.include? 'Rave Modules'}
          select_rave_module = rave_module.find(:css, 'select[id*=configuration_type_roles]')
          select_rave_module.select(param[:rave_modules])
          # Drill into the Rave EDC Drop Down
          rave_edc = rave_roles_row.detect {|role| role.text.include? 'Rave EDC'}
          select_rave_edc = rave_edc.find(:css, 'select[id*=configuration_type_roles]')
          select_rave_edc.select(param[:rave_edc])
          apps = param[:apps]
          apps.each do |select_app|
            role_to_select = rave_roles_row.detect {|role| role.text.include? select_app}
            select_role = role_to_select.find(:css, 'input[id*=configuration_type_roles]')
            select_role.click
          end
          # Open the permissions dropdwon first
          permissions_row = all(:css, 'td[class^=form-group]')
          permissions_menu = permissions_row.detect {|value| value.text.include? 'Permissions'}
          select_permission = permissions_menu.find(:css, 'button[class*=ui-multiselect]')
          select_permission.click
        end
        # Now in the permissions dropdown window select the required permissions
        permissions = param[:permissions]
        permissions.each do |permission_value|
          permissions_box_row = all(:css, 'div[class*=ui-multiselect-menu]')
          permissions_value = permissions_box_row.detect {|value| value.text.include? permission_value}
          select_permission_value = permissions_value.find(:css, "input[title=#{permission_value}]")
          select_permission_value.click
          puts "Added Permission - \"#{permission_value}\""
        end
      end
      submit_button.click
    end

  end
end
