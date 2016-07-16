require_relative 'home'

module StudyDesign
  class StudyIdentification < Scenario
    set_url_matcher /.studydesign./


    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      @klass = STUDY_IDENTIFICATION
      @description = nil
      # Wait for the page to be displayed with MAX_WAIT_ON_LOAD seconds timeout
      raise 'The page was not loaded' unless self.displayed?($janus::MAX_WAIT_ON_LOAD)
    end

    # the labels
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Phase'][LABEL][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Phase'][LABEL][SELECTOR]
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Primary Indication'][LABEL][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Primary Indication'][LABEL][SELECTOR]
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Protocol ID'][LABEL][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Protocol ID'][LABEL][SELECTOR]
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Secondary Indication'][LABEL][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Secondary Indication'][LABEL][SELECTOR]
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Study Design Notes'][LABEL][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Study Design Notes'][LABEL][SELECTOR]
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Study Name'][LABEL][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Study Name'][LABEL][SELECTOR]

    # the fields
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Phase'][INPUT_FIELD][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Phase'][INPUT_FIELD][SELECTOR]
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Primary Indication'][INPUT_FIELD][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Primary Indication'][INPUT_FIELD][SELECTOR]
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Protocol ID'][INPUT_FIELD][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Protocol ID'][INPUT_FIELD][SELECTOR]
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Secondary Indication'][INPUT_FIELD][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Secondary Indication'][INPUT_FIELD][SELECTOR]
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Study Design Notes'][INPUT_FIELD][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Study Design Notes'][INPUT_FIELD][SELECTOR]
    element SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Study Name'][INPUT_FIELD][ELEMENT].to_sym, SELECTOR_MAPPING[STUDY_IDENTIFICATION]['Study Name'][INPUT_FIELD][SELECTOR]

    # Looks up whether an object is visible or exists at all.
    # @param name [String][ELEMENT].to_sym, the name of the object item to find.
    # @param tag [String][ELEMENT].to_sym, the tag value of the object item.
    # @return true if object is visible otherwise false.
    # @param name [String|Hash] String => field name, Hash => [field => value]
    def has?(name, tag=nil)
      case name
        when String
          has_one(name, tag)
        when Hash
          has_many(name)
        else
          raise Capybara::ExpectationNotMet, "expecting name to be a String or Hash"
      end
    end

    # Method that finds whether element is [read only] or disabled
    # @param name [String] [ELEMENT].to_sym, the name of the object item to find.
    # @param tag [String] the tag value of the object item.
    # @return [Boolean]
    def readonly?(name, tag=nil)
      wait_visibility(name, 'input-field', STUDY_IDENTIFICATION)
      eval(SELECTOR_MAPPING[STUDY_IDENTIFICATION][name]['input-field'][ELEMENT]).disabled?
    end

    # Method that finds whether element is [read / write]
    # @param name [String], the name of the object item to find.
    # @param tag [String], the tag value of the object item.
    # @return [Boolean]
    def read_write?(name, tag)
      !readonly?(name, tag)
    end

    private

    def has_one(name, tag)
      lcheck = element_is_visible(name, 'label', STUDY_IDENTIFICATION) if tag =~ /label/
      fcheck = element_is_visible(name, 'input-field', STUDY_IDENTIFICATION) if tag =~ /field/
      (!lcheck.nil? && !fcheck.nil?) ? lcheck && fcheck : lcheck || fcheck
    end

    def has_many(fields)
      fields.each_pair do |field, value|
        css = SELECTOR_MAPPING[STUDY_IDENTIFICATION][field][INPUT_FIELD][SELECTOR]
        unless page.find(css).value == value
          raise Capybara::ExpectationNotMet, %Q{expected field "#{field}" to have value "#{value}". got "#{find(css).value}"}
        end
      end
    end
  end
end
