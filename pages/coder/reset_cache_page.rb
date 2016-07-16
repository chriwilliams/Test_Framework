require_relative '../common/base_page'
require_relative 'sections'

module Coder
  class ResetCachePage < Common::BasePage

    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'

    element :reset_cache_button, 'a[id$="resetCache"]'
    element :flush_cache_all_button, 'a[id$="flushSegmentCache"]'
    element :flush_config_button, 'a[id$="flushSegmentConfiguration"]'
    element :flush_content_selector, 'select[id$="ddlObject"]'
    element :flush_success_message, '#ctl00_StatusPaneACG_SuccessPane > div > div > div > table'

    def flush_all_cache
      flush_cache_all_button.click
    end

    def flush_config
      flush_config_button.click
    end

    def reset_cache(selection)
      flush_content_selector.select(selection)
      reset_cache_button.click
    end

  end
end
