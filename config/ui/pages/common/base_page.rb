module Common
  class BasePage < SitePrism::Page

    ### UI ELEMENTS AND FUNCTIONS ###

    elements :all_anchor_elements, 'a'

    # def take_screenshot
    #   filename = Shamus.current.current_step.add_inline_asset(".png") if defined? Shamus
    #   filename ||= './FirstFramework_run.log'
    #   self.save_screenshot(filename)
    # end

    # Verify page based on title or url.
    # url is ignored if title is specified
    # Exact match for title, substring match for url
    def verify_page(page_title=nil, page_url=nil)
      if page_title
        raise "Title of the page is not #{page_title}" unless self.title == page_title
      elsif page_url
        raise "URL of the page does not contain #{page_url}" unless self.current_url.to_s.include?(page_url.downcase)
      else
        raise "Provide either title or part of url to verify page"
      end
    end

    def verify_link_exists(link)
      raise "link #{link} doesn't exist" unless find_link(link)
    end

    def find_link(link)
      all_anchor_elements.detect { |inner_item| inner_item.text == link }
    end

    def click_link(link)
      if (link_to_click = find_link(link))
        link_to_click.click
      else
        raise "link #{link} doesn't exist"
      end
    end

  end
end
