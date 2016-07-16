require_relative 'study_design_context_dialog'

module StudyDesign
  class QuantityContextModalDialog < StudyDesignContextDialog
    attr_reader :data

    def initialize(title, data, panel = nil)
      super title
      @data = data
      @panel = panel || @@panel

    end

    begin
      @@panel = 'Quantity & Optional/Conditional'
    end

    element SELECTOR_MAPPING[@@panel]['Dialog']['title'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Dialog']['title'][$janus::SELECTOR]
    element SELECTOR_MAPPING[@@panel]['Container']['tab'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Container']['tab'][$janus::SELECTOR]
    element SELECTOR_MAPPING[@@panel]['Container']['panel'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Container']['panel'][$janus::SELECTOR]

    element SELECTOR_MAPPING[@@panel]['Required Minimum Quantity']['label'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Required Minimum Quantity']['label'][$janus::SELECTOR]
    element SELECTOR_MAPPING[@@panel]['Required Minimum Quantity']['input'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Required Minimum Quantity']['input'][$janus::SELECTOR]

    element SELECTOR_MAPPING[@@panel]['Optional/Conditional']['label'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Optional/Conditional']['label'][$janus::SELECTOR]
    element SELECTOR_MAPPING[@@panel]['Optional/Conditional']['select'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Optional/Conditional']['select'][$janus::SELECTOR]

    element SELECTOR_MAPPING[@@panel]['Optional/Conditional Quantity']['label'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Optional/Conditional Quantity']['label'][$janus::SELECTOR]
    element SELECTOR_MAPPING[@@panel]['Optional/Conditional Quantity']['input'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Optional/Conditional Quantity']['input'][$janus::SELECTOR]

    element SELECTOR_MAPPING[@@panel]['Percentage of Subjects']['label'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Percentage of Subjects']['label'][$janus::SELECTOR]
    element SELECTOR_MAPPING[@@panel]['Percentage of Subjects']['input'][$janus::ELEMENT].to_sym, SELECTOR_MAPPING[@@panel]['Percentage of Subjects']['input'][$janus::SELECTOR]

    def save(content = @data)
      within @container do

        self.send("wait_until_#{SELECTOR_MAPPING[@panel]['Required Minimum Quantity']['input'][$janus::ELEMENT]}_visible")
        self.send(SELECTOR_MAPPING[@panel]['Required Minimum Quantity']['input'][$janus::ELEMENT].to_sym).set data['minimum'] unless data['minimum'].strip.empty?

        self.send("wait_until_#{SELECTOR_MAPPING[@panel]['Optional/Conditional']['select'][$janus::ELEMENT]}_visible")
        self.send(SELECTOR_MAPPING[@panel]['Optional/Conditional']['select'][$janus::ELEMENT].to_sym).select data['optional conditional type'] unless data['optional conditional type'].strip.empty?

        self.send("wait_until_#{SELECTOR_MAPPING[@panel]['Optional/Conditional Quantity']['input'][$janus::ELEMENT]}_visible")
        self.send(SELECTOR_MAPPING[@panel]['Optional/Conditional Quantity']['input'][$janus::ELEMENT].to_sym).set data['optional quantity'] unless data['optional quantity'].strip.empty?

        self.send("wait_until_#{SELECTOR_MAPPING[@panel]['Percentage of Subjects']['input'][$janus::ELEMENT]}_visible")
        self.send(SELECTOR_MAPPING[@panel]['Percentage of Subjects']['input'][$janus::ELEMENT].to_sym).set data['optional percentage'] unless data['optional percentage'].strip.empty?

        click_button @save_button.capitalize
      end
    end

  end
end
