require_relative '../common/base_page'
require_relative 'sections'

module Coder
  class CreateWorkflowRole < Common::BasePage
    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'

    element :add_new, '[id$=LnkAddNewgridWorkflowRole] > b > i'
    element :enter_workflow_name, 'input[id*="DXEditor0"]'
    element :active_workflow, 'input[id*="DXEditor1"]'
    element :all_roles, 'input[id*="SelectionChxId"]'
    element :update_workflow, 'a[id$="BtnUpdateAction"]'

    # creates a workflow with the name given. System will not allow to create a duplicate workflow
    # @param workflow_name [String]
    def create_workflow(workflow_name)
      add_new.click
      enter_workflow_name.set workflow_name
      active_workflow.click
      page.first('.dxgvCommandColumnItem_Main_Theme').click
      sleep 3
    end

    # assigns ALL roles to a workflow.
    # @param workflow_name [String]
    def assign_workflow_role(workflow_name)
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
      find('table[id$="WorkflowRole_DXMainTable"] > tbody').all('tr').map do |row|
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