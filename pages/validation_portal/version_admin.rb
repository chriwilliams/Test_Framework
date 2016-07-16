require_relative '../common/base_page'
require_relative 'sections'

module ValidationPortal
  class VersionAdmin < Common::BasePage

    section :header, Header, '#header'
    section :navigation, Navigation, '#navigation'

    element :unrelease_version_btn, '#unrelease_version'
    element :unrelease_modal_btn, '#unrelease-modal-link'

    set_url_matcher '\/admin'

    # Clicks unrelease version btn on page and modal
    def unrelease_version
      unrelease_version_btn.click
      unrelease_modal_btn.click
    end

  end
end
