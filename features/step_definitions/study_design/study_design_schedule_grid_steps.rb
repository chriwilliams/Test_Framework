include JanusSelectorHelpers

When(/^I see the following "(Visits|Activities)" within the "(Schedule Grid Details)" panel:$/) do |type, container, table|
  view_schedule_colum_row_header(type, container, table)
end

When(/^I (check|uncheck) the following "(Cells)" within the "(Schedule Grid Details)" panel:$/) do |action, type, container, table|
  check_uncheck_cells(action, container, table)
end

And /^I (select|unselect) the following cell(?:s):$/ do |action, table|
  check_uncheck_cells(action, nil, table)
end

# table => | Activity | Visit |
And /^in Design Optimization in (Single|Multiple) Selection mode I (assign|unassign) purpose of type "([^"]+)"(?:, subtype "([^"]+)")? with description "([^"]+)" to the following cell(?:s):$/ do |mode, action, type, subtype, description, table|
  sleep 5
  data_table = case mode
                 when 'Multiple'
                   table.hashes.inject([['purpose', description, type, subtype]]) { |table, row| table << ['cell', row['Activity'], row['Visit'], nil] }
                 when 'Single'
                   table.hashes.inject([['Activity', 'Visit', 'Purpose', 'Type', 'Sub Type']]) { |table, row| table << [row['Activity'], row['Visit'], description, type, subtype] }
               end
  step %Q{In Design Optimization in #{mode} Selection mode I select the following cells and #{action} purpose:}, table(data_table)
end

And /^[iI]n Design Optimization in (Single|Multiple) Selection mode I select the following cells and ((?:un)?assign) purpose(?:s)?:$/ do |mode, action, table|
  step %Q{I click on the "#{mode} Selection" button within the "Schedule Grid Details" panel}
  case mode
    when 'Multiple'
      assign_purposes_to_cells(table, false)
    when 'Single'
      assign_purpose_to_cell(table, true)
  end
end

And /^I ((?:un)?assign) (purpose|quantity & optional conditional)(?: in ([sS]ingle|[mM]ultiple) Selection(?: mode)?)? to the following cells:$/ do |action, context, mode, table|
  mode ||= 'single'
  case action
    when /^assign$/i
      case context
        when /^purpose$/i
          assign_purpose_to_cell(table, mode)
        when /^quantity \& optional conditional$/i
          table.hashes.each {|data| $applications.study_design.schedule_grid_details.add_optional_conditional_to_cells(data)}
      end
  end
end


# (un)assigns all purposes to all cells
# assumes multiple selection mode is on
# ensures specified cells are selected
# @param table [Cucumber::Ast::Table] rows of purposes and cells
# @param action [Symbol] :assign or :unassign
def assign_purposes_to_cells(table, action)
  grid = $applications.study_design.schedule_grid_details
  modal = $applications.study_design.cell_modal_dialog

  purposes = table.raw.inject([]) do |collection, row|
    collection << {type: row[2], subtype: row[3], description: row[1], action: action.to_sym} if row[0] == 'purpose'
    collection
  end

  cell = table.rows.inject(nil) do |checked, row|
    if row[0] == 'cell'
      activity, visit = cell_coordinates(row[1], row[2])
      grid.click(activity, visit, :select) unless grid.selected?(activity, visit)
      checked ||= [activity, visit]
    end
    checked
  end

  grid.add_purposes *cell
  modal.assign_purpose_to(purposes)

  step %Q{I click the "Save" button within the "Cell Modal Dialog" panel}
  expect(page).to have_css("div[class=\"modal fade in context-cell-dialog\"][style=\"display: none;\"]", visible: false, wait: 10)
  sleep 1

  table.rows.each { |row| grid.checked?(*cell_coordinates(row[1], row[2])) if row[0] == 'cell' }
end

# (un)assigns a purpose to a cell
# assumes single selection mode is on
# ensures specified cells are checked
# @param table [Cucumber::Ast::Table] rows of cells
# @param action [Symbol] :assign or :unassign
def assign_purpose_to_cell(table, mode)
  case mode
    when /^single$/i
      table.hashes.collect { |data| $applications.study_design.schedule_grid_details.add_purpose_to_cells(data, true) }
    when /^multiple$/i
      $applications.study_design.schedule_grid_details.add_purpose_to_cells(table.hashes, false)
  end
end

And /^[iI]n Design Optimization in Single Selection mode I assign quantity "(\d+)" to the following cell(?:s)?:$/ do |quantity, table|
  step %Q{In Design Optimization in Single Selection mode I assign quantity to the following cells:},
       table(
           table.hashes.inject([['Activity', 'Visit', 'Qty']]) do |collection, row|
             collection << [row['Activity'], row['Visit'], quantity]
           end
       )
end

And /^[iI]n Design Optimization in Single Selection mode I assign quantity to the following cell(?:s)?:$/ do |table|
  grid = $applications.study_design.schedule_grid_details
  modal = $applications.study_design.cell_modal_dialog
  # table => | Activity | Visit | Qty |
  table.hashes.each do |row|
    activity, visit = cell_coordinates(row['Activity'], row['Visit'])
    raise Capybara::ExpectationNotMet, "first select the cell before using this step on it" unless grid.checked?(activity, visit)
    grid.add_quantities(activity, visit)
    modal.set_quantity_to(row['Qty'])
    step %Q{I click the "Save" button within the "Cell Modal Dialog" panel}
    expect(page).to have_css("div[class=\"modal fade in context-cell-dialog\"][style=\"display: none;\"]", visible: false, wait: 10)
    sleep 1
  end
end

Then(/^I\s?(?:should)? see the following "(Cells)" are (uncheck|check)(?:ed) within the "(Schedule Grid Details)" panel:$/) do |type, action, container, table|
  verify_cell_state(action, container, table)
end

# @param type [String] 'Visits' or 'Activities'
# @param container [String] ??
# @param table [Cucumber::Ast::Table] from the step definition
def view_schedule_colum_row_header(type, container, table)
  cat = {"Visits" => "Visits Column", "Activities" => "Activity Row"}
  sel = {"Visits" => "visits", "Activities" => "activities"}

  list = $applications.study_design.scenario.get_list_text_content(cat[type], 'list', container)
  table.hashes.each_with_index do |attributes|
    selection = sel[type]
    expect(list.index(attributes[selection])).not_to be_nil
  end
end

# checks or unchecks a schedule grid cell
# @param action [String] 'select' or 'unselect' for now
# @param container [String] not used for now
# @param table [Cucumber::Ast::Table] from the step definition
def check_uncheck_cells(action, container=nil, table)
  preserve = table.hashes.size > 1
  sleep 10
  $applications
      .study_design
      .schedule_grid_details
      .click(table.hashes.collect { |row| cell_coordinates(row['activity'], row['visit'], preserve) }, 'Cell', action.to_sym)
  @preserved_list = nil
end

# verifies that a schedule grid cell is checked or unchecked
# @param action [String] 'select' or 'unselect' for now
# @param container [String] not used for now
# @param table [Cucumber::Ast::Table] from the step definition
def verify_cell_state(action, container=nil, table)
  table.hashes.each do |row|
    activity, visit = cell_coordinates(row['activity'], row['visit'])
    expect($applications.study_design.schedule_grid_details.checked?(activity, visit)).to be (action == "check" ? true : false)
  end
end

# @param activity [String] activity description
# @param visit [String] visit description
# @param preserve_list [Boolean] keep activities and visits collections
# @return [Array] [activity row index, visit column index]
# @raise [String] if one of the indexes is nil
def cell_coordinates(activity, visit, preserve_list=false)
  row = schedule_grid_collection('Activities', activity, preserve_list)
  col = schedule_grid_collection('Visits', visit, preserve_list)
  unless row and col
    msg = []
    msg << "No Cell found at #{activity} / #{visit} because"
    msg << "activity \"#{activity}\"" unless row
    msg << "#{msg.size > 1 ? "and " : "" }visit \"#{visit}\"" unless col
    msg << "not found"
    raise msg.join(" ")
  end
  return row + 1, col + 1
end

# @param collection [String] 'Activities' or 'Visits'
# @param item [String] the description to find in the colllection
# @param preserve_list [Boolean] keep activities and visits collections
# @return [Integer] the index of the 'item' in the collection
# @raise [NIL] if any error is thrown, just return nil
def schedule_grid_collection(collection, item, preserve_list=false)
  occurrence = (item[/^.+ \>\[(\d+)\]$/, 1] || 1).to_i - 1
  name = item[/^(.+) \>\[\d+\]$/, 1] || item
  $async.wait_with_retries(timeout: 2) do
    index = (preserve_list ?
        preserve_list(collection).each_with_index.select { |item, i| item[0] == name } :
        $applications.study_design.schedule_grid_details.get_list_content(collection)
            .each_with_index.select { |item, i| item.text == name }
    ).at(occurrence)
    raise Capybara::ElementNotFound unless index
    index[1]
  end
rescue
  nil
end

# @param list [String] name of the list to preserve
# @return [Array] an array of activities or visits to prevent continuous reading the DOME in specific cases.
def preserve_list(list)
  unless @preserved_list and @preserved_list.has_key? list
    @preserved_list ||= {}
    @preserved_list.merge!({list => $applications.study_design.schedule_grid_details.get_list_content(list)
                                        .each_with_index.map { |item, i| [item.text, i] }})
  end
  @preserved_list[list]
end
