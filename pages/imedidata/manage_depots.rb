require_relative '../common/base_page'
require_relative 'sections'

module Imedidata

  class ManageDepots < Common::BasePage

    section :header, Header, '#header'

    element :add_depot, '#add_depots'
    element :create_depot, '#create_study_depot'

    elements :table_depot_names, '#depots_list td:nth-child(1)'
    elements :table_assign_users, '#depots_list td:nth-child(9) a'
    elements :table_user_emails, '#depot_user_assignments_table td:nth-child(3)'
    elements :table_user_checkbox, '#depot_user_assignments_table td:nth-child(1)'
    element :assign_user_submit, '#submit_button'

    elements :modal_depot_names, '#new_invitation #add_depot_list td:nth-child(2) label'
    elements :modal_depot_checkboxes, '#new_invitation #add_depot_list td:nth-child(1) input'

    element :modal_add, '#add_depots_to_study_button'


    # Add depots to a study
    # @param depots[string] depot names delimited by ','
    def add_depots(depots)
      add_depot.click
      sleep 1
      depot_list = depots.split(',')
      depot_list.each do |d|
        index = get_element_index(modal_depot_names, d)
        modal_depot_checkboxes[index].set(true)
      end
      modal_add.click
    end


    # Assigns users to depot
    # @param depot[string] the depot to select
    # @param users[string] the users email to assign, delimited by ','
    def assign_users_to_depot(depot, users)
      depot_index = get_element_index(table_depot_names, depot)
      table_assign_users[depot_index].click
      users.split(',').each do |user|
        user_index = get_element_index(table_user_emails, user)
        table_user_checkbox[user_index].click
        assign_user_submit.click
      end

    end

  end

end