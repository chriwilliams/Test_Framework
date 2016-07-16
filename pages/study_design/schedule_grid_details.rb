require_relative 'scenario'
require_relative 'home'
require_relative 'purpose_context_modal_dialog'
require_relative 'quantity_context_modal_dialog'
require_relative 'study_design_section'

module StudyDesign
  class CellModalContextSection< StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING

    element SELECTOR_MAPPING['Cell Context Menu']['Purpose']['link'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Cell Context Menu']['Purpose']['link'][$janus::SELECTOR]
    element SELECTOR_MAPPING['Cell Context Menu']['Quantity']['link'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING['Cell Context Menu']['Quantity']['link'][$janus::SELECTOR]
  end

  class ActivityModalContextSection< StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING
  end


  class VisitModalContextSection< StudyDesignSection
    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING
  end

  class ScheduleGridDetails < Scenario
    set_url_matcher /.\/schedule-grid*/

    def initialize
      @klass = SCHEDULE_GRID
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    element SELECTOR_MAPPING[SCHEDULE_GRID]['Schedule Grid']['table'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_GRID]['Schedule Grid']['table'][SELECTOR]
    element SELECTOR_MAPPING[SCHEDULE_GRID]['Schedule Grid']['panel'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_GRID]['Schedule Grid']['panel'][SELECTOR]

    elements SELECTOR_MAPPING[SCHEDULE_GRID]['Activities']['list'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_GRID]['Activities']['list'][SELECTOR]
    elements SELECTOR_MAPPING[SCHEDULE_GRID]['Visits']['list'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_GRID]['Visits']['list'][SELECTOR]

    element SELECTOR_MAPPING[SCHEDULE_GRID]['Multiple Selection']['toggle-button'][ELEMENT].to_sym, SELECTOR_MAPPING[SCHEDULE_GRID]['Multiple Selection']['toggle-button'][SELECTOR]
    section SELECTOR_MAPPING[SCHEDULE_GRID]['Context Menu']['dropdown'][ELEMENT].to_sym, CellModalContextSection, SELECTOR_MAPPING[SCHEDULE_GRID]['Context Menu']['dropdown'][SELECTOR]

    CELLS_MATRIX = SELECTOR_MAPPING[SCHEDULE_GRID]['Cells Matrix'][SELECTOR]
    CELLS_ROW = SELECTOR_MAPPING[SCHEDULE_GRID]['Cells Row'][SELECTOR]
    CELLS_CELL = SELECTOR_MAPPING[SCHEDULE_GRID]['Cells Cell'][SELECTOR]

    def add_optional_conditional_to_cells(data)
      add_context_to_cells(data, 'Quantity', '', true)
    end

    def add_purpose_to_cells(data, single_mode = true)
      add_context_to_cells(data, 'Purpose', '', single_mode)
    end

    # @param name [String|Integer|Array] String ?? or Integer activity row index or Array [ [row, column], ... ]
    # @param tag [String|Integer] String ?? or Integer visit column index
    # @param action [Symbol] :check | :uncheck | :select | :unselect
    def click(name, tag, action=nil)
      if tag == 'Cell' or tag.is_a? Integer
        click_on_cells(name, tag, action)
      elsif tag == 'button' and name =~ /Multiple|Single/
        if page.has_css?("button.btn-multiselect-toggle.btn-multiselect-#{toggle_button(name)}", wait: 1)
          find("button.btn-multiselect-toggle.btn-multiselect-#{toggle_button(name)}").click
          unless page.has_css?("button.btn-multiselect-toggle.btn-multiselect-#{toggle_button(toggle_button(name))}", wait: 10)
            raise Capybara::ExpectationNotMet, "Multiple Selection button not clicked"
          end
        end
      else
        click_on_button(name, tag, SCHEDULE_GRID)
      end
      # TODO: the next step should ensure that AngularJS is ready
    end

    def get_list_content(name, tag='list')
      super name, tag, SCHEDULE_GRID
    end

    # @param activity [Integer] row index
    # @param visit [Integer] column index
    # @return [Boolean] true if cell at activity, visit is unchecked
    def unchecked?(activity, visit)
      raise Capybara::ExpectationNotMet, "activity(#{activity}) and visit(#{visit}) need to be non-nil values" unless activity and visit
      cell = cell(activity, visit)
      cell.has_no_css?('.fa-spinner.fa-spin.disabled') and !cell[:class].include?('cell-checked')
    end

    # @param activity [Integer] row index
    # @param visit [Integer] column index
    # @return [Boolean] true if cell at activity, visit is checked
    def checked?(activity, visit)
      raise Capybara::ExpectationNotMet, "activity(#{activity}) and visit(#{visit}) need to be non-nil values" unless activity and visit
      cell = cell(activity, visit)
      cell.has_no_css?('.fa-spinner.fa-spin.disabled') and cell[:class].include?('cell-checked')
    end

    # @param activity [Integer] row index
    # @param visit [Integer] column index
    # @return [Boolean] true if cell at activity, visit is unselected
    def unselected?(activity, visit)
      raise Capybara::ExpectationNotMet, "activity(#{activity}) and visit(#{visit}) need to be non-nil values" unless activity and visit
      cell = cell(activity, visit)
      cell.has_no_css?('.fa-spinner.fa-spin.disabled') and !cell[:class].include?('.cell-selected')
    end

    # @param activity [Integer] row index
    # @param visit [Integer] column index
    # @return [Boolean] true if cell at activity, visit is selected
    def selected?(activity, visit)
      raise Capybara::ExpectationNotMet, "activity(#{activity}) and visit(#{visit}) need to be non-nil values" unless activity and visit
      cell = cell(activity, visit)
      cell.has_no_css?('.fa-spinner.fa-spin.disabled') and cell[:class].include?('.cell-selected')
    end

    # opens the modal dialog with purpose tab active
    # @param activity [Integer|Array] row index
    # @param visit [Integer] column index
    def add_purposes(activity, visit)
      context_menu_open(activity, visit, 'purpose')
    end


    # opens the modal dialog with quantity tab active
    # @param activity [Integer] row index
    # @param visit [Integer] column index
    def add_quantities(activity, visit)
      context_menu_open(activity, visit, 'quantity')
    end

    private

    # @param activity [Integer,Array] Integer: row index, Array: collection of Array[activity index, visit index]
    # @param visit [Integer] column index
    def click_on_cells(activity, visit=nil, verify=true, action)
      cells(activity, visit).each_with_index do |cell, i|
        checked = checked?(cell[0], cell[1])
        if (action == :select and !checked) or (action == :unselect and checked)
          sleep 1
          cell(cell[0], cell[1]).click
          sleep 1
          cell(cell[0], cell[1]).has_no_css?('.fa-spinner.fa-spin.disabled')
        end
      end
    end

    # @param activity [Integer,Array] Integer: row index, Array: collection of Array[activity index, visit index]
    # @param visit [Integer] column index
    # @return [Array] [activity index, visit index]
    def cells(activity, visit=nil)
      cells = if activity.is_a?(Array)
                activity
              elsif activity.is_a? Integer and visit.is_a? Integer
                [[activity, visit]]
              else
                raise "no cells specified. expecting name as [[activity, visit],...] or name as activity and tag as visit"
              end
      cells.each do |cell|
        raise Capybara::ExpectationNotMet, "invalid cell row, column array. expecting [row, column]" unless cell.size == 2
        raise Capybara::ExpectationNotMet, "activity or visit index is nil" if cell.detect { |v| v.nil? }
      end
      cells
    end

    def add_context_to_cells(data, menu, title, single_mode = true)
      if single_mode
        self.toggle_click('Multiple Selection','toggle-button', false)
      else
        self.toggle_click('Multiple Selection','toggle-button', true)
      end

      if data.is_a?(Array)
        data.each{|content| cell(find_index(content['activity'], 'Activities'), find_index(content['visit'], 'Visits')).click }
        cell = cell(find_index(data.last['activity'], 'Activities'), find_index(data.last['visit'], 'Visits'))
      else
        cell = cell(find_index(data['activity'], 'Activities'), find_index(data['visit'], 'Visits'))
      end
      
      $async.wait_with_retries(timeout: 30, attempts: 5) do
        cell.hover
        SitePrism::Waiter.wait_until_true { cell.has_css?("div.menu-side", visible: true, wait: 10) }

        within cell do
          find("div.menu-side", visible: true, wait: 10).click
        end

        self.send("wait_until_#{SELECTOR_MAPPING[SCHEDULE_GRID]['Context Menu']['dropdown'][ELEMENT]}_visible")
      end

      self.send("#{SELECTOR_MAPPING[SCHEDULE_GRID]['Context Menu']['dropdown'][ELEMENT]}").invoke_click(menu.capitalize, 'Cell Context Menu', 'link')

      within(:xpath, '//html/body') do
        SitePrism::Waiter.wait_until_true { find('div.modal-dialog', visible: true).visible?}
      end

      case menu
        when /^purpose$/i
          PurposeContextModalDialog.new(title, data, 'Purpose Cell Context').save
        when /^quantity$/i
          QuantityContextModalDialog.new(title, data, 'Quantity & Optional/Conditional').save
      end
    end

    # @param activity [Integer] row index
    # @param visit [Integer] column index
    def context_menu_open(activity, visit, item)
      schedule_grid_table.click
      cell = cell(activity, visit)
      sleep 1
      cell.hover
      sleep 1
      raise Capybara::ElementNotFound, "cell[#{activity}, #{visit}] not selected" unless cell.has_css?("div.menu-side", visible: true, wait: 10)
      sleep 1
      cell.find("div.menu-side", visible: true, wait: 10).click
      sleep 1
      cell.find("div.menu-side", visible: true, wait: 10).click if cell.has_css?("div.menu-side", visible: true, wait: 10)
      sleep 1
      # 2015.R1 => find(".cell-context-menu ul.study-cell-context li.#{item}-label a", visible: true, wait: 10).click
      find("#context-menu-cell li.#{item}-label a.cell-context-request", visible: true, wait: 10).click
      raise Capybara::ExpectationNotMet, "cell modal dialog not found" unless page.has_css?('div.modal-content.context-cell-content', visible: true, wait: 10)
    end

    def find_index(item, collection)
      find = (occurrence(item))
      index = find['index']
      item = find['name']
      $async.wait_with_retries(timeout: 5) do
        get_list_content(collection)
            .each_with_index.select { |elem, i| elem.text == item }
            .at index
      end[1] + 1
    end

    # @param activity [Integer] row index
    # @param visit [Integer] column index
    # @return [Capybara::Element] the cell at row[activity], column[visit]
    def cell(activity, visit)
      find(CELLS_CELL.sub(/<activity>/, activity.to_s).sub(/<visit>/, visit.to_s), visible: true, wait: 10)
    end

    # @param name [String] 'Multiple Selection' or 'Single Selection'
    # @return [String] the opposite of name [multiple=>single, single=>multiple]
    def toggle_button(name)
      name.downcase.include?('multiple') ? 'single' : 'multiple'
    end
  end
end
