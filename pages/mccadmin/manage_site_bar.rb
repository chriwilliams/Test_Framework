require_relative 'common_page'

module Mccadmin
  class ManageSiteBar < Mccadmin::CommonPage

    element :side_bar_header_title, ".page-header-text>h3"
    element :side_bar_container_content, "#mcc-sidebar"
    element :side_bar_list_content, "#sidebar"

    elements :side_bar_list_link, "#sidebar a"

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    def select_nav(link)
      self.wait_until_side_bar_container_content_visible
      elm = side_bar_list_link.detect { |item| item.text.downcase.include? link.downcase }
      elm.click if elm
    end
  end
end
