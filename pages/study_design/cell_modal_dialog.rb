require_relative 'home'

module StudyDesign
  class CellModalDialog < Scenario
    set_url_matcher /.studydesign./

    def initialize
      @klass = CELL_MODAL_DIALOG
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[CELL_MODAL_DIALOG][ELEMENT].to_sym, SELECTOR_MAPPING[CELL_MODAL_DIALOG][SELECTOR]
    element SELECTOR_MAPPING[CELL_MODAL_DIALOG]['Cancel']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[CELL_MODAL_DIALOG]['Cancel']['button'][SELECTOR]
    element SELECTOR_MAPPING[CELL_MODAL_DIALOG]['Save']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[CELL_MODAL_DIALOG]['Save']['button'][SELECTOR]

    element SELECTOR_MAPPING[CELL_MODAL_DIALOG]['tab bar'][ELEMENT].to_sym, SELECTOR_MAPPING[CELL_MODAL_DIALOG]['tab bar'][SELECTOR]
    element SELECTOR_MAPPING[CELL_MODAL_DIALOG]['tab bar']['tabs'][ELEMENT].to_sym, SELECTOR_MAPPING[CELL_MODAL_DIALOG]['tab bar']['tabs'][SELECTOR]

    elements SELECTOR_MAPPING[CELL_MODAL_DIALOG]['Purposes']['table'][ELEMENT].to_sym, SELECTOR_MAPPING[CELL_MODAL_DIALOG]['Purposes']['table'][SELECTOR]

    elements SELECTOR_MAPPING[CELL_MODAL_DIALOG]['Activity Quantity']['input'][ELEMENT].to_sym, SELECTOR_MAPPING[CELL_MODAL_DIALOG]['Activity Quantity']['input'][SELECTOR]

    # @param type [String] type of purpose 'Primary', 'Secondary', 'Tertiary', 'Other'
    # @param description [String] purpose description text
    # @param subtype [String] for purpose types other than 'Other'
    def has?(type, description, subtype)
      purpose(purpose_items(to_type(type)), description, subtype) ? true : false
    end

    # @param type [String] type of purpose 'Primary', 'Secondary', 'Tertiary', 'Other'
    # @param description [String] purpose description text
    # @param subtype [String] for purpose types other than 'Other'
    def checked?(type, description, subtype)
      purpose = purpose(purpose_items(to_type(type)), description, subtype)
      raise %Q/Could not find purpose: { type: "#{type}", description: "#{description}", subtype: "#{subtype}"}/ unless purpose
      purpose[:checkbox].checked?
    end

    def click(name, tag)
      click_on_button name, tag, CELL_MODAL_DIALOG
    end

    # @param assignments [Array[Hash]] {:type, :subtype, :description, action: :assign|:unassign}
    # @option assignment [String] :type
    # @option assignment [String] :subtype if :type is 'Other', then set subtype to nil
    # @option assignment [Symbol] :action :assign or :unassign
    def assign_purpose_to(assignments)
      assignments = [assignments] if assignments.is_a? Hash
      assignments.each do |assignment|
        item = purpose(purpose_items(to_type(assignment[:type])), assignment[:description], assignment[:subtype])
        raise %Q/Could not find purpose: { type: "#{assignment[:type]}", description: "#{assignment[:description]}", subtype: "#{assignment[:subtype]}"}/ unless item
        do_it = ((assignment[:action] == :assign && !item[:checkbox].checked?) or (assignment[:action] == :unassign && item[:checkbox].checked?))
        raise "purpose #{assignment[:type]}#{(assignment[:type].include?('Other')) ? (", " + assignment[:subtype]) : nil}, #{assignment[:description]} is already #{assignment[:action]}ed." unless do_it
        item[:checkbox].click
      end
    end

    def set_quantity_to(quantity)
      raise Capybara::ElementNotFound, "" unless find('.quantity-panel-container', visible: true, wait: 10)
                                                       .has_css?('input.quantity-value', visible: true, wait: 10)
      find('.quantity-panel-container input.quantity-value', visible: true, wait: 10).set quantity
      raise Capybara::ExpectationNotMet, "" unless find('.quantity-panel-container input.quantity-value').value == quantity
      sleep 1
    end

    private

    # @param type [String] the type of purpose
    # @return [Array] purposes for this type
    def purpose_items(type)
      rows = list
      titles = rows.each_with_index.select { |row, i| row[:class].include? 'title' }
      title_index = titles.index { |title| title[0].text == type }
      type_index = titles[title_index][1]
      boundary = ( titles[title_index+1] ) ? titles[title_index+1][1] : purpose_table.size
      rows.slice(type_index+1, boundary-(type_index+1))
    end

    # @param list [Array] a slice of one type of purpose
    # @param description [String] the purpose description
    # @param subtype [String] for purposes other than 'Other', when 'Other' this should be nil
    # @return [Hash] {:type, :subtype, :description}
    def purpose(list, description, subtype)
      purpose = nil
      list.detect do |item|
        purpose = item.all("td").inject({}) { |fields, field| fields.merge! to_pair(field) }
        purpose[:description] == description && purpose[:subtype] == subtype
      end if list
      purpose
    end

    # @param field [String] a column name (field) in the purpose table
    # @return [Hash]
    def to_pair(field)
      case field[:class]
        when 'purpose-check-td'
          { checkbox: field.find('input.purpose-check') }
        when 'purpose-cell'
          { description: field.text }
        when 'purpose-type-cell'
          { subtype: field.text }
        when 'purpose-empyt-cell'
          { subtype: nil }
        else
          raise %Q{purpose item field class "#{field[:class]}" not implemented}
      end
    end

    # @param type [String] purpose type 'Primary', 'Secondary', 'Tertiary', 'Other'
    # @return [String] ' Endpoints' or ' Purposes' appended
    def to_type(type)
      type + ( type == 'Other' ? " Purposes" : " Endpoints" )
    end

    def list
      raise Capybara::ExpectationNotMet, "Purpose table rows not found" unless find('div.purpose-table-container').has_css?('table.purpose-table tr')
      all('div.purpose-table-container table.purpose-table tr').to_a
    end

  end
end
