module JanusSelectorHelpers

  TAGS = 'accordion|title|section|button|label|fields?|items?|input\-fields?|labelled fields?|iframe|bar|tabs?|tab bar|table|textbox|dropdown|toggle|link|toggle\-button|text|panel|container|box|column|headers?|text\-content|list|form|toolbar|first container|new container|value|description'
  CONTAINERS = 'page|pane|panel|accordion|container|form|section|textarea|frame|tab bar|bar|tabs?|table|bar|list|editor|first container|new container|box'
  TITLES = 'text|label|title|name|header|tab|term|bar|table'

  IMPLEMENTED = ["Study Identification", "Objectives/Endpoints", "Scenario Tab", "Add Objective", "Schedule",
                 "Schedules", "Schedule Tab", "Activities Details", "Visits Details", "Schedule Details Grid"]
end

TAG = JanusSelectorHelpers::TAGS
CONTAINER = JanusSelectorHelpers::CONTAINERS
TITLE = JanusSelectorHelpers::TITLES
IMPLEMENTED = JanusSelectorHelpers::IMPLEMENTED


def click_on_activity_in_results(search, selection)
  (all("#activity-search-results tbody tr td:nth-of-type(2) dl dt", text: search).detect{|e| e.text == selection}).click
rescue
  raise %Q{using search term "#{search}", activity "#{selection}" not found}
end
