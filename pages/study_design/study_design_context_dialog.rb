require_relative '../common/base_modal_dialogs'
require_relative 'selector_helper'
require_relative '../../lib/helpers/async_helper'
require_relative '../../lib/helpers/faker_helper'

module StudyDesign
  class StudyDesignContextDialog < Common::ModalDialog::Modal
    attr_reader :title, :panel, :save_button, :cancel_button

    SELECTOR_MAPPING = $janus::SELECTOR_MAPPING

    def initialize(title)
      @container = 'div.modal-dialog'
      @title = title
      @save_button = 'Save'
      @cancel_button = 'Cancel'
    end

    def save(content = nil)
      within @container do
        click_button @save_button
      end
    end

    def cancel(content = nil)
      within @container do
        click_button @cancel_button
      end
    end
  end
end
