require 'capybara'
require 'selenium/webdriver'
require 'site_prism'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require_relative 'download_helper.rb'

# Module sets up the browser and webdriver prior to running a scenario or feature file.
module CapybaraHelper
  attr_reader :resolution, :capybara_config, :logging, :language, :log_dir, :download_path

  # Initializes Capybara with browser with preferences and profile
  #
  # @param config [Hash] an object containing browser config parameters to setup Capybara
  # @param logging [Hash] a hash parameter containing logging information such as file and log level
  # @param selected_browser [Symbol] the selected browser to use. Accepted values are :chrome, :firefox, :safari, :ie, :internet_explorer
  #
  # @return [Symbol] the browser information connected to webdriver.
  #
  def self.setup(config, logging, selected_browser = :chrome)
    @capybara_config = config
    @logging = logging
    @log_dir = File.expand_path("..", logging['filepath'])
    @resolution = "#{@capybara_config['screen_resolution']['width']}x#{@capybara_config['screen_resolution']['height']}"
    @download_path = (@capybara_config.include? 'download_dir') ? @capybara_config['download_dir']: '.'

    return (supported_browsers.include? selected_browser) ? selected_browser : :chrome
  end

  # Method that configures Capybara with provided browser
  #
  # @param chosen_browser [Symbol] the browser to config
  #
  def self.config(chosen_browser)
    Capybara.configure do |config|
      config.default_driver = @capybara_config['default_driver']
      config.javascript_driver = chosen_browser
      config.current_driver = chosen_browser
      config.run_server = @capybara_config['run_server']
      config.default_selector = @capybara_config['default_selector']
      config.app_host = @capybara_config['app_host']
      config.app = @capybara_config['app']
      config.default_wait_time = @capybara_config['default_wait_time']
    end

    unless $using_saucelabs || @capybara_config['default_driver'].to_s == 'poltergeist'
      screen_w = @capybara_config['screen_resolution']['width'].to_s.to_i
      screen_h = @capybara_config['screen_resolution']['height'].to_s.to_i
      window = Capybara.current_session.driver.browser.manage.window
      window.resize_to screen_w, screen_h
      window.move_to 0, 0
    end

    SitePrism.configure do |config|
      config.use_implicit_waits = true
    end

  end

  private

  # Method that setups all indivisual browsers.
  def self.supported_browsers
    supported_browsers = [:firefox, :chrome, :ie, :safari]
    supported_browsers.each do |browser|

      @language = 'no,en-us,en,eng,jpn,deu'
      Capybara.register_driver browser do |app|
        case browser
          when :firefox
            Capybara::Selenium::Driver.new(app, browser: browser, profile: firefox_profile)
          when :chrome
            Capybara::Selenium::Driver.new(app, browser: browser, service_log_path: File.join(@log_dir, 'chromedriver.log'), prefs: chrome_preferences)
          when :ie, :internet_explorer
            url = ENV['APP_HOST']
            Capybara::Selenium::Driver.new(app, browser: browser, url: url, desired_capabilities: ie_caps)
          when :safari
            opts = Selenium::WebDriver::Safari::Options.new
            opts.data_dir = @capybara_config['download_dir']
            opts.clean_session?
            Capybara::Selenium::Driver.new(app, browser: browser, url: url, desired_capabilities: opts.to_capabilities)
        end
      end
    end
    return supported_browsers
  end

  # Method that sets firefox profile
  #
  # @return [Hash] It returns the profile information for firefox
  #
  def self.firefox_profile
    profile = "Selenium::WebDriver::Firefox::Profile".constantize.new
    profile['browser.download.dir'] = @download_path
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = 'images/jpeg, application/pdf, application/xls, application/xlsx'
    profile['pdfjs.disabled'] = true
    profile['intl.accept_languages']=@language
    profile.native_events = true
    profile.log_file = File.join(@log_dir, 'firefox.log')
    return profile
  end

  # Method that sets chrome preferences
  #
  # @return [Hash] It returns the preference information for chrome
  #
  def self.chrome_preferences
    return prefs = {
        intl: {accept_languages: @language},
        download: {prompt_for_download: false, default_directory:@download_path},
        "disable-popup-blocking" => true
    }
  end

  # Method that sets internet explorer desired capabilities
  #
  # @return [Hash] It returns the desired capabilities information for internet explorer
  #
  def self.ie_caps
    caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
    caps["os"] = "Windows"
    caps["browserstack.debug"] = "true"
    caps['resolution'] = @resolution
    caps['logFile'] = File.join(@log_dir, 'ie.log')
    caps['logLevel'] = @logging['level'].upcase
  end
end

World(CapybaraHelper)

Before('~@headless', '~@janus_service') do
  raise MediTAFException, 'Configuration has not been loaded from MediTAF' unless $config

  CapybaraHelper.config(CapybaraHelper.setup($config['ui']['capybara'], $config['logging'], $config['ui']['browser']))
end
