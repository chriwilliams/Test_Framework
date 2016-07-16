require_relative '../common/base_page'

module Coder
  class CreateGeneralRole < Common::BasePage

    element :security_module_menu, 'input[id*="Content_DdlModules"]'
    element :add_new, 'a[id$="LnkAddNewgridRole"]'
    element :is_active, 'input[id*="DXEditor1_I"]'
    element :enter_general_role_name, 'input[id*="DXEditor0_I"]'
    element :all_roles, 'input[id*="SelectionChxId"]'
    element :update_workflow, 'a[id$="BtnUpdateAction"]'

    # creates a general role with the name given.
    def create_general_role(role_name)
      sleep 2
      add_new.click
      enter_general_role_name.set role_name
      is_active.click
      page.first('.dxgvCommandColumnItem_Main_Theme').click
      sleep 3
    end

    # assigns ALL roles to a workflow.
    # @param workflow_name [String]
    def assign_general_role(workflow_name)
      assign_role workflow_name
      all_roles.click
      update_workflow.click
      sleep 2
    end

    private

    # this private method looks for an existing workflow in the workflow table
    # @param role [String]. Pass in the workflow name to select and assign role.
    def assign_role(role)
      found = false
      find('table[id$="gridRole_DXMainTable"] > tbody').all('tr').map do |row|
        row.all('td').map do |cell|
          cell_data = cell.text.strip
          if cell_data == role
            row.click
            found = true
          end
          break if found
        end
        break if found
      end
    end

  end
end
