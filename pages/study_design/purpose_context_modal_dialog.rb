require_relative 'study_design_context_dialog'

module StudyDesign
  class PurposeContextModalDialog < StudyDesignContextDialog
    attr_reader :data, :peas

    def initialize(title, data, panel = nil)
      super title
      @data = data
      @panel = panel || @@panel

    end

    begin
      @@panel = 'Purpose Cell Context'
    end

    element SELECTOR_MAPPING[@@panel]['Dialog']['title'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Dialog']['title'][$janus::SELECTOR]
    element SELECTOR_MAPPING[@@panel]['Container']['tab'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Container']['tab'][$janus::SELECTOR]
    element SELECTOR_MAPPING[@@panel]['Container']['panel'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Container']['panel'][$janus::SELECTOR]

    def save(content = @data)
      within @container do
        content.is_a?(Array) ? content.each { |data| update_content(data) } : update_content(content)
        click_button @save_button.capitalize
      end
    end

    private

    def update_content(data)
      purpose_row_title = data['type'].strip == "" ? "Other Purposes" : "#{data['type']} Endpoints"
      purpose_row_text = "#{data['description']} #{data['subtype']}"

      raise MIST::NotFound, "Unable to find Endpoint title \"#{purpose_row_title}\" in modal" unless page.has_content? purpose_row_title
      within(SELECTOR_MAPPING[@panel]['Purpose Row'], visible: true, wait: 30, text: purpose_row_text.strip) do
        find(SELECTOR_MAPPING[@panel]['Purpose Check'], visible: true, wait: 30).click
      end unless data['description'].strip == ""
    end
  end
end
