require_relative 'home'
require 'capybara'
require 'capybara/session'

module StudyDesign
  class VisitRow < VisitsDetails
    set_url_matcher /.\/visits*/

    def initialize
      @klass = VISIT_ROW
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end


    element SELECTOR_MAPPING[VISIT_ROW]['Encounter Type']['form'][ELEMENT].to_sym, SELECTOR_MAPPING[VISIT_ROW]['Encounter Type']['form'][SELECTOR]
    element SELECTOR_MAPPING[VISIT_ROW]['Encounter Type']['dropdown'][ELEMENT].to_sym, SELECTOR_MAPPING[VISIT_ROW]['Encounter Type']['dropdown'][SELECTOR]

    element SELECTOR_MAPPING[VISIT_ROW]['Visit Type']['form'][ELEMENT].to_sym, SELECTOR_MAPPING[VISIT_ROW]['Visit Type']['form'][SELECTOR]
    element SELECTOR_MAPPING[VISIT_ROW]['Visit Type']['dropdown'][ELEMENT].to_sym, SELECTOR_MAPPING[VISIT_ROW]['Visit Type']['dropdown'][SELECTOR]

    element SELECTOR_MAPPING[VISIT_ROW]['Visit Name']['form'][ELEMENT].to_sym, SELECTOR_MAPPING[VISIT_ROW]['Visit Name']['form'][SELECTOR]
    element SELECTOR_MAPPING[VISIT_ROW]['Visit Name']['input-field'][ELEMENT].to_sym, SELECTOR_MAPPING[VISIT_ROW]['Visit Name']['input-field'][SELECTOR]

    element SELECTOR_MAPPING[VISIT_ROW]['Delete Visit']['button'][ELEMENT].to_sym, SELECTOR_MAPPING[VISIT_ROW]['Delete Visit']['button'][SELECTOR]


    # Add New Visit
    # @param data [String], data object
    def add_visit(data)
      update_visit_data(data, all(SELECTOR_MAPPING[VISIT_ROW][SELECTOR]).count - 1 )
    end

    # Methods tha update data for a particular visit
    # @param data [Hash] data content to look up
    # @param index [integer?] optional data index for look up
    def update_visit_data(data, index=nil)
      $async::wait_with_retries(errors: Selenium::WebDriver::Error::StaleElementReferenceError, timeout: 0.5, attempts: 10) do
        find_visit_row(data, index).find( SELECTOR_MAPPING[VISIT_ROW]['Encounter Type']['dropdown'][SELECTOR]).select(data['encounter type'])
      end if data.has_key? 'encounter type'

      $async::wait_with_retries(errors: Selenium::WebDriver::Error::StaleElementReferenceError, timeout: 0.5, attempts: 10) do
        find_visit_row(data, index).find(SELECTOR_MAPPING[VISIT_ROW]['Visit Type']['dropdown'][SELECTOR]).select(data['visit type'])
      end if data.has_key? 'visit type'

      $async::wait_with_retries(errors: Selenium::WebDriver::Error::StaleElementReferenceError, timeout: 0.5, attempts: 10) do
        find_visit_row(data, index).find(SELECTOR_MAPPING[VISIT_ROW]['Visit Name']['input-field'][SELECTOR]).set(data['visit name'])
      end if data.has_key? 'visit name'
    end

    # Method that deletes a given visit data
    # @param data [Hash] data content to
    def delete_visit_data(data)
      sleep 2
      if data.has_key? 'index'
        all(SELECTOR_MAPPING[VISIT_ROW]['Delete Visit']['button'][SELECTOR])[data['index'].to_i].click
      else
        find_visit_row(data).find(SELECTOR_MAPPING[VISIT_ROW]['Delete Visit']['button'][SELECTOR]).click
      end
      if data['is linked']
        sleep 1
        action_hash = SELECTOR_MAPPING[VISIT_ROW]['Delete'] || {}
        Common::ModalDialog::ChoiceDialog.new('div.modal-dialog', action_hash['title'], 'Yes', action_hash['description']).exit_alert unless /^(?:|No)$/i .match data['is linked']
      end
    end

    private
    # Method that finds visit
    # @param data [Hash] data content to look up
    # @param index [integer?] optional data index for look up
    # @return [WebElement] visit, or an exception is thrown.
    def find_visit_row(data, index = nil)
      if index
        all(SELECTOR_MAPPING[VISIT_ROW][SELECTOR])[index]
      elsif data.has_key? 'index'
        all(SELECTOR_MAPPING[VISIT_ROW][SELECTOR])[data['index']].to_i
      else
        row_index = ((data.has_key? 'visit name') ? (visit = occurrence(data['visit name']))['index'] : 0)
        begin

          #TODO: Needs to find a less expensive approach to resolve this
          content = all(SELECTOR_MAPPING[VISIT_ROW][SELECTOR])
          data.keys.each do |key|
            case key
              when 'encounter type'
                content = content.select{|row| row.find( SELECTOR_MAPPING[VISIT_ROW]['Encounter Type']['dropdown'][SELECTOR]).all("option", visible: true, wait: 10).find(&:selected?).text == data['encounter type']}
              when 'visit type'
                content = content.select{|row| row.find( SELECTOR_MAPPING[VISIT_ROW]['Visit Type']['dropdown'][SELECTOR]).all("option", visible: true, wait: 10).find(&:selected?).text == data['visit type']}
              when 'visit name'
                content = content.select{|row| row.find( SELECTOR_MAPPING[VISIT_ROW]['Visit Name']['input-field'][SELECTOR]).value == visit['name']}
            end
          end
          return content[row_index]
        rescue Exception => e
          raise("Unable to find visit row. See: #{e.message}")
        end

      end
    end

  end
end
