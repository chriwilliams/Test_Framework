include JanusSelectorHelpers


def delete_visit(table)
  container = "Visit Row"

  steps %Q{
    Given I see the "Visits" panel within the "Visits Details" tab
    And I see the "New Visit" button within the "Visits Details" tab
  }
  table.hashes.collect { |data| $applications.study_design.send($helpers.to_page_file(container)).delete_visit_data(data) }
end


def select_type_in_visit(tag, value)
  container = find(tag)
  container.select(value)
end

def create_visit(table)
  steps %Q{
    Given I see the "Visits" panel within the "Visits Details" tab
    And I see the "New Visit" button within the "Visits Details" tab
    And I see the "Visits Quantity" input-field within the "Visits Details" tab
  }
  $applications
      .study_design
      .visits_details
      .add(
          table.hashes.inject([]) do |visits, row|
            visits << ({encounter_type: row['encounter type'], visit_type: row['visit type'], name: row['visit name']})
            visits
          end
      )
end

