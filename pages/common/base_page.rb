require 'site_prism'
require 'uri'
require_relative 'base'

module Common
  class BasePage < SitePrism::Page

    include Common
    elements :all_anchor_elements, 'a'
    element :modal, 'div[class=modal-dialog]'

    def maximize_browser
      page.driver.browser.manage.window.maximize
    end

    # navigates to a specified page
    def navigate_to(url)
      self.visit url
    end

    # returns current page url
    def current_url
      page.driver.browser.current_url
    end

    # refreshes the current page.
    def refresh_browser
      page.driver.browser.navigate.refresh
      page.driver.browser.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertPresentError
    end

    # Method allows to add parameters to url string, and returns the new url string
    # @param url [String] the url of the page
    # @param param_name [String] the name of the parameter to include in url
    # @param param_value [String] the value of the parameter to include in url
    # @return [String] new url with parameters added
    def add_param_to_url(url, param_name, param_value)
      uri = URI(url)
      params = URI.decode_www_form(uri.query || []) << [param_name, param_value]
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end

    # Click to attach a file using file upload
    # @param path [string] path to the file to be uploaded
    # @param selector [string] the selector you want to identify the object with
    def bootstrap_attach_file(path, selector)

      # Selenium likes absolute paths when attaching a file.
      path = File.expand_path(path)

      # Do this to expose the file input field so it is clickable
      Capybara.current_session.driver.execute_script(
          "$('#{selector}').css('position','relative').css('opacity','1').height(10).width(10)")
      attach_file(selector[1..-1], path)
      Capybara.current_session.driver.execute_script("$('#upload-file').css('display','inline')")

    end

    # Click to attach a file to modal using file upload
    # @param path [string] path to the file to be uploaded
    # @param selector [string] the selector you want to identify the object with
    def bootstrap_attach_file_to_modal(path, selector)

      # Selenium likes absolute paths when attaching a file.
      path = File.expand_path(path)

      # Do this to expose the file input field so it is clickable
      # hardcoded for now
      Capybara.current_session.driver.execute_script(
        "$('.modal-dialog #{selector}').css('position','relative').css('opacity','1').height(1).width(10)")
      field = modal.find(:file_field, selector[1..-1], visible: false)
      field.set(path)
      Capybara.current_session.driver.execute_script("$('.fileupload-exists').css('display','inline')")
    end
  end
end
