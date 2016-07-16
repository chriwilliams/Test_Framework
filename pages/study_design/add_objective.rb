module StudyDesign
  class AddObjective < Scenario

    set_url_matcher /.studydesign./

    element :add_objective_header, SELECTOR_MAPPING[ADD_OBJECTIVE]['header'][SELECTOR]
    element :objective_type_dropdown, SELECTOR_MAPPING[ADD_OBJECTIVE]['Objective Type']['dropdown'][SELECTOR]
    elements :objective_type_dropdown_options, SELECTOR_MAPPING[ADD_OBJECTIVE]['Objective Type']['dropdown']['options'][SELECTOR]
    element :save_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['Save']['button'][SELECTOR]
    element :cancel_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['Cancel']['button'][SELECTOR]

    elements :editors, %Q{div[id^="addObj"] iframe[id$="_ifr"]}
    element :editor_toolbar, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['toolbar'][SELECTOR]
    elements :editor_buttons, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['buttons'][SELECTOR]
    elements :editor_button_labels, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['labels'][SELECTOR]
    element :editor_textarea, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['textarea'][SELECTOR]

    element :undo_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['Undo']['button'][SELECTOR]
    element :redo_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['Redo']['button'][SELECTOR]
    element :bold_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['Bold']['button'][SELECTOR]
    element :italic_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['Italic']['button'][SELECTOR]
    element :lalign_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['Left Align']['button'][SELECTOR]
    element :calign_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['Center']['button'][SELECTOR]
    element :ralign_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['Right Align']['button'][SELECTOR]
    element :jalign_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['Justify']['button'][SELECTOR]
    element :blist_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['Bullet List']['button'][SELECTOR]
    element :nlist_button, SELECTOR_MAPPING[ADD_OBJECTIVE]['editor']['Numbered List']['button'][SELECTOR]

    def has?(name, tag)
      element_is_visible(name, tag, ADD_OBJECTIVE)
    end

    def click(name, tag)
      if ['Save', 'Cancel'].include?(name)
        click_on_button(name, tag, ADD_OBJECTIVE)
      else
        editor_button_labels.detect { |elem| elem['aria-label'] == name }.click
      end
    end

    def contains?(name, tag, value)
      case tag
        when 'dropdown'
          get_select_options(name, tag, ADD_OBJECTIVE).include? value
        when 'toolbar' # con only check editor buttons
          editor_button_labels.detect { |elem| elem['aria-label'] == value } != nil
        else
          get_text_value(name, tag, ADD_OBJECTIVE)
      end
    end

    def count(name, tag)
      case name
        when 'editor' # can only count editor buttons
          editor_buttons.count
      end
    end

    def disabled?(name, tag)
      if ['Save', 'Cancel'].include?(name)
        eval(SELECTOR_MAPPING[ADD_OBJECTIVE][name]['button'][ELEMENT]).disabled?
      else
        button = editor_button_labels.detect { |elem| elem['aria-label'] == name }
        button['aria-disabled'] == 'true' if button
      end
    end

    def enabled?(name, tag)
      !disabled?(name, tag)
    end

    def add(attributes)
      set(nil, 'dropdown', attributes['type'])
      set(nil, 'textarea', attributes['description'])
    end


    def get_description(editor)
      begin
        evaluate_script("#{editor}.activeEditor.focus();")
        value =  evaluate_script("#{editor}.activeEditor.getContent();")
        evaluate_script("#{editor}.activeEditor.focus(false);")
      rescue
        value = nil
      end
      return value
    end

    def set_description(value)
      within_frame(find("div[id^=\"addObj\"] iframe#desc2_ifr")) { page.find_by_id('tinymce').native.send_keys value }
    end

    def set(name, tag, value)
      case tag
        when 'dropdown' then set_select_option('Objective Type', 'dropdown', ADD_OBJECTIVE, value)
        when 'textarea' then set_description(value)
      end
      true
    end
  end
end
