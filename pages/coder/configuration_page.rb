require_relative '../common/base_page'
require_relative 'sections'

module Coder
  class ConfigurationPage < Common::BasePage
    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'

    element :coding_tab, 'a[id$="tab0"]'
    element :dictionary_tab, 'a[id$="tab1"]'
    element :max_suggestion_return, 'input[id$="TxtMaxSuggestionReturn"]'
    element :coding_task_page_size, 'input[id$="TxtCodingTaskPageSize"]'
    element :coding_sug_page_size, 'input[id$="TxtCodingSuggestionPageSize"]'
    element :force_primary_path_checkbox, 'input[id$="ChkForcePrimaryPathSelection"]'
    element :search_limit_reclass_results, 'input[id$="TxtSearchLimitReclassificationResult"]'
    element :synonym_creation_policy, 'select[id$="ddlSynonymCreationPolicyFlag"]'
    element :require_reconsider_upon_reclassification, 'input[id$="BypassReconsiderUponReclassify"]' # checkbox checked implies reconsideration is not necessary
    element :save_updated_configuration, 'a[id$="SubmitCodingConfig"]'
    element :cancel_updated_configuration, 'a[id$="CancelCodingConfig"]'


    # this method is only used for medDRA dictionary. It sets  a checkbox 'on' and selects a value from the drop-down.
    # @param force_primary_path [String] can be On or Off.
    # @param active [String] can be active, or inactive
    def set_meddra_configuration(force_primary_path = 'ON', active)
      coding_tab.click
       if force_primary_path.upcase == 'ON'
         force_primary_path_checkbox.set true
       elsif force_primary_path.upcase == 'OFF'
         force_primary_path_checkbox.set false
       end
      case active.downcase
        when 'active'
          synonym_creation_policy.select 'Always Active'
        when 'inactive'
          synonym_creation_policy.select 'Never Active'
        else
          raise 'Unrecognized value passed. Your synonym can either be active or inactive. By default it\'s active'
      end
      save_updated_configuration.click
      sleep 10
    end
  end

end

