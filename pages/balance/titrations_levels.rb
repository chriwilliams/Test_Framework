require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class TitrationLevels < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'

    element :name, '#titration_level_set_name' #text field
    element :scheduled, '#titration_level_set_use_scheduled_titrations_true' #radio button
    element :unscheduled, '#titration_level_set_use_scheduled_titrations_false' #radio button
    elements :level_names, 'div.level_name input' #collection text fields
    elements :initial_dose, 'div.initial_dose input' #collection radio fields
    elements :remove_buttons, 'div.remove_lvl_button a' #collection buttons
    element :add_level, '#add_level' #button

    element :save, '#update'
    element :cancel, '#cancel_button'

    # Adds a titration level set
    # @param level_name [string] the name of the level set
    # @param type [string] the type of level set (scheduled/unscheduled)
    # @param levels [string] the levels in the level set, delimited by ','
    # @param initial [string] the name of the level to be set as initial dose
    def add_titration_level_set(level_name,type,levels,initial)
      name.set level_name
      type.nil? scheduled.click : unschedule.click
      remove_buttons.each { |remove| remove.click }
      levels.split(',').each_with_index { |level,index|
        add_level.click
        level_names[index].set level
        initial_dose[index].click if initial==level
      }
      save.click
    end


  end
end