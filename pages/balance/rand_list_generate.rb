require_relative '../common/base_page'
require_relative 'sections'

module Balance

  class RandListGenerate < Common::BasePage

    section :main_nav, MainNav, '#mainnav'
    section :sub_nav, SubNav, '#subnav'
    section :randomization_lists, Table, '#randomization_lists'

    element :name, '#randomization_list_generator_name' #input field

    elements :arm_names, '#study_arms #name' #collection text fields
    elements :arm_ratios, '#study_arms input.input_short' #collection input fields

    element :numbers_random, '#randomization_list_generator_rand_id_rule_1' #radio button
    element :numbers_sequential, '#randomization_list_generator_rand_id_rule_2' #radio button
    element :range, '#randomization_list_generator_range_selected' #checkbox
    element :starting_number, '#randomization_list_generator_rand_id_range_from' #text field
    element :ending_number, '#randomization_list_generator_rand_id_range_till'

    element :site_num_start, '#randomization_list_generator_site_range_start' #text field
    element :site_num_end, '#randomization_list_generator_site_range_end' #text field

    elements :block_size_checkboxes, '#acceptable_block_sizes .short_checkbox' #collection checkboxes
    elements :block_sizes, '#acceptable_block_sizes td:nth-child(2)' #collection
    elements :number_of_blocks, '#acceptable_block_sizes .input_short' #collection input fields
    elements :subject_slots, '#acceptable_block_sizes td:nth-child(4)' #collection text fields

    element :randseed_checkbox, '#randomization_list_generator_randseed_selected' #checkbox
    element :randseed, '#randomization_list_generator_randseed' #input field

    element :generate_list_btn, '#update' #button
    element :cancel, '.negative.button' #button

    # Generates a rand list
    # @param list_name [string] name of the rand list
    # @param list_block_size [string] size of the blocks in the rand list
    # @param options_table [table] table of rand list options
    def generate_list(list_name,options_table)
      name.set list_name
      #set all checkboxes off before you start
      block_size_checkboxes.each do |checkbox|
        checkbox.set(false)
      end

      options_table.raw.each do |row|
        case row[0]
          when 'Arm'
            arm_names.each_with_index do |arm,index|
              arm_ratios[index].set row[2] if arm.text == row[1]
            end
          when 'Rand ID'
            if row[1] == 'Sequential'
              numbers_sequential.click
              starting_number.set row[2] if row[2] != ''
            elsif row[1] == 'Random'
              numbers_random.click
              if row[2] != ''
                range.set(true)
                starting_number.set row[2]
                ending_number.set row[3]
              end
            end
          when 'Sites'
            site_num_start.set row[1]
            site_num_end.set row[2]
          when 'Block Size'
            block_sizes.each_with_index do |block,index|
              if block.text==row[1]
                block_size_checkboxes[index].set(true)
                number_of_blocks[index].set row[2]
              end
              break if index >= block_size_checkboxes.size()-1
            end
          when 'Rand Seed'
            randseed_checkbox.set(true)
            randseed.set row[1]
        end
      end
      generate_list_btn.click
    end


  end
end