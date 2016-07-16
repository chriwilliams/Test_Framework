require_relative '../common/base_page'

module Rave
  class Workflow < Common::BasePage

    element :review_group_name, 'input[id$=ReviewGroupName]'
    element :review_group_active, 'input[id$=ReviewGroupActive]'
    element :marking_group_active, 'input[id$=MarkingGroupActive]'
    element :marking_group_name, 'input[id$=MarkingGroupName]'
    element :active_marking_group_value, 'select[id$=ddlMarkingGroupCategory]'
    element :review_group_table, 'table[id$="Content_ReviewGroupsGrid"] > tbody'
    element :marking_group_table, 'table[id$="MarkingGroupsGrid"] > tbody'

    set_url_matcher /\/medidatarave\//i

    def initialize
      raise 'The page was not loaded' unless self.displayed?(30)
    end


    # this method verifies that coder review group is available before uploading a draft
    # @param review_group [String] by default it's looking at coder review group
    def verify_coder_review_group(review_group = 'Coder Review Group')
      click_link('Configuration')
      found_value = false
      review_group_table.all('tr').map do |row|
        row.all('td').map do |cell|
          cell_data = cell.text.strip
          if cell_data.downcase == 'review group 9'
            row.all('a').first.click
            update_review_group('Coder Review Group', true)
            found_value = true
          elsif cell_data.downcase == 'coder review group'
            puts 'Coder Review Group is available. Good to go...'
          end
          break if found_value
        end
        break if found_value
      end
      found_value
    end

    # this method verifies that coder marking group is available before uploading a draft
    # @param marking_group [String] by default it's looking at coder review group
    def verify_coder_marking_group(marking_group = 'site from system')
      click_link('Configuration')
      found_value = false
      marking_group_table.all('tr').map do |row|
        row.all('td').map do |cell|
          cell_data = cell.text.strip
          if cell_data.downcase == 'marking group 9'
            row.all('a').first.click
            update_marking_group('site from system', 'Auto-Query to Site')
            found_value = true
          elsif cell_data.downcase == 'site from system'
            puts 'Coder Marking Group is available. Good to go...'
          end
          break if found_value
        end
        break if found_value
      end
      found_value
    end


    private

    # updates the values of a review group in edit mode
    # @param name [String] new name of the review group
    # @param active [boolean] by default it's true
    def update_review_group(name, active = true)
      review_group_name.set name
      unless active == 'false'
        review_group_active.set true
      end
      click_link('Update')
      sleep 2
    end

    # updates the values of a marking group in edit mode
    # @param name [String] new name of the review group
    # @param active_category [String] value to be selected from drop-down
    def update_marking_group(name, active_category)
      marking_group_name.set name
      active_marking_group_value.select active_category
      click_link('Update')
      sleep 2
    end


  end
end
