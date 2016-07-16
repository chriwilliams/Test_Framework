require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class Visits < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'


    element :create_schedule_button, '#create_schedule_button' #button

    # create visits modal
    element :modal_visit_number, '#modal #treatment_schedule_number_of_visits' #text field
    element :modal_visit_interval, '#modal #treatment_schedule_default_visit_interval' #text field
    element :modal_default_window_minus, '#modal #treatment_schedule_window_minus' #text field
    element :modal_default_window_plus, '#modal #treatment_schedule_window_plus' #text field
    element :modal_rand_visit, '#modal #treatment_schedule_randomization_visit' #text field
    element :modal_save, '#modal #modal_save' #button
    element :modal_cancel, '#modal #cancel' #button

    #after creation
    element :add_element, '#add_visit' #button
    elements :visit_names, 'input.visit_name' #collection text fields
    elements :remove_btns, '.visit_name + a' #collection buttons/images
    elements :visit_expand_arrows, '.flyout_arrow' #collection expansion arrows
    elements :dosing_chk_boxes, '.checkbox input:nth-child(4)' #collection checkboxes
    elements :titration_levels, '.visits select' #collection dropdowns
    elements :rand_visit_row, 'tr:nth-child(4) .merged' #collection text

    element :save, '#save' #button
    element :cancel, '#cancel' #button

    # Create a visit schedule
    # @param visit_count [string] the number of visits
    # @param visit_offset [string] the visit offset
    # @param window_minus [string] the start window for a visit
    # @param window_plus [string] the end window for a visit
    # @param randomization_visit [string] the visit you wish to make the rand visit
    def create_visit_schedule(visit_count,visit_offset,window_minus,window_plus,randomization_visit)
      create_schedule_button.click
      modal_visit_number.set visit_count
      modal_visit_interval.set visit_offset
      modal_default_window_plus.set window_minus
      modal_default_window_minus.set window_plus
      modal_rand_visit.set randomization_visit
      modal_save.click
    end

    # Deletes the specified visit
    # @param visit [string] the name of the visit
    def delete_visit(visit)
      rand_index = find_rand_visit()
      visit_names.each_with_index do |visit_name, index|
        if visit_name.value == visit
          rand_index < index ? remove_btns[index-1].click : remove_btns[index].click
          page.driver.browser.switch_to.alert.accept
          save.click
        end
      end
    end

    # Finds which visit is the randomization visit in the schedule
    def find_rand_visit()
      rand_visit_row.each_with_index do |column, index|
        return index if column.text == "Randomization Visit"
      end
    end

    # Sets a visit as dosing or not
    # @param visit [string] name of the visit
    # @param dosing_option [bool] true or false for dosing
    def set_visit_dosing(visit, dosing_option)
      index = get_element_index(visit_names, visit, true, 'value')
      dosing_chk_boxes[index].set(dosing_option)
      save.click
    end

    # Set the titration level of a visit
    # @param visit [string] name of the visit
    # @param titration [string] titration level to select
    def set_titration_level(visit,titration)
      index = get_element_index(visit_names, visit)
      titration_levels[index].select titration
      save.click
    end

    # Updates a visit name
    # @param old_name [string] the visit you wish to update
    # @param new_nanme [string] the new name to set
    def update_visit_name(old_name, new_name)
      visit_names.each do |visit|
        if visit.value == old_name
          visit.set new_name
          save.click
          break
        end
      end

    end

  end
end

